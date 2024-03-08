//
//  TargetType.swift
//  App
//
//  Created by PKW on 2024/01/02.
//

import Foundation
import Alamofire

protocol TargetType: URLRequestConvertible {
    var baseURL: String { get }
    var method: HTTPMethod { get }
    var path: String { get }
    var parameters: RequestParams { get }
}

extension TargetType {
    
    var baseURL: String {
        return NetworkConfiguration.baseUrl
    }
    
    func asURLRequest() throws -> URLRequest {
        let url = try baseURL.asURL()
        var urlRequest = try URLRequest(url: url.appendingPathComponent(path), method: method)
        
        urlRequest.setValue(ContentType.json.rawValue, forHTTPHeaderField: HTTPHeaderField.contentType.rawValue)
        
        switch parameters {
        case .qurey(let request):
            let params = request?.toDictionary() ?? [:]
            let queryParams = params.map { URLQueryItem(name: $0.key, value: "\($0.value)") }
            var components = URLComponents(string: url.appendingPathComponent(path).absoluteString)
            components?.queryItems = queryParams
            urlRequest.url = components?.url
            
        case .body(let request):
            let params = request?.toDictionary() ?? [:]
            urlRequest.httpBody = try JSONSerialization.data(withJSONObject: params, options: [])
        case .queryAndBody(let query, let body):
            let query = query?.toDictionary() ?? [:]

            let queryParams = query.map { URLQueryItem(name: $0.key, value: "\($0.value)") }
            
            var components = URLComponents(string: url.appendingPathComponent(path).absoluteString)
            components?.queryItems = queryParams
            urlRequest.url = components?.url
            
            let body = body?.toDictionary() ?? [:]
            urlRequest.httpBody = try JSONSerialization.data(withJSONObject: body, options: [])
        }
        
        return urlRequest
    }
}

enum RequestParams {
    case qurey(_ parameter: Encodable?)
    case body(_ parameter: Encodable?)
    case queryAndBody(_ query: Encodable?,_ body: Encodable?)
}

extension Encodable {
    func toDictionary() -> [String: Any] {
        guard let data = try? JSONEncoder().encode(self),
              let jsonData = try? JSONSerialization.jsonObject(with: data),
              let dictionaryData = jsonData as? [String: Any] else { return [:] }
        return dictionaryData
    }
}
