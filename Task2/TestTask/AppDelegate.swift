//
//  AppDelegate.swift
//  TestTask
//
//  Created by Александр Шубин on 06.05.2023.
//

import UIKit

@main
final class AppDelegate: UIResponder, UIApplicationDelegate {

    // MARK: - UIApplicationDelegate

    var window: UIWindow?

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {
        setupWindow()
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        CoreDataService.shared.save()
    }
}

// MARK: - Private methods
private extension AppDelegate {

    func setupWindow() {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        window?.rootViewController = AppTabBarController()
    }
}
