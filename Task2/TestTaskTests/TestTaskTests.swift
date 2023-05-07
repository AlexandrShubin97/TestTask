//
//  TestTaskTests.swift
//  TestTaskTests
//
//  Created by Александр Шубин on 06.05.2023.
//

import XCTest
@testable import TestTask

final class TestTaskTests: XCTestCase {

    private let sut = CoreDataService.shared

    func testAddFavouriteDuplicate() throws {
        let currentFavouriteCount = sut.fetchFavouriteItems().count

        sut.addFavourite(Data(), imageURL: "URL")
        sut.addFavourite(Data(), imageURL: "URL")

        XCTAssertEqual(sut.fetchFavouriteItems().count, currentFavouriteCount + 1)
    }
}
