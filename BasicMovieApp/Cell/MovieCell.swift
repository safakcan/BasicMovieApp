//
//  MovieCell.swift
//  BasicMovieApp
//
//  Created by Madduck on 14.10.2021.
//

import UIKit

class MovieCell: UITableViewCell {
    @IBOutlet weak var movieImageView: UIImageView!
    @IBOutlet weak var movieName: UILabel!
    @IBOutlet weak var movieDesc: UILabel!
    @IBOutlet weak var containerView: UIView!
    static var identifier = "MovieCell"
    var posterPath = "https://themoviedb.org/t/p/original"
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
//        add kingfisher to upload images
        guard let model = model else {return}
        movieName.text = model.title
        movieDesc.text = model.overview
        guard  let poster = model.posterPath else {return}
        guard let data = try? Data(contentsOf: URL(string: (posterPath + poster))!) else {return}
        movieImageView.image = UIImage(data: data)
    }
    
    func nib() -> UINib {
        return UINib(nibName: "MovieCell", bundle: nil)
    }
    
}
