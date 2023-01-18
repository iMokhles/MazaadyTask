//
//  BaseService.swift
//  MazaadyTask
//
//  Created by iMokhles on 16/01/2023.
//

import Foundation
import Alamofire

public class BaseService {
    class func responseService<T: Codable>(_ url: URL,
                                           method: HTTPMethod = .get,
                                           params: Parameters? = nil,
                                           completion: @escaping (Result<T, AFError>) -> Void) {
        CoreAPI.sharedInstance.manager.request(url,
                                               method: method,
                                               parameters: params,
                                               encoding: URLEncoding.default)
            .validate(statusCode: 200 ..< 299).responseDecodable(of: T.self) { response in
                switch response.result {
                case let .success(results):
                    completion(.success(results))
                case let .failure(error):
                    completion(.failure(error))
                }
            }
    }
}
