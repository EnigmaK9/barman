    //
    //  DrinksListViewController.swift
    //  Project Barman
    //
    //  Created by Carlos Ignacio Padilla Herrera on 26/10/2024.
    //
    //  Description: This view controller is responsible for displaying a list of drinks using a UITableView. It allows users to add new drinks and view details of selected drinks.
    //
    //  Created for: Enigma Unit
    //  Version: 1.0.0
    //  Copyright © 2024 Enigma Unit. All rights reserved.
    //

import UIKit

class DrinksListViewController: UIViewController {

    let tableView = UITableView()
    let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: nil, action: nil)

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Barman's Drinks"
        view.backgroundColor = UIColor(patternImage: UIImage(named: "bar_background")!)

        setupTableView() // Configurar la tabla correctamente con Auto Layout
        setupNavigationBar()
        fetchDrinksData()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }

    func setupTableView() {
        // Desactivar frame-based layout
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        // Configurar la tabla
        tableView.backgroundColor = .clear
        tableView.register(DrinkTableViewCell.self, forCellReuseIdentifier: "DrinkCell")
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        view.addSubview(tableView)
        
        // Agregar restricciones para que el tableView ocupe todo el espacio de la vista
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
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

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let drink = DataManager.shared.drinks[indexPath.row]
        let recipeVC = RecipeViewController()
        recipeVC.drink = drink
        navigationController?.pushViewController(recipeVC, animated: true)
    }
}
