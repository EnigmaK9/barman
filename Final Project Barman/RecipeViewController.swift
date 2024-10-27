//
//  RecipeViewController.swift
//  Final Project Barman
//
//  Created by Carlos Ignacio Padilla Herrera on 26/10/24.
//
// RecipeViewController.swift

import UIKit

class RecipeViewController: UIViewController {
    var drink: Drink?
    var isAddingNewRecipe = false

    let scrollView = UIScrollView()
    let contentView = UIView()

    let nameLabel = UILabel()
    let nameTextField = UITextField()

    let ingredientsLabel = UILabel()
    let ingredientsTextView = UITextView()

    let directionsLabel = UILabel()
    let directionsTextView = UITextView()

    let imageView = UIImageView()

    let saveButton = UIButton(type: .system)

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupViews()
        
        if isAddingNewRecipe {
            title = "Add Recipe"
            setupForNewRecipe()
        } else {
            title = drink?.name
            displayRecipe()
        }
    }

    func setupViews() {
        // Setup scrollView and contentView
        scrollView.frame = view.bounds
        view.addSubview(scrollView)
        contentView.frame = scrollView.bounds
        scrollView.addSubview(contentView)
        
        // Name Label and TextField
        nameLabel.text = "Name"
        nameLabel.font = UIFont.boldSystemFont(ofSize: 18)
        contentView.addSubview(nameLabel)
        
        nameTextField.borderStyle = .roundedRect
        contentView.addSubview(nameTextField)
        
        // Ingredients Label and TextView
        ingredientsLabel.text = "Ingredients"
        ingredientsLabel.font = UIFont.boldSystemFont(ofSize: 18)
        contentView.addSubview(ingredientsLabel)
        
        ingredientsTextView.layer.borderWidth = 1
        ingredientsTextView.layer.borderColor = UIColor.lightGray.cgColor
        ingredientsTextView.layer.cornerRadius = 5
        contentView.addSubview(ingredientsTextView)
        
        // Directions Label and TextView
        directionsLabel.text = "Directions"
        directionsLabel.font = UIFont.boldSystemFont(ofSize: 18)
        contentView.addSubview(directionsLabel)
        
        directionsTextView.layer.borderWidth = 1
        directionsTextView.layer.borderColor = UIColor.lightGray.cgColor
        directionsTextView.layer.cornerRadius = 5
        contentView.addSubview(directionsTextView)
        
        // ImageView
        imageView.contentMode = .scaleAspectFit
        contentView.addSubview(imageView)
        
        // Save Button
        saveButton.setTitle("Save Recipe", for: .normal)
        saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        contentView.addSubview(saveButton)
        
        // Layout using frames or AutoLayout
        layoutViews()
    }

    func layoutViews() {
        // Using manual frames for simplicity
        let padding: CGFloat = 16
        let labelHeight: CGFloat = 20
        let textFieldHeight: CGFloat = 30
        let textViewHeight: CGFloat = 100
        var yOffset: CGFloat = padding
        
        // Name Label
        nameLabel.frame = CGRect(x: padding, y: yOffset, width: view.bounds.width - 2 * padding, height: labelHeight)
        yOffset += labelHeight + 5
        
        // Name TextField
        nameTextField.frame = CGRect(x: padding, y: yOffset, width: view.bounds.width - 2 * padding, height: textFieldHeight)
        yOffset += textFieldHeight + padding
        
        // Ingredients Label
        ingredientsLabel.frame = CGRect(x: padding, y: yOffset, width: view.bounds.width - 2 * padding, height: labelHeight)
        yOffset += labelHeight + 5
        
        // Ingredients TextView
        ingredientsTextView.frame = CGRect(x: padding, y: yOffset, width: view.bounds.width - 2 * padding, height: textViewHeight)
        yOffset += textViewHeight + padding
        
        // Directions Label
        directionsLabel.frame = CGRect(x: padding, y: yOffset, width: view.bounds.width - 2 * padding, height: labelHeight)
        yOffset += labelHeight + 5
        
        // Directions TextView
        directionsTextView.frame = CGRect(x: padding, y: yOffset, width: view.bounds.width - 2 * padding, height: textViewHeight)
        yOffset += textViewHeight + padding
        
        // ImageView
        imageView.frame = CGRect(x: padding, y: yOffset, width: view.bounds.width - 2 * padding, height: 200)
        yOffset += 200 + padding
        
        // Save Button
        saveButton.frame = CGRect(x: padding, y: yOffset, width: view.bounds.width - 2 * padding, height: 44)
        yOffset += 44 + padding
        
        // Adjust contentView and scrollView content size
        contentView.frame.size.height = yOffset
        scrollView.contentSize = CGSize(width: view.bounds.width, height: yOffset)
    }

    func displayRecipe() {
        guard let drink = drink else { return }
        
        // Set the text fields and text views with the drink's data
        nameTextField.text = drink.name
        nameTextField.isEnabled = false
        
        ingredientsTextView.text = drink.ingredients
        ingredientsTextView.isEditable = false
        
        directionsTextView.text = drink.directions
        directionsTextView.isEditable = false
        
        saveButton.isHidden = true  // Hide the save button when viewing a recipe
        
        // Load the image
        DataManager.shared.getImage(for: drink.img) { [weak self] image in
            DispatchQueue.main.async {
                if let image = image {
                    self?.imageView.image = image
                } else {
                    self?.imageView.image = UIImage(named: "placeholder")  // Use a placeholder image if needed
                }
            }
        }
    }


    func setupForNewRecipe() {
        // Enable fields for editing
        nameTextField.text = ""
        nameTextField.isEnabled = true
        
        ingredientsTextView.text = ""
        ingredientsTextView.isEditable = true
        
        directionsTextView.text = ""
        directionsTextView.isEditable = true
        
        imageView.isHidden = true  // Hide the image view when adding a new recipe
        saveButton.isHidden = false  // Show the save button
    }

    @objc func saveButtonTapped() {
        // Validate and save the new recipe
        guard let name = nameTextField.text, !name.isEmpty,
              let ingredients = ingredientsTextView.text, !ingredients.isEmpty,
              let directions = directionsTextView.text, !directions.isEmpty else {
            // Show an alert if any field is empty
            let alert = UIAlertController(title: "Error", message: "Please fill all fields.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
            return
        }

        // Create a new Drink object
        let newDrink = Drink(name: name, ingredients: ingredients, directions: directions, img: "")

        // Add the new drink to the DataManager
        DataManager.shared.addUserDrink(newDrink)

        // Navigate back to the drinks list
        navigationController?.popViewController(animated: true)
    }


}
