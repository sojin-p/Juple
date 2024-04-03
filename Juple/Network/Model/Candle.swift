//
//  Candel.swift
//  Juple
//
//  Created by 박소진 on 2024/04/03.
//

import Foundation

struct Candle: Decodable, Hashable {
    let market: String
    let date: String
    let tradePrice: Double
    let highPrice: Double
    let lowPrice: Double
    
    enum CodingKeys: String, CodingKey {
        case market
        case date = "candle_date_time_utc"
        case tradePrice = "trade_price"
        case highPrice = "high_price"
        case lowPrice = "low_price"
    }
}
