//
//  NetworkManager.swift
//  Marketplace
//
//  Created by Нуржан Орманали on 01.03.2021.
//

import Alamofire
import Foundation

class NetworkManager {
    static let shared = NetworkManager()
    
    private init() { }
    
    func request<T: Codable>(url: String, method: HTTPMethod, parameters: [String : Any]? = nil, headers: HTTPHeaders? = nil, completion: @escaping (Result<T, ErrorModel>) -> Void) {
        
        AF.request(url, method: method, parameters: parameters, encoding: JSONEncoding(), headers: headers, interceptor: nil, requestModifier: nil).responseData { (response) in
            switch (response.result) {
            case .success:
                guard let data = response.data else {
                    completion(.failure(ErrorModel(code: "0", data: ErrorData(status: 0), message: "Невалидные данные")))
                    return
                }
                print(data.prettyPrintedJSONString ?? "JSON NOT FOUND")
                guard let statusCode = response.response?.statusCode, statusCode == 200 else {
                    self.serializeResponse(from: data, statusCode: response.response?.statusCode ?? 0, completion: completion)
                    return
                }
                self.serializeResponse(from: data, statusCode: statusCode, completion: completion)
            case .failure(let error):
//                Alert.shared.show(title: "Ошибка", message: error.localizedDescription, complitionHandler: nil)
            break
            }
        }
    }
    
    private func serializeResponse<T: Codable>(from data: Data, statusCode: Int, completion: @escaping (Result<T, ErrorModel>) -> Void) {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        do {
            let decodedModel = try decoder.decode(T.self, from: data)
            completion(.success(decodedModel))
        } catch {
            do {
                let errorModel = try decoder.decode(ErrorModel.self, from: data)
                completion(.failure(errorModel))
            } catch {
                completion(.failure(ErrorModel(code: "1", data: ErrorData(status: statusCode), message: error.localizedDescription)))
            }
        }
    }
    
}


extension Data {
    var prettyPrintedJSONString: NSString? { /// NSString gives us a nice sanitized debugDescription
        guard let object = try? JSONSerialization.jsonObject(with: self, options: []),
              let data = try? JSONSerialization.data(withJSONObject: object, options: [.prettyPrinted]),
              let prettyPrintedString = NSString(data: data, encoding: String.Encoding.utf8.rawValue) else { return nil }

        return prettyPrintedString
    }
}
