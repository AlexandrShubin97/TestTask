//
//  AlertBuilder.swift
//  TestTask
//
//  Created by Александр Шубин on 06.05.2023.
//

import UIKit

enum AlertBuilder {

    // MARK: - Static methods

    static func build(
        title: String?,
        description: String?,
        style: UIAlertController.Style = .alert,
        actionTitles: [String],
        actionHandlers: [(() -> Void)?]
    ) -> UIAlertController {
        let alertController = UIAlertController(
            title: title,
            message: description,
            preferredStyle: style
        )

        for (title, handler) in zip(actionTitles, actionHandlers) {
            alertController.addAction(
                UIAlertAction(
                    title: title,
                    style: .default
                ) { _ in
                    handler?()
                }
            )
        }

        return alertController
    }
}
