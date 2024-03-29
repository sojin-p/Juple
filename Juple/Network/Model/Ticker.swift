//
//  Ticker.swift
//  Juple
//
//  Created by 박소진 on 2024/03/29.
//

import Foundation

struct Ticker: Decodable, Hashable {
    let code: String
    let tradePrice: Double
    let signedChangeRate: Double
    
    enum CodingKeys: String, CodingKey {
        case code
        case tradePrice = "trade_price"
        case signedChangeRate = "signed_change_rate"
    }
}
