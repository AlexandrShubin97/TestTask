//
//  FavouriteImageCell.swift
//  TestTask
//
//  Created by Александр Шубин on 06.05.2023.
//

import UIKit

final class FavouriteImageCell: UITableViewCell {

    // MARK: - Private nested

    private enum Constants {
        static let imageSize = UIScreen.main.bounds.width - 40
        static let buttonSize: CGFloat = 25
    }

    // MARK: - Views

    private let favouriteImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private lazy var removeButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "remove.png"), for: .normal)
        button.addTarget(self, action: #selector(removeTap), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private let favouriteImageURLLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 16)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    // MARK: - Private properties

    private var removeAction: (() -> Void)?

    // MARK: - Initialization

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        initialSetup()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Internal methods
extension FavouriteImageCell {

    func setup(model: FavouriteImageCellModel) -> Self {
        favouriteImageView.image = model.image
        favouriteImageURLLabel.text = model.imageURL
        removeAction = model.removeAction

        return self
    }
}

// MARK: - Private methods
private extension FavouriteImageCell {

    func initialSetup() {
        selectionStyle = .none
        backgroundColor = .clear
        contentView.addSubview(favouriteImageView)
        contentView.addSubview(removeButton)
        contentView.addSubview(favouriteImageURLLabel)
    }

    @objc
    func removeTap() {
        removeAction?()
    }

    func setupConstraints() {
        NSLayoutConstraint.activate(
            [
                favouriteImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
                favouriteImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
                favouriteImageView.heightAnchor.constraint(equalToConstant: Constants.imageSize),
                favouriteImageView.widthAnchor.constraint(equalToConstant: Constants.imageSize)
            ]
        )

        NSLayoutConstraint.activate(
            [
                removeButton.topAnchor.constraint(equalTo: favouriteImageView.topAnchor, constant: 10),
                removeButton.rightAnchor.constraint(equalTo: favouriteImageView.rightAnchor, constant: -10),
                removeButton.heightAnchor.constraint(equalToConstant: Constants.buttonSize),
                removeButton.widthAnchor.constraint(equalToConstant: Constants.buttonSize)
            ]
        )

        NSLayoutConstraint.activate(
            [
                favouriteImageURLLabel.topAnchor.constraint(equalTo: favouriteImageView.bottomAnchor, constant: 15),
                favouriteImageURLLabel.leftAnchor.constraint(equalTo: favouriteImageView.leftAnchor),
                favouriteImageURLLabel.rightAnchor.constraint(equalTo: favouriteImageView.rightAnchor),
                favouriteImageURLLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            ]
        )
    }
}
