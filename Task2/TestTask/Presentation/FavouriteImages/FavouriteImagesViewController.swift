//
//  FavouriteImagesViewController.swift
//  TestTask
//
//  Created by Александр Шубин on 06.05.2023.
//

import UIKit

final class FavouriteImagesViewController: UIViewController {

    // MARK: - Private nested

    private enum Constants {
        static let cellReuseIdentifier = "FavouriteImageCell"
    }

    // MARK: - Views

    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.register(FavouriteImageCell.self, forCellReuseIdentifier: Constants.cellReuseIdentifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

    private let placeholderLabel: UILabel = {
        let label = UILabel()
        label.text = "Здесь пока ничего нет, сгенерируй изображение и добавь его сюда"
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 17, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    // MARK: - Private properties

    private let coreDataService: CoreDataServiceProtocol = CoreDataService.shared
    private var cellModels: [FavouriteImageCellModel] = []

    // MARK: - Overrided methods

    override func viewDidLoad() {
        super.viewDidLoad()

        initialSetup()
        setupConstraints()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        updateData()
    }
}

// MARK: - UITableViewDataSource
extension FavouriteImagesViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellModels.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let favouriteCell = tableView.dequeueReusableCell(
                withIdentifier: Constants.cellReuseIdentifier,
                for: indexPath
            ) as? FavouriteImageCell
        else {
            return UITableViewCell()
        }

        return favouriteCell.setup(model: cellModels[indexPath.row])
    }

}

// MARK: - Private methods
private extension FavouriteImagesViewController {

    func initialSetup() {
        view.backgroundColor = .white
        view.addSubview(tableView)
        view.addSubview(placeholderLabel)
    }

    func updateData() {
        cellModels = coreDataService.fetchFavouriteItems().compactMap { item -> FavouriteImageCellModel? in
            guard let image = UIImage(data: item.unwrappedImageData) else { return nil }

            return FavouriteImageCellModel(
                image: image,
                imageURL: item.unwrappedImageURL,
                removeAction: { [weak self] in
                    let alertController = AlertBuilder.build(
                        title: "Удалить?",
                        description: nil,
                        actionTitles: ["Да", "Отмена"],
                        actionHandlers: [
                            {
                                self?.coreDataService.removeFavourite(item)
                                self?.updateData()
                            },
                            nil
                        ]
                    )
                    self?.present(alertController, animated: true)
                }
            )
        }

        tableView.reloadData()
        tableView.isHidden = cellModels.isEmpty

        placeholderLabel.isHidden = !cellModels.isEmpty
    }

    func setupConstraints() {
        NSLayoutConstraint.activate(
            [
                tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
                tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
                tableView.rightAnchor.constraint(equalTo: view.rightAnchor),
                tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
            ]
        )

        NSLayoutConstraint.activate(
            [
                placeholderLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
                placeholderLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 12),
                placeholderLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -12),
            ]
        )
    }
}
