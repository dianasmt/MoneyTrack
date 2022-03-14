//
//  Wallet+CoreDataProperties.swift
//  MoneyTrack
//
//  Created by Диана Смахтина on 11.03.22.
//
//

import Foundation
import CoreData


extension Wallet {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Wallet> {
        return NSFetchRequest<Wallet>(entityName: "Wallet")
    }

    @NSManaged public var amount: Double
    @NSManaged public var icon: String?
    @NSManaged public var name: String?
    @NSManaged public var replenichment: NSSet?

}

// MARK: Generated accessors for replenichment
extension Wallet {

    @objc(addReplenichmentObject:)
    @NSManaged public func addToReplenichment(_ value: Replenichment)

    @objc(removeReplenichmentObject:)
    @NSManaged public func removeFromReplenichment(_ value: Replenichment)

    @objc(addReplenichment:)
    @NSManaged public func addToReplenichment(_ values: NSSet)

    @objc(removeReplenichment:)
    @NSManaged public func removeFromReplenichment(_ values: NSSet)

}

extension Wallet : Identifiable {

}
