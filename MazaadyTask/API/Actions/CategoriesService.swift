//
//  CategoriesService.swift
//  MazaadyTask
//
//  Created by iMokhles on 16/01/2023.
//

import Foundation
import Alamofire

public class CategoriesService: BaseService {
    class func getCategories(completion: @escaping (Result<CategoriesResponse, AFError>) -> Void) {
        guard let url = URL(string:"\(APIConstants.Network.baseUrl)\(APIConstants.EndPoints.getAllCats)") else { return }
        responseService(url, method: .get, params: nil, completion: completion)
    }
    
    class func getCategoryOptions(category: Category, completion: @escaping (Result<OptionsResponse, AFError>) -> Void) {
        guard let url = URL(string:"\(APIConstants.Network.baseUrl)\(APIConstants.EndPoints.getCatOptions)\(category.id ?? 0)") else { return }
        responseService(url, method: .get, params: nil, completion: completion)
    }

}
