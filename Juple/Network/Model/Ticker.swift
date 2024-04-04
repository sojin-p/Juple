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
    let highPrice: Double
    let lowPrice: Double
    let tradeTimestamp: Int
    
    enum CodingKeys: String, CodingKey {
        case code
        case tradePrice = "trade_price"
        case signedChangeRate = "signed_change_rate"
        case highPrice = "high_price"
        case lowPrice = "low_price"
        case tradeTimestamp = "trade_timestamp"
    }
}

struct TickerItem: Hashable {
    let tradePrice: Double
    let signedChangeRate: Double //전일대비
    let highPrice: Double //최고가
    let lowPrice: Double //최저가
    let tradeTimestamp: Int
    
    var signedChangeRateString: String {
        "\(self.signedChangeRate)%"
    }
}
