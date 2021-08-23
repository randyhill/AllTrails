//
//  RestaurantCell.swift
//  Eats!
//
//  Created by Randy Hill on 8/21/21.
//

import UIKit

/// Shows a label for a settings header with a large height. Should use UITableViewAutomaticDimension.
final class RestaurantCell: UITableViewCell {
    static let reuseIdentifier = "RestaurantCell"
    
    @IBOutlet weak var bodyView: UIView!            // Used to provide border around the edges of cell.
    @IBOutlet weak var locationImage: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var ratingView: UIStackView!
    @IBOutlet weak var ratingCount: UILabel!
    @IBOutlet weak var underText: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!
    
    var model: Restaurant?
    
    func configure(model: Restaurant) {
        self.model = model
        if let image = model.image {
            locationImage.image = model.image

        } else {
            model.downloadImage { image in
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return Log.info("Nil self when image download returned")}
                    self.locationImage.image = image
                }
            }
        }
        name.text = model.name
        underText.text = model.bodyText
        updateFavorite(model)
        setupRatings(model)
        bodyView.layer.cornerRadius = 8.0
    }
    
    private func updateFavorite(_ model: Restaurant) {
        let favoriteImage = model.isFavorite ? UIImage(named: "Favorited") : UIImage(named: "UnFavorited")
        favoriteButton.setImage(favoriteImage, for: .normal)
    }
    
    // Add star images to stack view to match rating.
    // This assumes we have only integer values for the ratings, as per design.
    private func setupRatings(_ model: Restaurant) {
        // clear old first since cells are reused
        ratingView.arrangedSubviews.forEach { subviews in
            ratingView.removeArrangedSubview(subviews)
        }
        
        // Leave empty if not rated yet
        if let rating = model.rating {
            for stars in 0..<5 {
                let imageView = UIImageView()
                imageView.image = rating > stars ? UIImage(named: "Star") : UIImage(named: "UnStar")
                imageView.contentMode = .scaleAspectFit
                ratingView.addArrangedSubview(imageView)
                
                // Replace constraints
                imageView.translatesAutoresizingMaskIntoConstraints = false
                imageView.widthAnchor.constraint(equalToConstant: 20).isActive = true
                imageView.heightAnchor.constraint(equalToConstant: 20).isActive = true
            }
        }

        ratingCount.text = "(\(model.ratingCount))"
        ratingCount.textColor = UIColor.eatsGrayText
     }

    
    @IBAction func favoriteTapped(_ sender: Any) {
        guard let model = self.model else {
            return Log.error("Nil model in Restaurant Cell")
        }
        model.isFavorite = !model.isFavorite
        updateFavorite(model)
    }
}
