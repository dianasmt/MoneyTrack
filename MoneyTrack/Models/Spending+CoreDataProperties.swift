//
//  Spending+CoreDataProperties.swift
//  MoneyTrack
//
//  Created by Диана Смахтина on 11.03.22.
//
//

import Foundation
import CoreData


extension Spending {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Spending> {
        return NSFetchRequest<Spending>(entityName: "Spending")
    }

    @NSManaged public var amount: Double
    @NSManaged public var date: String?
    @NSManaged public var spendCategory: SpendCategory?
    @NSManaged public var wallet: Wallet?

}

extension Spending : Identifiable {

}
