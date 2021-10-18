//
//  BasicMovieDetailViewController.swift
//  BasicMovieApp
//
//  Created by Madduck on 17.10.2021.
//

import UIKit

class BasicMovieDetailViewController: UIViewController {
    
    @IBOutlet var posterImage: UIImageView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var descLabel: UILabel!
    @IBOutlet var voteLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var imageViewContainer : UIView!
    
    var movie : MoviesPresentation?
    var posterPath = "https://themoviedb.org/t/p/original"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configrue()
    }
    
    func configrue() {
        guard  let poster = movie?.posterPath else {return}
        guard let data = try? Data(contentsOf: URL(string: (posterPath + poster))!) else {return}
        
        imageViewContainer.layer.cornerRadius = 5
        posterImage.image = UIImage(data: data)
        
        titleLabel.text = movie?.title
        descLabel.text = movie?.overview
        voteLabel.text = String(Int((movie?.voteAverage)!))
        dateLabel.text = movie?.releaseDate
    }
}
