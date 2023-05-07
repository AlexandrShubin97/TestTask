//
//  TestTaskUITests.swift
//  TestTaskUITests
//
//  Created by Александр Шубин on 06.05.2023.
//

import XCTest

final class TestTaskUITests: XCTestCase {

    func testButtonsVisability() throws {
        let app = XCUIApplication()
        app.launch()

        XCTAssert(app.buttons["GenerateButton"].isHittable)
        XCTAssert(!app.buttons["AddToFavouriteButton"].isHittable)
    }
}
