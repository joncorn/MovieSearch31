//
//  MovieTableViewCell.swift
//  MoveSearch31
//
//  Created by Jon Corn on 1/24/20.
//  Copyright © 2020 jdcorn. All rights reserved.
//

import UIKit

class MovieTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    var movieLanding: Movie? {
        didSet {
            updateViews()
        }
    }

    // MARK: - Outlets
    @IBOutlet weak var moviePosterImageView: UIImageView!
    @IBOutlet weak var movieTitleLabel: UILabel!
    @IBOutlet weak var movieRatingLabel: UILabel!
    @IBOutlet weak var movieOverviewTextView: UITextView!
    
    // MARK: - Methods
    func updateViews() {
        guard let movie = self.movieLanding else { return }
        MovieController.getImage(movie: movie) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let image):
                    self.moviePosterImageView.image = image
                case .failure(let error):
                    print(error, error.localizedDescription)
                }
                self.movieTitleLabel.text = movie.title
                self.movieRatingLabel.text = "Rating: \(movie.rating)"
                self.movieOverviewTextView.text = movie.overview
            }
        }
    }
}
