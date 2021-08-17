//
//  CDCoin+CoreDataProperties.swift
//  CDCoin
//
//  Created by namtrinh on 16/08/2021.
//
//

import Foundation
import CoreData

extension CDCoin {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDCoin> {
        return NSFetchRequest<CDCoin>(entityName: "CDCoin")
    }

    @NSManaged public var iconUrl: String?
    @NSManaged public var name: String?
    @NSManaged public var symbol: String?
    @NSManaged public var uuid: String?

}

extension CDCoin: Identifiable {
    func convertToCoin() -> SimpleCoin? {
        guard let uuid = self.uuid,
              let iconUrl = self.iconUrl,
              let name = self.name,
              let symbol = self.symbol else {
                  return nil
              }
        return SimpleCoin(uuid: uuid, iconUrl: iconUrl, name: name, symbol: symbol)
    }
}
