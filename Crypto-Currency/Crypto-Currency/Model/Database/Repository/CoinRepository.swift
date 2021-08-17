//
//  CryptoDataRepository.swift
//  CryptoDataRepository
//
//  Created by namtrinh on 16/08/2021.
//

import Foundation
import CoreData

protocol CoinRepositoryType {
    func create(coin: SimpleCoin)
    func getSimpleCoins() async -> [SimpleCoin]
    func checkCoin(byIdentifier uuid: String) -> Bool
    func delete(uuid: String)
}

struct CoinRepository: CoinRepositoryType {
    
    func create(coin: SimpleCoin) {
        let favoriteCoin = CDCoin(context: PersistentStorage.shared.context)
        favoriteCoin.uuid = coin.uuid
        favoriteCoin.name = coin.name
        favoriteCoin.symbol = coin.symbol
        favoriteCoin.iconUrl = coin.iconUrl
        
        PersistentStorage.shared.saveContext()
    }

    func getSimpleCoins() async -> [SimpleCoin] {
        let result = PersistentStorage.shared.fetchManagedObject(managedObject: CDCoin.self)
        var simpleCoins = [SimpleCoin]()
        
        simpleCoins = result?.compactMap({
            $0.convertToCoin()
        }) ?? []

        return simpleCoins
    }

    func checkCoin(byIdentifier uuid: String) -> Bool {
        let fetchRequest = NSFetchRequest<CDCoin>(entityName: "CDCoin")
        let predicate = NSPredicate(format: "uuid == %@", uuid)

        fetchRequest.predicate = predicate
        
        do {
            let result = try PersistentStorage.shared.context.fetch(fetchRequest).first
            
            guard result != nil else { return false }
            
            return true
        } catch let error {
            print(error)
            return false
        }
    }
    
    func delete(uuid: String) {
        let favoriteCoin = getCDCoin(uuid: uuid)
        
        guard let favoriteCoin = favoriteCoin else { return }
        
        PersistentStorage.shared.context.delete(favoriteCoin)
    }
    
    private func getCDCoin(uuid: String) -> CDCoin? {
        let fetchRequest = NSFetchRequest<CDCoin>(entityName: "CDCoin")
        let predicate = NSPredicate(format: "uuid == %@", uuid)

        fetchRequest.predicate = predicate
        do {
            let result = try PersistentStorage.shared.context.fetch(fetchRequest).first
            return result
        } catch let error {
            debugPrint(error)
        }
        return nil
    }
}
