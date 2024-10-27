//
//  DrinkTableViewCell.swift
//  Project Barman
//
//  Created by Carlos Ignacio Padilla Herrera on 26/10/2024.
//
//  Description: This custom table view cell is used to display drink information, including an image and the drink's name, in a visually appealing layout with a background container and rounded image corners.
//
//  Created for: Enigma Unit
//  Version: 1.0.0
//  Copyright © 2024 Enigma Unit. All rights reserved.
//
import UIKit

// The DrinkTableViewCell class is declared, inheriting from UITableViewCell.
class DrinkTableViewCell: UITableViewCell {

    // The drinkImageView displays the image of the drink.
    let drinkImageView = UIImageView()

    // The nameLabel displays the name of the drink.
    let nameLabel = UILabel()

    // The containerView provides a background to hold the image and label, making the cell more visually distinct.
    let containerView = UIView()

    // The initializer method is used when creating the cell programmatically.
    // The style and reuseIdentifier are passed to the superclass initializer.
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        // The cell is set up with its components and layout.
        setupCell()
    }

    // This initializer is required for cases where the cell is loaded from a storyboard or xib.
    // Since this implementation does not use storyboard/xib, it throws an error.
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // The setupCell method is responsible for configuring the layout and appearance of the cell.
    func setupCell() {
        // The background color of the cell is set to clear.
        backgroundColor = .clear

        // The selection style is set to none to prevent the cell from highlighting when selected.
        selectionStyle = .none

        // The containerView is configured to provide a semi-transparent black background with rounded corners.
        containerView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        containerView.layer.cornerRadius = 10
        containerView.translatesAutoresizingMaskIntoConstraints = false

        // The containerView is added to the content view of the cell.
        contentView.addSubview(containerView)

        // The drinkImageView is configured to maintain the aspect ratio of the image, with rounded corners and clipping.
        drinkImageView.contentMode = .scaleAspectFill
        drinkImageView.layer.cornerRadius = 10
        drinkImageView.clipsToBounds = true
        drinkImageView.translatesAutoresizingMaskIntoConstraints = false

        // The drinkImageView is added as a subview of the containerView.
        containerView.addSubview(drinkImageView)

        // The nameLabel is configured to use the "AvenirNext-DemiBold" font, with white text color and support for multiple lines.
        nameLabel.font = UIFont(name: "AvenirNext-DemiBold", size: 18)
        nameLabel.textColor = .white
        nameLabel.numberOfLines = 0  // Allows multiple lines for long drink names.
        nameLabel.translatesAutoresizingMaskIntoConstraints = false

        // The nameLabel is added as a subview of the containerView.
        containerView.addSubview(nameLabel)

        // Auto-layout constraints are set for the containerView, drinkImageView, and nameLabel.
        NSLayoutConstraint.activate([
            // Constraints for the containerView to provide padding around the cell.
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

            // Fixed size constraints for the drinkImageView to display the image.
            drinkImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 12),
            drinkImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            drinkImageView.widthAnchor.constraint(equalToConstant: 80),
            drinkImageView.heightAnchor.constraint(equalToConstant: 80),

            // Constraints for the nameLabel, positioned to the right of the drinkImageView.
            nameLabel.leadingAnchor.constraint(equalTo: drinkImageView.trailingAnchor, constant: 20),
            nameLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            nameLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 20),
            nameLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -20)
        ])
    }

    // The configure method is used to populate the cell with drink data.
    // It sets the nameLabel text and loads the image for the drink.
    func configure(with drink: Drink) {
        // The nameLabel is set to the name of the drink.
        nameLabel.text = drink.name

        // The drink's image is loaded asynchronously from the DataManager.
        DataManager.shared.getImage(for: drink.img) { [weak self] image in
            // The UI is updated on the main thread to set the image or a placeholder if not available.
            DispatchQueue.main.async {
                self?.drinkImageView.image = image ?? UIImage(named: "placeholder")
            }
        }
    }
}
