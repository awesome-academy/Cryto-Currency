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
    
    private var apiKey: String {
      get {
        guard let filePath = Bundle.main.path(forResource: "Keys", ofType: "plist") else {
          fatalError("Couldn't find file 'Keys.plist'.")
        }
        let plist = NSDictionary(contentsOfFile: filePath)
        guard let value = plist?.object(forKey: "API_KEY") as? String else {
          fatalError("Couldn't find key 'API_KEY' in 'Keys.plist'.")
        }
        return value
      }
    }
    
    enum CustomError: Error {
        case invalidUrl
        case invalidData
    }
    
    enum HTTPMethod: String {
        case get = "GET"
        case head = "HEAD"
        case post = "POST"
        case put = "PUT"
        case delete = "DELETE"
        case connect = "CONNECT"
        case options = "OPTIONS"
        case trace = "TRACE"
        case patch = "PATCH"
    }
    
    func request<T: Codable>(urlString: String, expecting: T.Type, completion: @escaping (Result<T, Error>) -> Void) {
        let url = URL(string: urlString)
        guard let url = url else {
            completion(.failure(CustomError.invalidUrl))
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.get.rawValue
        request.setValue(apiKey, forHTTPHeaderField: "x-access-token")
        let task = URLSession.shared.dataTask(with: url, completionHandler: { data, _, error in
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
