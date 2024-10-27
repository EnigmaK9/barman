// DrinksListViewController.swift
// Created by Carlos Ignacio Padilla Herrera on 26/10/2024
//
// This view controller is responsible for displaying a list of drinks.
// It uses a UITableView to show the drinks and a navigation bar button to allow the user to add new drinks.

import UIKit

// The DrinksListViewController class is declared, inheriting from UIViewController.
class DrinksListViewController: UIViewController {

    // A UITableView instance is created to display the list of drinks.
    let tableView = UITableView()

    // A UIBarButtonItem is created to serve as the "add" button on the navigation bar.
    // This button allows users to add new drinks.
    let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: nil, action: nil)

    // The viewDidLoad method is called when the view controller's view is loaded into memory.
    // Setup methods for the table view and navigation bar are called here.
    override func viewDidLoad() {
        super.viewDidLoad()

        // The title of the navigation bar is set to "Barman's Drinks".
        self.title = "Barman's Drinks"

        // The background color of the view is set using a pattern image named "bar_background".
        view.backgroundColor = UIColor(patternImage: UIImage(named: "bar_background")!)

        // The table view setup is initialized.
        setupTableView()

        // The navigation bar setup is initialized.
        setupNavigationBar()

        // The drink data is fetched from the DataManager to populate the table view.
        fetchDrinksData()
    }

    // The viewWillAppear method is called just before the view is added to the screen.
    // It ensures that the table view is refreshed with any updated data.
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        // The table view is reloaded to ensure the data displayed is up to date.
        tableView.reloadData()
    }

    // The setupTableView method configures the appearance and behavior of the table view.
    func setupTableView() {
        // The table view's frame is set to match the bounds of the view controller's main view.
        tableView.frame = view.bounds

        // The background color of the table view is set to clear, allowing the background image to be visible.
        tableView.backgroundColor = .clear

        // The custom cell DrinkTableViewCell is registered for reuse with the identifier "DrinkCell".
        tableView.register(DrinkTableViewCell.self, forCellReuseIdentifier: "DrinkCell")

        // The view controller is set as the data source and delegate of the table view.
        tableView.dataSource = self
        tableView.delegate = self

        // The separator lines between table view cells are removed for a cleaner appearance.
        tableView.separatorStyle = .none

        // The table view is added as a subview of the main view.
        view.addSubview(tableView)
    }

    // The setupNavigationBar method configures the navigation bar's appearance and adds the "add" button.
    func setupNavigationBar() {
        // The target and action of the "add" button are set to the view controller's addButtonTapped method.
        addButton.target = self
        addButton.action = #selector(addButtonTapped)

        // The "add" button is added to the right side of the navigation bar.
        navigationItem.rightBarButtonItem = addButton

        // The background color of the navigation bar is set to dark gray.
        navigationController?.navigationBar.barTintColor = UIColor.darkGray

        // The text color of the navigation bar's title is set to white.
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
    }

    // The fetchDrinksData method calls the DataManager to download the drinks and reload the table view when complete.
    func fetchDrinksData() {
        // The drinks data is downloaded asynchronously using DataManager.
        DataManager.shared.downloadDrinksData { [weak self] drinks in
            // The UI is updated on the main thread after the data is downloaded.
            DispatchQueue.main.async {
                // If drinks are successfully downloaded, the table view is reloaded.
                if drinks != nil {
                    self?.tableView.reloadData()
                } else {
                    // Error handling can be added here, such as showing an alert to the user.
                }
            }
        }
    }

    // The addButtonTapped method is triggered when the "add" button is pressed.
    // It navigates to the RecipeViewController to allow the user to add a new drink.
    @objc func addButtonTapped() {
        // An instance of RecipeViewController is created and its 'isAddingNewRecipe' property is set to true.
        let addRecipeVC = RecipeViewController()
        addRecipeVC.isAddingNewRecipe = true

        // The RecipeViewController is pushed onto the navigation stack to present the add recipe screen.
        navigationController?.pushViewController(addRecipeVC, animated: true)
    }
}

// An extension is added to conform to UITableViewDataSource and UITableViewDelegate protocols,
// allowing the view controller to manage and respond to table view events.
extension DrinksListViewController: UITableViewDataSource, UITableViewDelegate {

    // The numberOfRowsInSection method returns the number of rows in the table view.
    // This is based on the number of drinks available in the DataManager.
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DataManager.shared.drinks.count
    }

    // The cellForRowAt method is called to provide the table view with a cell for each row.
    // It dequeues reusable cells and configures them with the drink data.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // A reusable cell of type DrinkTableViewCell is dequeued using the identifier "DrinkCell".
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "DrinkCell", for: indexPath) as? DrinkTableViewCell else {
            // If the cell cannot be dequeued, a new empty UITableViewCell is returned as a fallback.
            return UITableViewCell()
        }

        // The drink for the current row is retrieved from the DataManager.
        let drink = DataManager.shared.drinks[indexPath.row]

        // The cell is configured with the drink data.
        cell.configure(with: drink)

        // The configured cell is returned for display.
        return cell
    }

    // The didSelectRowAt method is called when a user selects a row in the table view.
    // It navigates to the RecipeViewController to display the details of the selected drink.
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // The selected drink is retrieved from the DataManager.
        let drink = DataManager.shared.drinks[indexPath.row]

        // A new instance of RecipeViewController is created and the selected drink is passed to it.
        let recipeVC = RecipeViewController()
        recipeVC.drink = drink

        // The RecipeViewController is pushed onto the navigation stack to present the drink details.
        navigationController?.pushViewController(recipeVC, animated: true)
    }
}
