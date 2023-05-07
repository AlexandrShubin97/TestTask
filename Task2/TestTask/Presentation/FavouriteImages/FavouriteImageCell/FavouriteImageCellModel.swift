//
//  FavouriteImageCellModel.swift
//  TestTask
//
//  Created by Александр Шубин on 06.05.2023.
//

import UIKit

struct FavouriteImageCellModel {
    let image: UIImage
    let imageURL: String
    let removeAction: () -> Void
}
