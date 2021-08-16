//
//  SimpleCoinManager.swift
//  SimpleCoinManager
//
//  Created by namtrinh on 16/08/2021.
//

import Foundation

class SimpleCoinManager {
    
    static let shared = SimpleCoinManager()
    
    private init() {}
 
    private let coinDataRepository = CoinRepository()
    
    func createCoin(coin: SimpleCoin) {
        coinDataRepository.create(coin: coin)
    }
    
    func fetchCoins() async -> [SimpleCoin] {
        return await coinDataRepository.getSimpleCoins()
    }
    
    func checkCoin(uuid: String) -> Bool {
        return coinDataRepository.checkCoin(byIdentifier: uuid)
    }
    
    func deleteCoin(uuid: String) {
        coinDataRepository.delete(uuid: uuid)
    }
}
