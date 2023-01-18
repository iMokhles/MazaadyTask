//
//  Category.swift
//  MazaadyTask
//
//  Created iMokhles on 16/01/2023.
//

/// Category Model
// MARK: - Category
struct Category: Codable {
    
    let id: Int?
    let name: String?
    let description: String?
    let image: String?
    let slug: String?
    let children: [Category]?
    let circleIcon: String?
    let disableShipping: Int?

    enum CodingKeys: String, CodingKey {
        case id, name, description, image, slug, children
        case circleIcon = "circle_icon"
        case disableShipping = "disable_shipping"
    }
}
