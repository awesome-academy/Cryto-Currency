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
                if result.data == nil {
                    completion(nil, CustomError.invalidData)
                }
                completion(result.data?.coins, nil)
            case .failure(let error):
                completion(nil, error)
            }
        }
    }
}
