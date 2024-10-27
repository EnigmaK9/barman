// DrinksListViewController.swift

import UIKit

class DrinksListViewController: UIViewController {
    let tableView = UITableView()
    var drinks: [Drink] = []
    let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: nil, action: nil)
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        drinks = DataManager.shared.drinks
        tableView.reloadData()
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Drinks"
        view.backgroundColor = .white
        setupTableView()
        setupNavigationBar()
        fetchDrinksData()
    }
    
    func setupTableView() {
        tableView.frame = view.bounds
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "DrinkCell")
        tableView.dataSource = self
        tableView.delegate = self
        view.addSubview(tableView)
    }
    
    func setupNavigationBar() {
        addButton.target = self
        addButton.action = #selector(addButtonTapped)
        navigationItem.rightBarButtonItem = addButton
    }
    
    func fetchDrinksData() {
        DataManager.shared.downloadDrinksData { [weak self] drinks in
            DispatchQueue.main.async {
                if let drinks = drinks {
                    self?.drinks = drinks
                    self?.tableView.reloadData()
                } else {
                    // Handle error (e.g., show alert)
                }
            }
        }
    }
    
    @objc func addButtonTapped() {
        let addRecipeVC = RecipeViewController()
        addRecipeVC.isAddingNewRecipe = true
        navigationController?.pushViewController(addRecipeVC, animated: true)
    }
}

extension DrinksListViewController: UITableViewDataSource, UITableViewDelegate {
    // Data Source Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return drinks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "DrinkCell", for: indexPath)
        let drink = drinks[indexPath.row]
        cell.textLabel?.text = drink.name
        return cell
    }
    
    // Delegate Methods
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let drink = drinks[indexPath.row]
        let recipeVC = RecipeViewController()
        recipeVC.drink = drink
        navigationController?.pushViewController(recipeVC, animated: true)
    }
}
