//
//  APIConstants.swift
//  MazaadyTask
//
//  Created by iMokhles on 16/01/2023.
//

import Foundation

enum APIConstants {
    
    struct EndPoints {
        static let getAllCats = "get_all_cats"
        static let getCatOptions = "properties?cat="
    }
    struct Network {
        static let timeoutInterval: TimeInterval = 150
        static let baseUrl = "https://staging.mazaady.com/api/v1/"
        static let optionsUrl = "https://staging.mazaady.com/api/v1/"
    }
}
