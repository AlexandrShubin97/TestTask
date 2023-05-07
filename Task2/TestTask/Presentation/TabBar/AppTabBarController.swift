//
//  AppTabBarController.swift
//  TestTask
//
//  Created by Александр Шубин on 06.05.2023.
//

import UIKit

final class AppTabBarController: UITabBarController {

    // MARK: - Overrided methods

    override func viewDidLoad() {
        super.viewDidLoad()

        initialSetup()
        addItems()
    }
}

// MARK: - Private methods
private extension AppTabBarController {

    func initialSetup() {
        view.backgroundColor = .white
    }

    func addItems() {
        let firstItem = UITabBarItem(
            title: "Генерация",
            image: UIImage(named: "search.png"),
            tag: 0
        )
        let firstViewController = GenerateImageViewController()
        firstViewController.tabBarItem = firstItem

        let secondItem = UITabBarItem(
            title: "Избранное",
            image: UIImage(named: "favourite.png"),
            tag: 1
        )
        let secondViewController = FavouriteImagesViewController()
        secondViewController.tabBarItem = secondItem

        viewControllers = [firstViewController, secondViewController]
    }
}
