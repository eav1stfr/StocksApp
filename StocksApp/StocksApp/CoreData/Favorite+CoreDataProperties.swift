//
//  Favorite+CoreDataProperties.swift
//  StocksApp
//
//  Created by Александр Эм on 25.12.2024.
//
//

import Foundation
import CoreData


extension Favorite {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Favorite> {
        return NSFetchRequest<Favorite>(entityName: "Favorite")
    }

    @NSManaged public var ticker: String?

}

extension Favorite : Identifiable {

}
