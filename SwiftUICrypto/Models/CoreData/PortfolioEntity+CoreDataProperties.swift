//
//  PortfolioEntity+CoreDataProperties.swift
//  SwiftUICrypto
//
//  Created by Алексей Колыченков on 18.12.2024.
//
//

import Foundation
import CoreData

@objc(PortfolioEntity)
public class PortfolioEntity: NSManagedObject {

}


extension PortfolioEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PortfolioEntity> {
        return NSFetchRequest<PortfolioEntity>(entityName: "PortfolioEntity")
    }

    @NSManaged public var coinID: String
    @NSManaged public var amount: Double

}

extension PortfolioEntity : Identifiable {

}
