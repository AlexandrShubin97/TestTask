//
//  GenerateImageViewController.swift
//  TestTask
//
//  Created by Александр Шубин on 06.05.2023.
//

import UIKit

final class GenerateImageViewController: UIViewController {

    // MARK: - Private nested

    private enum Constants {
        static let imageSize = UIScreen.main.bounds.width - 40
        static let buttonHeight: CGFloat = 72
        static let requestLimit: TimeInterval = 20
    }

    // MARK: - Views

    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "Введите запрос"
        searchBar.backgroundImage = UIImage()
        searchBar.delegate = self
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        return searchBar
    }()

    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()

    private let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .lightGray.withAlphaComponent(0.2)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private let buttonsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = 12
        stackView.distribution = .fillEqually
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    private lazy var generateButton: UIButton = {
        let button = UIButton()
        button.setTitle("Сгенерировать", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.setTitleColor(.lightText, for: .highlighted)
        button.backgroundColor = .black
        button.layer.cornerRadius = 12
        button.addTarget(self, action: #selector(generateImageTap), for: .touchUpInside)
        button.accessibilityIdentifier = "GenerateButton"
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private lazy var addToFavouriteButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("В избранное", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.setTitleColor(.lightText, for: .highlighted)
        button.backgroundColor = .systemPink
        button.layer.cornerRadius = 12
        button.isHidden = true
        button.addTarget(self, action: #selector(addToFavouriteTap), for: .touchUpInside)
        button.accessibilityIdentifier = "AddToFavouriteButton"
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    // MARK: - Private properties

    private let generateImageService: GenerateImageServiceProtocol = GenerateImageService.shared
    private let coreDataService: CoreDataServiceProtocol = CoreDataService.shared
    private var lastGenerationTime: TimeInterval?

    // MARK: - Overrided methods

    override func viewDidLoad() {
        super.viewDidLoad()

        initialSetup()
        setupConstraints()
        setupGestures()
    }
}

// MARK: - UISearchBarDelegate
extension GenerateImageViewController: UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        dismissKeyboard()
    }
}

// MARK: - Private methods
private extension GenerateImageViewController {

    func initialSetup() {
        view.backgroundColor = .white
        view.addSubview(searchBar)
        view.addSubview(scrollView)

        scrollView.addSubview(contentView)

        contentView.addSubview(imageView)
        contentView.addSubview(buttonsStackView)

        buttonsStackView.addArrangedSubview(generateButton)
        buttonsStackView.addArrangedSubview(addToFavouriteButton)
    }

    func setupGestures() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }

    @objc
    func generateImageTap() {
        let currentTime = Date().timeIntervalSince1970

        guard let lastGenerationTime = lastGenerationTime else {
            generateImage()
            self.lastGenerationTime = currentTime
            return
        }

        let passedTime = currentTime - lastGenerationTime

        if passedTime >= Constants.requestLimit {
            generateImage()
            self.lastGenerationTime = currentTime
            return
        }

        let formatter = DateComponentsFormatter()
        let timeBeforeRequest = formatter.string(from: Constants.requestLimit - passedTime) ?? "0"

        let alertController = AlertBuilder.build(
            title: "Пока нельзя это сделать",
            description: "Попробуй через \(timeBeforeRequest) с",
            actionTitles: ["Хорошо"],
            actionHandlers: [nil]
        )
        present(alertController, animated: true)
    }
    
    @objc
    func addToFavouriteTap() {
        guard
            let lastGeneratedImageData = imageView.image?.pngData(),
            let lastRequestURL = generateImageService.lastRequestURL?.removingPercentEncoding
        else { return }

        coreDataService.addFavourite(lastGeneratedImageData, imageURL: lastRequestURL)

        let alertController = AlertBuilder.build(
            title: "Добавлено",
            description: nil,
            actionTitles: ["Ок"],
            actionHandlers: [nil]
        )
        present(alertController, animated: true)
    }

    @objc
    func dismissKeyboard() {
        view.endEditing(true)
    }

    func generateImage() {
        imageView.image = nil
        addToFavouriteButton.isHidden = true

        generateImageService.generateImage(
            by: searchBar.text ?? "",
            width: Int(Constants.imageSize),
            height: Int(Constants.imageSize),
            completionHandler: { [weak self] result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let imageData):
                        let image = UIImage(data: imageData)

                        if image != nil {
                            self?.imageView.image = image
                            self?.addToFavouriteButton.isHidden = false
                            return
                        }
                        let alertController = AlertBuilder.build(
                            title: "Ошибка",
                            description: "Не удалось преобразовать сгенерированное изображение",
                            actionTitles: ["Понятно"],
                            actionHandlers: [nil]
                        )
                        self?.present(alertController, animated: true)

                    case .failure(let error):
                        let alertController = AlertBuilder.build(
                            title: "Ошибка",
                            description: error.localizedDescription,
                            actionTitles: ["Понятно"],
                            actionHandlers: [nil]
                        )
                        self?.present(alertController, animated: true)
                    }
                }
            }
        )
    }

    func setupConstraints() {
        NSLayoutConstraint.activate(
            [
                searchBar.heightAnchor.constraint(equalToConstant: 72),
                searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
                searchBar.leftAnchor.constraint(equalTo: view.leftAnchor),
                searchBar.rightAnchor.constraint(equalTo: view.rightAnchor)
            ]
        )

        NSLayoutConstraint.activate(
            [
                scrollView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
                scrollView.leftAnchor.constraint(equalTo: view.leftAnchor),
                scrollView.rightAnchor.constraint(equalTo: view.rightAnchor),
                scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
            ]
        )

        NSLayoutConstraint.activate(
            [
                contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
                contentView.heightAnchor.constraint(greaterThanOrEqualTo: scrollView.heightAnchor),
                contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
                contentView.leftAnchor.constraint(equalTo: scrollView.leftAnchor),
                contentView.rightAnchor.constraint(equalTo: scrollView.rightAnchor),
                contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor)
            ]
        )

        NSLayoutConstraint.activate(
            [
                imageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
                imageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
                imageView.heightAnchor.constraint(equalToConstant: Constants.imageSize),
                imageView.widthAnchor.constraint(equalToConstant: Constants.imageSize)
            ]
        )

        NSLayoutConstraint.activate(
            [
                buttonsStackView.topAnchor.constraint(greaterThanOrEqualTo: imageView.bottomAnchor, constant: 40),
                buttonsStackView.leftAnchor.constraint(equalTo: imageView.leftAnchor),
                buttonsStackView.rightAnchor.constraint(equalTo: imageView.rightAnchor),
                buttonsStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20)
            ]
        )

        NSLayoutConstraint.activate(
            [
                generateButton.heightAnchor.constraint(equalToConstant: Constants.buttonHeight)
            ]
        )

        NSLayoutConstraint.activate(
            [
                addToFavouriteButton.heightAnchor.constraint(equalToConstant: Constants.buttonHeight)
            ]
        )
    }
}
