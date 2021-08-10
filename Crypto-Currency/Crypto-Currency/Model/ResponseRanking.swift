//
//  ResponseRanking.swift
//  Crypto-Currency
//
//  Created by namtrinh on 09/08/2021.
//

import Foundation

struct ResponseRanking<T: Codable>: Codable {
    let status: String
    let data: T?
}
