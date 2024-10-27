// DrinksListViewController.swift

import UIKit

class DrinksListViewController: UIViewController {
    let tableView = UITableView()
    let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: nil, action: nil)

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Barman's Drinks"
        view.backgroundColor = UIColor(patternImage: UIImage(named: "bar_background")!) // Imagen de fondo
        setupTableView()
        setupNavigationBar()
        fetchDrinksData()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }

    func setupTableView() {
        tableView.frame = view.bounds
        tableView.backgroundColor = .clear
        tableView.register(DrinkTableViewCell.self, forCellReuseIdentifier: "DrinkCell")
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        view.addSubview(tableView)
    }

    func setupNavigationBar() {
        addButton.target = self
        addButton.action = #selector(addButtonTapped)
        navigationItem.rightBarButtonItem = addButton
        navigationController?.navigationBar.barTintColor = UIColor.darkGray
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
    }

    func fetchDrinksData() {
        DataManager.shared.downloadDrinksData { [weak self] drinks in
            DispatchQueue.main.async {
                if drinks != nil {
                    self?.tableView.reloadData()
                } else {
                    // Manejo de errores (e.g., mostrar alerta)
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
    // Métodos de Data Source
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DataManager.shared.drinks.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(withIdentifier: "DrinkCell", for: indexPath) as? DrinkTableViewCell else {
            return UITableViewCell()
        }
        let drink = DataManager.shared.drinks[indexPath.row]
        cell.configure(with: drink)
        return cell
    }

    // Métodos de Delegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let drink = DataManager.shared.drinks[indexPath.row]
        let recipeVC = RecipeViewController()
        recipeVC.drink = drink
        navigationController?.pushViewController(recipeVC, animated: true)
    }
}
