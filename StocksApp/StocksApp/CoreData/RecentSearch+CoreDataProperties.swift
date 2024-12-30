//
//  RecentSearch+CoreDataProperties.swift
//  StocksApp
//
//  Created by Александр Эм on 26.12.2024.
//
//

import Foundation
import CoreData


extension RecentSearch {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<RecentSearch> {
        return NSFetchRequest<RecentSearch>(entityName: "RecentSearch")
    }

    @NSManaged public var companyName: String?

}

extension RecentSearch : Identifiable {

}
