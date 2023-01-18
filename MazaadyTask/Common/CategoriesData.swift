//
//  CategoriesData.swift
//  MazaadyTask
//
//  Created by iMokhles on 16/01/2023.
//

import Foundation


// MARK: - DataClass
struct CategoriesData: Codable {
    let categories: [Category]?
    let statistics: Statistics?
    let adsBanners: [AdsBanner]?
    let iosVersion, googleVersion, huaweiVersion: String?

    enum CodingKeys: String, CodingKey {
        case categories, statistics
        case adsBanners = "ads_banners"
        case iosVersion = "ios_version"
        case googleVersion = "google_version"
        case huaweiVersion = "huawei_version"
    }
}

// MARK: - AdsBanner
struct AdsBanner: Codable {
    let img: String?
    let mediaType: String?
    let duration: Int?

    enum CodingKeys: String, CodingKey {
        case img
        case mediaType = "media_type"
        case duration
    }
}

// MARK: - Statistics
struct Statistics: Codable {
    let auctions, users, products: Int?
}
