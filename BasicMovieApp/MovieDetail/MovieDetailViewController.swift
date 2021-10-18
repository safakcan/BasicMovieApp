//
//  BasicMovieDetailViewController.swift
//  BasicMovieApp
//
//  Created by Madduck on 17.10.2021.
//

import UIKit
import Kingfisher

class MovieDetailViewController: UIViewController {
    
    @IBOutlet var posterImage: UIImageView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var descLabel: UILabel!
    @IBOutlet var voteLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var imageViewContainer : UIView!
    
    var movie : MoviesPresentation?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configrue()
    }
    
    func configrue() {
        guard  let poster = movie?.posterPath else {return}
        let url = URL(string: NetworkUtils.posterPath + poster)
        posterImage.kf.setImage(with: url)
        
        imageViewContainer.layer.cornerRadius = 5
        
        titleLabel.text = movie?.title
        descLabel.text = movie?.overview
        voteLabel.text = String(Int((movie?.voteAverage)!))
        dateLabel.text = movie?.releaseDate
    }
}
