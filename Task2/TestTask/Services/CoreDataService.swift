//
//  CoreDataService.swift
//  TestTask
//
//  Created by Александр Шубин on 06.05.2023.
//

import UIKit
import CoreData

protocol CoreDataServiceProtocol {

    /// Добавить в избранное
    func addFavourite(_ imageData: Data, imageURL: String)

    /// Удалить из избранного
    func removeFavourite(_ item: FavouriteItem)

    /// Получить избранные айтемы
    func fetchFavouriteItems() -> [FavouriteItem]

    /// Сохранить
    func save()
}

final class CoreDataService {

    // MARK: - Static properties

    static let shared = CoreDataService()

    // MARK: - Private nested

    private enum Constants {
        static let favouriteLimit = 5
    }

    // MARK: - Private properties

    private let persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "TestTask")
        container.loadPersistentStores { _, _ in }
        return container
    }()

    private var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }

    // MARK: - Initialization

    private init() {}
}

// MARK: - CoreDataServiceProtocol
extension CoreDataService: CoreDataServiceProtocol {

    func addFavourite(_ imageData: Data, imageURL: String) {
        var items = fetchFavouriteItems()

        /// Удаляем айтем, с уже существующим добавляемым URL, чтобы избежать дубликатов
        if let duplicateItem = items.first(where: { $0.imageURL == imageURL }) {
            removeFavourite(duplicateItem)
            items.removeAll { $0.imageURL == imageURL }
        }

        /// Удаляем последний айтем, если уже достигнут лимит
        if items.count == Constants.favouriteLimit, let lastItem = items.last {
            removeFavourite(lastItem)
        }

        let item = FavouriteItem(context: context)
        item.imageData = imageData
        item.imageURL = imageURL
        item.addedDate = Date()

        context.insert(item)
    }

    func removeFavourite(_ item: FavouriteItem) {
        context.delete(item)
    }

    func fetchFavouriteItems() -> [FavouriteItem] {
        let items = try? context.fetch(FavouriteItem.fetchRequest())
        return items?.sorted { $0.unwrappedAddedDate > $1.unwrappedAddedDate } ?? []
    }

    func save() {
        context.hasChanges ? try? context.save() : ()
    }
}
