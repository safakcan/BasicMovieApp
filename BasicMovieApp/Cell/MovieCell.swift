//
//  MovieCell.swift
//  BasicMovieApp
//
//  Created by Madduck on 14.10.2021.
//

import UIKit
import Kingfisher

class MovieCell: UITableViewCell {
    @IBOutlet weak var movieImageView: UIImageView!
    @IBOutlet weak var movieName: UILabel!
    @IBOutlet weak var movieDesc: UILabel!
    @IBOutlet weak var containerView: UIView!
    static var identifier = "MovieCell"

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        containerView.layer.cornerRadius = 5
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(with model: MoviesPresentation?) {
        
        guard let model = model else {return}
        movieName.text = model.title
        movieDesc.text = model.overview
        guard  let poster = model.posterPath else {return}
        let url = URL(string: NetworkUtils.posterPath + poster)
        movieImageView.kf.setImage(with: url)
    }
    
    func nib() -> UINib {
        return UINib(nibName: "MovieCell", bundle: nil)
    }
    
}
