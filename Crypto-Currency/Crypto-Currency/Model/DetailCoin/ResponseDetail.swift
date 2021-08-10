//
//  ResponseDetail.swift
//  Crypto-Currency
//
//  Created by namtrinh on 10/08/2021.
//

import Foundation

struct ResponseDetail<T: Codable>: Codable {
    let status: String
    let data: T?
}
