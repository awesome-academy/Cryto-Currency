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
        APIService.shared.request(urlString: "\(EndPoint.offset.rawValue)\(offset)",
                                  expecting: ResponseRanking<DataCoin>.self) { result in
            switch result {
            case .success(let result):
                if let data = result.data {
                    completion(data.coins, nil)
                }
                completion(nil, CustomError.invalidData)
            case .failure(let error):
                completion(nil, error)
            }
        }
    }
    
    func getDetail(uuid: String, completion: @escaping (CoinDetail?, Error?) -> Void) {
        APIService.shared.request(urlString: "\(EndPoint.detail.rawValue)\(uuid)",
                                  expecting: ResponseDetail<DataDetailCoin>.self) { result in
            switch result {
            case .success(let result):
                if let data = result.data {
                    completion(data.coin, nil)
                }
                completion(nil, CustomError.invalidData)
            case .failure(let error):
                completion(nil, error)
            }
        }
    }
    
    func getHistoryPrice(time: String, completion: @escaping ([History]?, Error?) -> Void) {
        APIService.shared.request(urlString: "\(EndPoint.history.rawValue)\(time)",
                                  expecting: ResponseDetail<PriceHistory>.self) { result in
            switch result {
            case .success(let result):
                if result.data == nil {
                    completion(nil, CustomError.invalidData)
                }
                completion(result.data?.history, nil)
            case .failure(let error):
                completion(nil, error)
            }
        }
    }
}
