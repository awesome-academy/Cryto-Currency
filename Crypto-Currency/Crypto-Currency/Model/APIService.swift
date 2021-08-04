//
//  APIService.swift
//  Crypto-Currency
//
//  Created by namtrinh on 04/08/2021.
//

import Foundation

class APIService {
    private init() {}
    
    static let shared = APIService()
    
    enum CustomError: Error {
        case invalidUrl
        case invalidData
    }
    
    func request<T: Codable>(urlString: String, expecting: T.Type, completion: @escaping (Result<T, Error>) -> Void){
        let url = URL(string: urlString)
        guard let url = url else {
            completion(.failure(CustomError.invalidUrl))
            return
        }
        let task = URLSession.shared.dataTask(with: url, completionHandler: { data, response, error in
            guard let data = data else {
                if let error = error {
                    completion(.failure(error))
                } else {
                    completion(.failure(CustomError.invalidData))
                }
                return
            }
            
            do {
                let result = try JSONDecoder().decode(expecting, from: data)
                completion(.success(result))
            } catch {
                completion(.failure(error))
            }
        })
        task.resume()
    }
    
}
