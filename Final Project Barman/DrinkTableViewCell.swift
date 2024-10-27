// DrinkTableViewCell.swift

import UIKit

class DrinkTableViewCell: UITableViewCell {

    let drinkImageView = UIImageView()
    let nameLabel = UILabel()
    let containerView = UIView()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupCell() {
        backgroundColor = .clear
        selectionStyle = .none

        // Configurar la vista de contenedor
        containerView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        containerView.layer.cornerRadius = 10
        containerView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(containerView)

        // Configurar la imagen de la bebida
        drinkImageView.contentMode = .scaleAspectFill
        drinkImageView.layer.cornerRadius = 10
        drinkImageView.clipsToBounds = true
        drinkImageView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(drinkImageView)

        // Configurar el label del nombre
        nameLabel.font = UIFont(name: "AvenirNext-DemiBold", size: 18)
        nameLabel.textColor = .white
        nameLabel.numberOfLines = 0  // Permitir múltiples líneas si el nombre es largo
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(nameLabel)

        // Añadir restricciones con más separación
        NSLayoutConstraint.activate([
            // Restricciones para containerView
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

            // Establecer tamaño fijo para drinkImageView
            drinkImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 12),
            drinkImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            drinkImageView.widthAnchor.constraint(equalToConstant: 80),
            drinkImageView.heightAnchor.constraint(equalToConstant: 80),

            // Restricciones para nameLabel con más separación
            nameLabel.leadingAnchor.constraint(equalTo: drinkImageView.trailingAnchor, constant: 20),
            nameLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            nameLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 20),
            nameLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -20)
        ])
    }

    func configure(with drink: Drink) {
        nameLabel.text = drink.name

        // Cargar la imagen de la bebida
        DataManager.shared.getImage(for: drink.img) { [weak self] image in
            DispatchQueue.main.async {
                self?.drinkImageView.image = image ?? UIImage(named: "placeholder")
            }
        }
    }
}
