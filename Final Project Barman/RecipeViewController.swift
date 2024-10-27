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
        view.backgroundColor = UIColor(patternImage: UIImage(named: "bar_background")!) // Background image
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
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)

        NSLayoutConstraint.activate([
            // Constraints for scrollView
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            // Constraints for contentView
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])

        // Configure UI elements
        configureLabel(nameLabel, text: "Name")
        configureTextField(nameTextField)

        configureLabel(ingredientsLabel, text: "Ingredients")
        configureTextView(ingredientsTextView)

        configureLabel(directionsLabel, text: "Instructions")
        configureTextView(directionsTextView)

        // Set imageView to scale to fit rather than cropping
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 10
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false

        saveButton.setTitle("Save Recipe", for: .normal)
        saveButton.setTitleColor(.white, for: .normal)
        saveButton.backgroundColor = UIColor.systemGreen
        saveButton.layer.cornerRadius = 10
        saveButton.titleLabel?.font = UIFont(name: "AvenirNext-DemiBold", size: 18)
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)

        // Add subviews
        contentView.addSubview(nameLabel)
        contentView.addSubview(nameTextField)
        contentView.addSubview(ingredientsLabel)
        contentView.addSubview(ingredientsTextView)
        contentView.addSubview(directionsLabel)
        contentView.addSubview(directionsTextView)
        contentView.addSubview(imageView)
        contentView.addSubview(saveButton)

        setupConstraints()
    }

    func configureLabel(_ label: UILabel, text: String) {
        label.text = text
        label.font = UIFont(name: "AvenirNext-DemiBold", size: 18)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
    }

    func configureTextField(_ textField: UITextField) {
        textField.borderStyle = .roundedRect
        textField.backgroundColor = UIColor(white: 1.0, alpha: 0.8)
        textField.translatesAutoresizingMaskIntoConstraints = false
    }

    func configureTextView(_ textView: UITextView) {
        textView.layer.borderWidth = 1
        textView.layer.borderColor = UIColor.lightGray.cgColor
        textView.layer.cornerRadius = 10
        textView.font = UIFont(name: "AvenirNext-Regular", size: 16)
        textView.backgroundColor = UIColor(white: 1.0, alpha: 0.8)
        textView.translatesAutoresizingMaskIntoConstraints = false
    }

    func setupConstraints() {
        let padding: CGFloat = 16

        NSLayoutConstraint.activate([
            // nameLabel
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: padding),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            nameLabel.heightAnchor.constraint(equalToConstant: 24),

            // nameTextField
            nameTextField.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            nameTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            nameTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            nameTextField.heightAnchor.constraint(equalToConstant: 40),

            // ingredientsLabel
            ingredientsLabel.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: padding),
            ingredientsLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            ingredientsLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            ingredientsLabel.heightAnchor.constraint(equalToConstant: 24),

            // ingredientsTextView
            ingredientsTextView.topAnchor.constraint(equalTo: ingredientsLabel.bottomAnchor, constant: 8),
            ingredientsTextView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            ingredientsTextView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            ingredientsTextView.heightAnchor.constraint(equalToConstant: 150),

            // directionsLabel
            directionsLabel.topAnchor.constraint(equalTo: ingredientsTextView.bottomAnchor, constant: padding),
            directionsLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            directionsLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            directionsLabel.heightAnchor.constraint(equalToConstant: 24),

            // directionsTextView
            directionsTextView.topAnchor.constraint(equalTo: directionsLabel.bottomAnchor, constant: 8),
            directionsTextView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            directionsTextView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            directionsTextView.heightAnchor.constraint(equalToConstant: 150),

            // imageView
            imageView.topAnchor.constraint(equalTo: directionsTextView.bottomAnchor, constant: padding),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            imageView.heightAnchor.constraint(equalToConstant: 200),

            // saveButton
            saveButton.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: padding),
            saveButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            saveButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            saveButton.heightAnchor.constraint(equalToConstant: 50),
            saveButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -padding)
        ])
    }

    func displayRecipe() {
        guard let drink = drink else { return }

        // Set the fields with the drink data
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
                    self?.imageView.image = UIImage(named: "placeholder")  // Placeholder image if needed
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

        imageView.isHidden = true  // Hide the image when adding a new recipe
        saveButton.isHidden = false  // Show the save button
    }

    @objc func saveButtonTapped() {
        // Validate and save the new recipe
        guard let name = nameTextField.text, !name.isEmpty,
              let ingredients = ingredientsTextView.text, !ingredients.isEmpty,
              let directions = directionsTextView.text, !directions.isEmpty else {
            // Show alert if any field is empty
            let alert = UIAlertController(title: "Error", message: "Please fill all fields.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
            return
        }

        // Create a new Drink object
        let newDrink = Drink(name: name, ingredients: ingredients, directions: directions, img: "")

        // Add the new drink to DataManager
        DataManager.shared.addUserDrink(newDrink)

        // Return to the list of drinks
        navigationController?.popViewController(animated: true)
    }
}
