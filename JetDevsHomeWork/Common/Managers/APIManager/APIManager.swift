//
//  APIManager.swift
//  JetDevsHomeWork
//
//  Created by Chirag on 23/2/2024.
//

import Foundation

enum APIError: Error {
    case invalidURL
    case requestFailed(String)
    case invalidData
    case noDataFound
    case networkUnavailable
}

class 
APIManager {
    static let shared = APIManager()
    
    // MARK: - Method Type
    enum MethodType: String {
        case POST, GET
    }
    
    private static let baseURL = "https://jetdevs.wiremockapi.cloud/"
    
    enum Endpoint {
        case login
        
        var path: String {
            switch self {
            case .login:
                return "login"
            }
        }
        
        var url: URL? {
            guard let baseURL = URL(string: APIManager.baseURL) else { return nil }
            return baseURL.appendingPathComponent(path)
        }
    }
    
    struct Parameters {
        static let email = "email"
        static let password = "password"
    }
    
    // MARK: - Normal Request
    func callAPI<T: Codable>(endPoint: Endpoint, headers: [String : String]? = nil, parameters: [String : Any]?, methodType: MethodType, completion: @escaping (Result<T, APIError>) -> Void) {
        
        guard let requestURL = endPoint.url else {
            completion(.failure(.invalidURL))
            return
        }
        
        debugPrint("URL:- ", requestURL)
        
        var request = URLRequest(url: requestURL)
        request.httpMethod = methodType.rawValue
        
        request.allHTTPHeaderFields = headers
        request.setValue(applicationJsonStr, forHTTPHeaderField: contentTypeStr)
        
        debugPrint("Request Parameters :- ", parameters ?? [:])
        debugPrint("Headers :- ", request.allHTTPHeaderFields ?? [:])
       
        if let parameters = parameters, !parameters.isEmpty {
            do {
                let param = try JSONSerialization.data(withJSONObject: parameters, options: [])
                request.httpBody = param
            } catch {
                debugPrint("Error: \(error.localizedDescription)")
            }
        }
        
        URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            if let error = error {
                debugPrint("Error :- ", error.localizedDescription)
                completion(.failure(.requestFailed(somethingWentWrongStr)))
                return
            }
            guard let httpResponse = response as? HTTPURLResponse, 200..<300 ~= httpResponse.statusCode else {
                completion(.failure(.requestFailed(somethingWentWrongStr)))
                return
            }
            
            // The X-Acc(from API response header) needs to be saved
            if let xAccHeader = httpResponse.allHeaderFields["X-Acc"] as? String {
                UserDefaultManager.shared.saveString(xAccHeader, forKey: xAccHeaderTokenStr)
            }
            
            guard let data = data else {
                completion(.failure(.invalidData))
                return
            }
            
            do {
                let decodedData = try JSONDecoder().decode(T.self, from: data)
                completion(.success(decodedData))
            } catch {
                completion(.failure(.invalidData))
            }
            
        }.resume()
    }
}
