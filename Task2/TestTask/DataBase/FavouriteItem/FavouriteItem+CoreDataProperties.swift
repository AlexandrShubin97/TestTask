//
//  FavouriteItem+CoreDataProperties.swift
//  TestTask
//
//  Created by Александр Шубин on 06.05.2023.
//
//

import Foundation
import CoreData

extension FavouriteItem {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FavouriteItem> {
        return NSFetchRequest<FavouriteItem>(entityName: "FavouriteItem")
    }

    @NSManaged public var imageData: Data?
    @NSManaged public var imageURL: String?
    @NSManaged public var addedDate: Date?

    var unwrappedImageData: Data {
        return imageData ?? Data()
    }

    var unwrappedImageURL: String {
        return imageURL ?? ""
    }

    var unwrappedAddedDate: Date {
        return addedDate ?? Date()
    }
}
