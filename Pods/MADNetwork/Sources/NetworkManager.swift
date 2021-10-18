//
//  NetworkManager.swift
//  MADNetwork
//
//  Created by Bilal Arslan on 13.04.2021.
//

import Foundation

/// Singleton for all network operations.
public final class NetworkManager {

    public var isLogEnabled = false

    /// Voltran endpoints  access token and Enviroment
    public var voltranAccessToken: String?
    public var voltranEnvironment: Environment = Global.environment

    public static let shared = NetworkManager()

    private init() {}

    // MARK: - Public functions

    @discardableResult
    public func execute<Request: Endpoint>(request: Request, completion: ((Response<Request.Response>) -> Void)?) -> URLSessionTask? {
        let urlRequest: URLRequest
        do {
            urlRequest = try request.asURLRequest()
        } catch {
            completion?(
                Response<Request.Response>(
                    request: nil,
                    response: nil,
                    data: nil,
                    result: .failure(.parameterEncodingFailed(reason: .jsonEncodingFailed(error: error)))
                )
            )
            return nil
        }

        if isLogEnabled {
            print(urlRequest.curlString)
        }

        let task = URLSession.shared.dataTask(with: urlRequest, completionHandler: { (data, response, error) in
            var result: Result<Request.Response, NetworkingError>

            if self.isLogEnabled {
                print("Response: \(data?.prettyPrint ?? "nil") - Status Code: \(response?.httpStatusCode ?? 0)")
            }

            if let data = data, let response = response, 200..<300 ~= response.httpStatusCode {
                result = self.decode((data, response))
            } else {
                let httpError = response?.filterStatusCode(with: data) ?? .undefined(data: data)
                result = .failure(.connectionError(httpError))
            }

            DispatchQueue.main.async {
                completion?(
                    Response<Request.Response>(
                        request: urlRequest,
                        response: response as? HTTPURLResponse,
                        data: data,
                        result: result
                    )
                )
            }
        })

        task.resume()
        return task
    }

    @discardableResult
    public func upload<Request: Endpoint>(with uploader: Uploader<Request>,
                                   data: [UploadData]) -> URLSessionTask? {
        return uploader.upload(uploadData: data)
    }

    private func decode<T: Decodable>(_ pair: (data: Data, response: URLResponse)) -> Result<T, NetworkingError> {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .secondsSince1970

        if T.self == String.self || T.self == Optional<String>.self {
            return .success(String(data: pair.data, encoding: .utf8) as! T)
        }

        do {
            let decoder = JSONDecoder()
            let object = try decoder.decode(T.self, from: pair.data)
            return .success(object)
        } catch let error as DecodingError {
            return .failure(.decodingFailed(error))
        } catch {
            return .failure(.undefined)
        }
    }

}

extension URLResponse {

    var httpStatusCode: Int {
        return (self as? HTTPURLResponse)?.statusCode ?? 0
    }

    func filterSuccessData(with data: Data?) throws -> Data {
        if let responseData = data {
            return responseData
        } else {
            throw HTTPError.noData(data: nil)
        }
    }

    func filterStatusCode(with data: Data?) -> HTTPError {
        return HTTPError(statusCode: httpStatusCode, data: data) ?? .undefined(data: data)
    }

}
