//
//  EndPoint.swift
//  Crypto-Currency
//
//  Created by namtrinh on 06/08/2021.
//

import Foundation

enum EndPoint: String {
    case topCoin = "https://api.coinranking.com/v2/coins?orderBy=price&limit=10"
    case topChange = "https://api.coinranking.com/v2/coins?orderBy=change&limit=10"
    case top24hVolume = "https://api.coinranking.com/v2/coins?orderBy=24hVolume&limit=10"
    case topMarketCap = "https://api.coinranking.com/v2/coins?orderBy=marketCap&limit=10"
    case ranking = "https://api.coinranking.com/v2/coins?limit=30"
    case offset = "https://api.coinranking.com/v2/coins?limit=10&offset="
    case history = "https://api.coinranking.com/v2/coin/Qwsogvtv82FCd/history?timePeriod="
    case detail = "https://api.coinranking.com/v2/coin/"
}
