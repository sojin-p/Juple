//
//  Market.swift
//  Juple
//
//  Created by 박소진 on 2024/03/27.
//

import Foundation

struct Market: Decodable, Hashable {
    let market: String
    let koreanName: String
    let englishName: String
    
    enum CodingKeys: String, CodingKey {
        case market
        case koreanName = "korean_name"
        case englishName = "english_name"
    }
}
