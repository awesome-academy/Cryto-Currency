//
//  Path.swift
//  Crypto-Currency
//
//  Created by namtrinh on 11/08/2021.
//

import Foundation

enum Path: String {
    case topCoin = "/coins?orderBy=price&limit=10"
    case topChange = "/coins?orderBy=change&limit=10"
    case top24Volume = "/coins?orderBy=24hVolume&limit=10"
    case topMarketCap = "/coins?orderBy=marketCap&limit=10"
}
