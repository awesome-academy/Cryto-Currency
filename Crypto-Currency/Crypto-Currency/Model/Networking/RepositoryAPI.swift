//
//  RepositoryAPI.swift
//  Crypto-Currency
//
//  Created by namtrinh on 06/08/2021.
//

import Foundation

class RepositoryAPI {
    func getCoins(urlString: String, completion: @escaping ([Coin]?, Error?) -> Void) {
        APIService.shared.request(urlString: urlString,
                                  expecting: Response<DataCoin>.self) { result in
            switch result {
            case .success(let result):
                completion(result.data.coins, nil)
            case .failure(let error):
                completion(nil, error)
            }
        }
    }
    
    func getMore(offset: String, completion: @escaping ([Coin]?, Error?) -> Void) {
        APIService.shared.request(urlString: Network.shared.getOffsetURL(offset: offset),
                                  expecting: ResponseRanking<DataCoin>.self) { result in
            switch result {
            case .success(let result):
                guard let data = result.data else {
                    completion(nil, CustomError.invalidData)
                    return
                }
                completion(data.coins, nil)
            case .failure(let error):
                completion(nil, error)
            }
        }
    }
    
    func getDetail(uuid: String, completion: @escaping (CoinDetail?, Error?) -> Void) {
        APIService.shared.request(urlString: Network.shared.getDetailURL(uuid: uuid),
                                  expecting: ResponseDetail<DataDetailCoin>.self) { result in
            switch result {
            case .success(let result):
                guard let data = result.data else {
                    completion(nil, CustomError.invalidData)
                    return
                }
                completion(data.coin, nil)
            case .failure(let error):
                completion(nil, error)
            }
        }
    }
    
    func getHistoryPrice(time: String, completion: @escaping ([History]?, Error?) -> Void) {
        APIService.shared.request(urlString: Network.shared.getHistoryURL(time: time),
                                  expecting: ResponseDetail<PriceHistory>.self) { result in
            switch result {
            case .success(let result):
                guard let data = result.data else {
                    completion(nil, CustomError.invalidData)
                    return
                }
                completion(data.history, nil)
            case .failure(let error):
                completion(nil, error)
            }
        }
    }
    
    func getSimpleCoin(name: String, completion: @escaping ([SimpleCoin]?, Error?) -> Void) {
        APIService.shared.request(urlString: Network.shared.getSearchURL(name: name),
                                  expecting: ResponseDetail<SimpleDataCoin>.self) { result in
            switch result {
            case .success(let result):
                guard let data = result.data else {
                    completion(nil, CustomError.invalidData)
                    return
                }
                completion(data.coins, nil)
            case .failure(let error):
                completion(nil, error)
            }
        }
    }
    
    func getExchangeRates(urlString: String, completion: @escaping (Price?, Error?) -> Void) {
        APIService.shared.request(urlString: urlString,
                                  expecting: Response<Price>.self) { result in
            switch result {
            case .success(let result):
                completion(result.data, nil)
            case .failure(let error):
                completion(nil, error)
            }
        }
    }
}
