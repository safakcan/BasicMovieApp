//
//  Uploader.swift
//  MADNetwork
//
//  Created by Bilal Arslan on 22.09.2021.
//  Copyright © 2021 Madduck. All rights reserved.
//
#if os(iOS)
import UIKit
#endif

public typealias Handler<T> = (T) -> Void

public enum MimeType: String {
    case jpg
    case jpeg
    case png
    case pdf
    case gif
}

public enum UploadData {
    case data(name: String, data: Data, mimeType: String)
    case text(name: String, value: String)
}

public typealias UploadDelegate = URLSessionDelegate & URLSessionTaskDelegate & URLSessionDataDelegate

public class Uploader<EndpointType: Endpoint>: NSObject, UploadDelegate {

    private var task: URLSessionTask?
    private var request: EndpointType?
    private var progressCompletion: Handler<Float>
    private var errorCompletion: Handler<Error?>
    private var completion: Handler<EndpointType.Response?>

    public init(request: EndpointType,
         progressCompletion: @escaping Handler<Float>,
         errorCompletion: @escaping Handler<Error?>,
         completion: @escaping Handler<EndpointType.Response?>) {
        self.request = request
        self.progressCompletion = progressCompletion
        self.errorCompletion = errorCompletion
        self.completion = completion
    }

    @discardableResult
    public func upload(uploadData: [UploadData]) -> URLSessionTask? {
        do {
            guard let request = request else { return nil }
            let configuration = URLSessionConfiguration.default
            let session = URLSession(configuration: configuration,
                                     delegate: self,
                                     delegateQueue: .main)

            var urlRequest: URLRequest = try request.asURLRequest()
            urlRequest.setValue("Keep-Alive", forHTTPHeaderField: "Connection")

            let boundary: String = UUID().uuidString
            urlRequest.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

            var bodyData = Data()

            for upData in uploadData {
                if case let .data(name, data, mimeType) = upData {
                    // Add the image data to the raw http request data
                    bodyData.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
                    bodyData.append("Content-Disposition: form-data; name=\"\(name)\"; filename=\"\(boundary).jpeg\"\r\n".data(using: .utf8)!)
                    bodyData.append("Content-Type: image/\(mimeType)\r\n\r\n".data(using: .utf8)!)
                    bodyData.append(data)
                    bodyData.append("\r\n".data(using: .utf8)!)
                } else if case let .text(name, value) = upData {
                    bodyData.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
                    bodyData.append("Content-Disposition: form-data; name=\"\(name)\";\r\n".data(using: .utf8)!)
                    bodyData.append("\r\n".data(using: .utf8)!)
                    bodyData.append("\(value)\r\n".data(using: .utf8)!)
                }
            }

            // End the raw http request data, note that there is 2 extra dash ("-") at the end, this is to indicate the end of the data
            // According to the HTTP 1.1 specification https://tools.ietf.org/html/rfc723
            bodyData.append("--\(boundary)--".data(using: .utf8)!)

            urlRequest.setValue(String(bodyData.count), forHTTPHeaderField: "Content-Lenght")

            task = session.uploadTask(with: urlRequest, from: bodyData, completionHandler: { (data, response, error) in
                do {
                    try self.handleRequest(data: data, response: response, error: error)
                } catch {
                    self.errorCompletion(error)
                }
            })
            task?.resume()
        } catch {
            errorCompletion(error)
        }
        return task
    }

    public func cancel() {
        task?.cancel()
    }

    private func handleRequest(data: Data?, response: URLResponse?, error: Error?) throws {
        if error != nil, let response = response as? HTTPURLResponse {
            let error = response.filterStatusCode(with: data)
            DispatchQueue
                .main
                .async {
                    self.errorCompletion(error)
            }
            return
        }

        if let response = response as? HTTPURLResponse {
            if NetworkManager.shared.isLogEnabled {
                print("Response: \(response.debugDescription)")
            }

            do {
                let responseData = try response.filterSuccessData(with: data)
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .secondsSince1970
                let apiResponse = try? decoder.decode(EndpointType.Response.self, from: responseData)
                DispatchQueue
                    .main
                    .async {
                        self.completion(apiResponse)
                }

            } catch {
                debugPrint(error)
                DispatchQueue
                    .main
                    .async {
                        self.errorCompletion(error)
                }

            }
        }

    }

    public func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        errorCompletion(error)
    }

    public func urlSession(_ session: URLSession, task: URLSessionTask, didSendBodyData bytesSent: Int64, totalBytesSent: Int64, totalBytesExpectedToSend: Int64) {
        let uploadProgress: Float = Float(totalBytesSent) / Float(totalBytesExpectedToSend)
        progressCompletion(uploadProgress)
    }

}
