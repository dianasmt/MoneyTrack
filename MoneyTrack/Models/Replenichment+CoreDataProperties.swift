//
//  Replenichment+CoreDataProperties.swift
//  MoneyTrack
//
//  Created by Диана Смахтина on 11.03.22.
//
//

import Foundation
import CoreData


extension Replenichment {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Replenichment> {
        return NSFetchRequest<Replenichment>(entityName: "Replenichment")
    }

    @NSManaged public var amount: Double
    @NSManaged public var date: String?
    @NSManaged public var wallet: Wallet?

}

extension Replenichment : Identifiable {

}
