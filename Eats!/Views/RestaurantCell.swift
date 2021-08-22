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
    
    @IBOutlet weak var locationImage: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var ratingView: UIStackView!
    @IBOutlet weak var ratingCount: UILabel!
    @IBOutlet weak var underText: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!
    
    var model: Restaurant?
    
    func configure(model: Restaurant) {
        self.model = model
        locationImage.image = model.image
        name.text = model.name
        underText.text = model.description
        updateFavorite(model)
        setupRatings(model)
    }
    
    private func updateFavorite(_ model: Restaurant) {
        let favoriteImage = model.isFavorite ? UIImage(named: "Favorited") : UIImage(named: "UnFavorited")
        favoriteButton.setImage(favoriteImage, for: .normal)
    }
    
    // This assumes we have only integer values for the ratings, as per design.
    private func setupRatings(_ model: Restaurant) {
        for rating in 0..<5 {
            let imageView = UIImageView()
            imageView.image = model.rating > rating ? UIImage(named: "Star") : UIImage(named: "UnStar")
            imageView.contentMode = .scaleAspectFit
            ratingView.addArrangedSubview(imageView)
        }
        ratingCount.text = "(\(model.ratingCount))"
        ratingCount.font = UIFont(name: "ProximaNova-Light", size: 12)
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
