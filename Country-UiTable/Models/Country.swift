//
//  Country.swift
//  Country-UiTable
//
//  Created by Laptop MCO on 02/08/23.
//

import Foundation

struct Country: Decodable{
    let name: String
    let code: String
    let emoji: String
    let unicode: String
    let image: String
    
    enum CodingKeys: String, CodingKey {
        case name = "name"
        case code = "code"
        case emoji = "emoji"
        case unicode = "unicode"
        case image = "image"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decode(String.self, forKey: .name)
        code = try container.decode(String.self, forKey: .code)
        emoji = try container.decode(String.self, forKey: .emoji)
        unicode = try container.decode(String.self, forKey: .unicode)
        image = try container.decode(String.self, forKey: .image)
        
    }
}
