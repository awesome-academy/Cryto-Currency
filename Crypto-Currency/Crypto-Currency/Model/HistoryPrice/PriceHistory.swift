//
//  PriceHistory.swift
//  Crypto-Currency
//
//  Created by namtrinh on 10/08/2021.
//

import Foundation

struct PriceHistory: Codable {
    let change: String
    let history: [History]
}
