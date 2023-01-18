//
//  OptionsData.swift
//  MazaadyTask
//
//  Created by iMokhles on 17/01/2023.
//

import Foundation

// MARK: - Datum
struct OptionsData: Codable {
    let id: Int?
    let name, description, slug: String?
    let parent: JSONNull?
    let list: Bool?
    let type: String?
    let value: String?
    let otherValue: JSONNull?
    var options: [Options]?

    enum CodingKeys: String, CodingKey {
        case id, name, description, slug, parent, list, type, value
        case otherValue = "other_value"
        case options
    }
}

// MARK: - Encode/decode helpers

class JSONNull: Codable, Hashable {

    public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
        return true
    }

    public var hashValue: Int {
        return 0
    }

    public init() {}

    public required init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if !container.decodeNil() {
            throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encodeNil()
    }
}
