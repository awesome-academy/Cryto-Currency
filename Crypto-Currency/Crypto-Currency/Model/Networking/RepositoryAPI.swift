//
//  RepositoryAPI.swift
//  Crypto-Currency
//
//  Created by namtrinh on 06/08/2021.
//

import Foundation

class RepositoryAPI {
    func getCoins(urlString: String, completion: @escaping ([Coin]?, Error?) -> Void) {
        APIService.shared.request(urlString: urlString, expecting: Response<DataCoin>.self) { result in
            switch result {
            case .success(let result):
                completion(result.data.coins, nil)
            case .failure(let error):
                completion(nil, error)
            }
        }
    }
}
