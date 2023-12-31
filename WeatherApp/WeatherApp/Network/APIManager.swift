//
//  APIManager.swift
//  WeatherApp
//
//  Created by Grishma Dave on 30/07/23.
//

import Foundation

class APIManager {
    
    static let shared: APIManager = APIManager()
    func request<T: Codable>(route: Router,type: T.Type,complition:@escaping(_ result:T) -> Void,failure: @escaping(_ message: String) -> Void) {
        
        // Step 1
        let path: String = self.encryptWhitespaceInURL(route.path)
        print(path)
        
        // Step 2
        let urlRequest: URLRequest = URLRequest(url: URL(string: path)!)
        
        // Step 3
        let urlSession: URLSession = URLSession(configuration: .default)
        
        // Step 4
        urlSession.dataTask(with: urlRequest, completionHandler: { (data,response,error) in
            DispatchQueue.main.async {
                if let responseData = data {
                    let decoder: JSONDecoder = JSONDecoder()
                    do {
                        let result = try decoder.decode(type.self, from: responseData)
                        complition(result)
                    } catch {
                        failure("Invalid location")
                    }
                } else {
                    failure(error?.localizedDescription ?? "")
                }
            }            
        }).resume()
    }
    
    func encryptWhitespaceInURL(_ urlString: String) -> String {
        let encryptedURLString = urlString.replacingOccurrences(of: " ", with: "%20")
        return encryptedURLString
    }
}



