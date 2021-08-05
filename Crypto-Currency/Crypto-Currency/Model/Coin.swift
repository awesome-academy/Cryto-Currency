//
//  Coin.swift
//  Crypto-Currency
//
//  Created by namtrinh on 04/08/2021.
//

import Foundation

struct Coin: Codable {
    let uuid: String
    let symbol: String
    let name: String
    let iconUrl: String
    let marketCap: String
    let price: String
    let change: String
    let rank: Int
    let volume: String
    let btcPrice: String
    
    private enum CodingKeys : String, CodingKey {
        case uuid
        case symbol
        case name
        case iconUrl
        case marketCap
        case price
        case change
        case rank
        case volume = "24hVolume"
        case btcPrice
      }
}
