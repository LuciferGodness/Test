//
//  ApiService.swift
//  ToDoList
//
//  Created by Admin on 8/28/24.
//

import Foundation

enum HTTPMethod: String {
    case get = "GET"
}

final class ApiService {
    func sendRequest<Response: Decodable>(url: Endpoints, method: HTTPMethod = .get, completion: @escaping (Result<Response, Error>) -> Void){
        guard let url = URL(string: url.string) else {
            completion(.failure(URLError(.badURL)))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        
        return fetchData(urlRequest: request, completion: completion)
    }
    
    private func fetchData<Response: Decodable>(urlRequest: URLRequest, completion: @escaping (Result<Response, Error>) -> Void) {
        DispatchQueue.global(qos: .background).async {
            URLSession.shared.dataTask(with: urlRequest) { data, response, error in
                if let error = error {
                    DispatchQueue.main.async {
                        completion(.failure(error))
                    }
                    return
                }
                
                guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode), let data = data else {
                    DispatchQueue.main.async {
                        completion(.failure(URLError(.badServerResponse)))
                    }
                    return
                }
                
                do {
                    let decoder = JSONDecoder()
                    let decoderResponse = try decoder.decode(Response.self, from: data)
                    DispatchQueue.main.async {
                        completion(.success(decoderResponse))
                    }
                } catch {
                    DispatchQueue.main.async {
                        completion(.failure(error))
                    }
                }
            }.resume()
        }
    }
}
