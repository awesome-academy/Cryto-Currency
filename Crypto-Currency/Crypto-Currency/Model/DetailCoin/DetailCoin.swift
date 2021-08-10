//
//  DetailCoin.swift
//  Crypto-Currency
//
//  Created by namtrinh on 10/08/2021.
//

import Foundation

struct CoinDetail: Codable {
    let uuid: String
    let symbol: String
    let name: String
    let iconUrl: String
    let description: String
    let links: [Link]
    let supply: Supply
    let volume: String
    let marketCap: String
    let price: String
    let btcPrice: String
    let change: String
    let rank: Int
    
    private enum CodingKeys : String, CodingKey {
        case uuid
        case symbol
        case name
        case iconUrl
        case description
        case links
        case supply
        case volume = "24hVolume"
        case marketCap
        case price
        case btcPrice
        case change
        case rank
      }
}
