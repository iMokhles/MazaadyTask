//
//  CategoriesResponse.swift
//  MazaadyTask
//
//  Created by iMokhles on 16/01/2023.
//

import Foundation

// MARK: - Response
struct CategoriesResponse: Codable {
    let code: Int?
    let msg: String?
    let data: CategoriesData?
}
