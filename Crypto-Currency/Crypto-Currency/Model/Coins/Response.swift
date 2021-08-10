//
//  CoinData.swift
//  Crypto-Currency
//
//  Created by namtrinh on 04/08/2021.
//

import Foundation

struct Response<T: Codable>: Codable {
    let status: String
    let data: T
}
