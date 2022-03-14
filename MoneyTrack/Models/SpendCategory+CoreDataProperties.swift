//
//  SpendCategory+CoreDataProperties.swift
//  MoneyTrack
//
//  Created by Диана Смахтина on 11.03.22.
//
//

import Foundation
import CoreData


extension SpendCategory {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SpendCategory> {
        return NSFetchRequest<SpendCategory>(entityName: "SpendCategory")
    }

    @NSManaged public var amount: Double
    @NSManaged public var icon: String?
    @NSManaged public var name: String?
    @NSManaged public var spending: NSSet?

}

// MARK: Generated accessors for spending
extension SpendCategory {

    @objc(addSpendingObject:)
    @NSManaged public func addToSpending(_ value: Spending)

    @objc(removeSpendingObject:)
    @NSManaged public func removeFromSpending(_ value: Spending)

    @objc(addSpending:)
    @NSManaged public func addToSpending(_ values: NSSet)

    @objc(removeSpending:)
    @NSManaged public func removeFromSpending(_ values: NSSet)

}

extension SpendCategory : Identifiable {

}
