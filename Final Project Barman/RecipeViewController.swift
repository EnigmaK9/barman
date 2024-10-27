//
//  RecipeViewController.swift
//  Project Barman
//
//  Created by Carlos Ignacio Padilla Herrera on 26/10/2024.
//
//  Description: This view controller is responsible for displaying a single recipe or allowing the user to add a new recipe. It provides UI for entering the name, ingredients, and directions of a drink, and handles saving new recipes to DataManager.
//
//  Created for: Enigma Unit
//  Version: 1.0.0
//  Copyright © 2024 Enigma Unit. All rights reserved.
//
import UIKit

// The RecipeViewController class is declared, inheriting from UIViewController.
class RecipeViewController: UIViewController {

    // The drink object holds the recipe data, if available.
    var drink: Drink?

    // This flag indicates whether the view controller is used for adding a new recipe.
    var isAddingNewRecipe = false

    // The scroll view is used to enable scrolling for long content.
    let scrollView = UIScrollView()

    // The content view contains all UI elements inside the scroll view.
    let contentView = UIView()

    // UILabel and UITextField for entering or displaying the drink's name.
    let nameLabel = UILabel()
    let nameTextField = UITextField()

    // UILabel and UITextView for entering or displaying the ingredients.
    let ingredientsLabel = UILabel()
    let ingredientsTextView = UITextView()

    // UILabel and UITextView for entering or displaying the directions.
    let directionsLabel = UILabel()
    let directionsTextView = UITextView()

    // UIImageView for displaying the drink image.
    let imageView = UIImageView()

    // UIButton for saving the new recipe.
    let saveButton = UIButton(type: .system)

    // viewDidLoad is called when the view is first loaded into memory.
    // It is used to set up the UI elements and determine if the view is for displaying or adding a recipe.
    override func viewDidLoad() {
        super.viewDidLoad()

        // The background color is set to an image pattern.
        view.backgroundColor = UIColor(patternImage: UIImage(named: "bar_background")!)

        // UI elements are set up using helper methods.
        setupViews()

        // If the view is for adding a new recipe, the title and UI are set accordingly.
        if isAddingNewRecipe {
            title = "Add Recipe"
            setupForNewRecipe()
        } else {
            // If displaying an existing recipe, the title is set to the drink's name and the data is displayed.
            title = drink?.name
            displayRecipe()
        }
    }

    // setupViews sets up the scrollView, contentView, and all other UI elements like labels and text fields.
    func setupViews() {
        // Auto-layout is used, so translatesAutoresizingMaskIntoConstraints is disabled for the views.
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false

        // The scrollView is added to the main view.
        view.addSubview(scrollView)
        
        // The contentView is added inside the scrollView to hold all UI elements.
        scrollView.addSubview(contentView)

        // Constraints are set for the scrollView and contentView to ensure proper layout.
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])

        // Individual UI elements are configured using helper functions.
        configureLabel(nameLabel, text: "Name")
        configureTextField(nameTextField)

        configureLabel(ingredientsLabel, text: "Ingredients")
        configureTextView(ingredientsTextView)

        configureLabel(directionsLabel, text: "Instructions")
        configureTextView(directionsTextView)

        // The imageView is set to maintain the aspect ratio of the image and is rounded.
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 10
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false

        // The saveButton is styled and connected to its action method.
        saveButton.setTitle("Save Recipe", for: .normal)
        saveButton.setTitleColor(.white, for: .normal)
        saveButton.backgroundColor = UIColor.systemBlue
        saveButton.layer.cornerRadius = 10
        saveButton.titleLabel?.font = UIFont(name: "AvenirNext-DemiBold", size: 18)
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)

        // All the UI elements are added to the contentView.
        contentView.addSubview(nameLabel)
        contentView.addSubview(nameTextField)
        contentView.addSubview(ingredientsLabel)
        contentView.addSubview(ingredientsTextView)
        contentView.addSubview(directionsLabel)
        contentView.addSubview(directionsTextView)
        contentView.addSubview(imageView)
        contentView.addSubview(saveButton)

        // Constraints are set for all the UI elements to ensure proper layout.
        setupConstraints()
    }

    // Helper method to configure labels with text and styling.
    func configureLabel(_ label: UILabel, text: String) {
        label.text = text
        label.font = UIFont(name: "AvenirNext-DemiBold", size: 18)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
    }

    // Helper method to configure text fields with styling.
    func configureTextField(_ textField: UITextField) {
        textField.borderStyle = .roundedRect
        textField.backgroundColor = UIColor(white: 1.0, alpha: 0.8)
        textField.translatesAutoresizingMaskIntoConstraints = false
    }

    // Helper method to configure text views with styling.
    func configureTextView(_ textView: UITextView) {
        textView.layer.borderWidth = 1
        textView.layer.borderColor = UIColor.lightGray.cgColor
        textView.layer.cornerRadius = 10
        textView.font = UIFont(name: "AvenirNext-Regular", size: 16)
        textView.backgroundColor = UIColor(white: 1.0, alpha: 0.8)
        textView.translatesAutoresizingMaskIntoConstraints = false
    }

    // setupConstraints sets the layout constraints for all UI elements to define their positions on the screen.
    func setupConstraints() {
        let padding: CGFloat = 16

        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: padding),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            nameLabel.heightAnchor.constraint(equalToConstant: 24),

            nameTextField.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            nameTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            nameTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            nameTextField.heightAnchor.constraint(equalToConstant: 40),

            ingredientsLabel.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: padding),
            ingredientsLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            ingredientsLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            ingredientsLabel.heightAnchor.constraint(equalToConstant: 24),

            ingredientsTextView.topAnchor.constraint(equalTo: ingredientsLabel.bottomAnchor, constant: 8),
            ingredientsTextView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            ingredientsTextView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            ingredientsTextView.heightAnchor.constraint(equalToConstant: 150),

            directionsLabel.topAnchor.constraint(equalTo: ingredientsTextView.bottomAnchor, constant: padding),
            directionsLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            directionsLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            directionsLabel.heightAnchor.constraint(equalToConstant: 24),

            directionsTextView.topAnchor.constraint(equalTo: directionsLabel.bottomAnchor, constant: 8),
            directionsTextView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            directionsTextView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            directionsTextView.heightAnchor.constraint(equalToConstant: 150),

            imageView.topAnchor.constraint(equalTo: directionsTextView.bottomAnchor, constant: padding),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            imageView.heightAnchor.constraint(equalToConstant: 200),

            saveButton.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: padding-50),
            saveButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            saveButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            saveButton.heightAnchor.constraint(equalToConstant: 50),
            saveButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -padding)
        ])
    }

    // displayRecipe sets the fields with data from the drink object if a recipe is being displayed.
    func displayRecipe() {
        guard let drink = drink else { return }

        // The name, ingredients, and directions are set from the drink data.
        nameTextField.text = drink.name
        nameTextField.isEnabled = false

        ingredientsTextView.text = drink.ingredients
        ingredientsTextView.isEditable = false

        directionsTextView.text = drink.directions
        directionsTextView.isEditable = false

        // The save button is hidden since this is a view-only mode.
        saveButton.isHidden = true

        // The image is loaded using the DataManager.
        DataManager.shared.getImage(for: drink.img) { [weak self] image in
            DispatchQueue.main.async {
                if let image = image {
                    self?.imageView.image = image
                } else {
                    // A placeholder image is set if no image is found.
                    self?.imageView.image = UIImage(named: "placeholder")
                }
            }
        }
    }

    // setupForNewRecipe configures the UI for adding a new recipe.
    func setupForNewRecipe() {
        // All fields are cleared and enabled for editing.
        nameTextField.text = ""
        nameTextField.isEnabled = true

        ingredientsTextView.text = ""
        ingredientsTextView.isEditable = true

        directionsTextView.text = ""
        directionsTextView.isEditable = true

        // The image is hidden, and the save button is shown when adding a new recipe.
        imageView.isHidden = true
        saveButton.isHidden = false
    }

    // saveButtonTapped is called when the save button is pressed to save the new recipe.
    @objc func saveButtonTapped() {
        // Validation is performed to ensure all fields are filled in.
        guard let name = nameTextField.text, !name.isEmpty,
              let ingredients = ingredientsTextView.text, !ingredients.isEmpty,
              let directions = directionsTextView.text, !directions.isEmpty else {
            // An alert is shown if any field is empty.
            let alert = UIAlertController(title: "Error", message: "Please fill all fields.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
            return
        }

        // A new Drink object is created with the entered data.
        let newDrink = Drink(name: name, ingredients: ingredients, directions: directions, img: "")

        // The new drink is added to DataManager.
        DataManager.shared.addUserDrink(newDrink)

        // The view controller is dismissed, returning to the previous screen.
        navigationController?.popViewController(animated: true)
    }
}
