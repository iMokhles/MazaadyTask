//
//  OptionsResponse.swift
//  MazaadyTask
//
//  Created by iMokhles on 17/01/2023.
//

import Foundation

// MARK: - OptionsResponse
struct OptionsResponse: Codable {
    let code: Int?
    let msg: String?
    let data: [OptionsData]?
}
