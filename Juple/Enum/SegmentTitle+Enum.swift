//
//  SegmentTitle+Enum.swift
//  Juple
//
//  Created by 박소진 on 2024/03/28.
//

import Foundation

enum CurrencyType: String, CaseIterable, Hashable {
    case krw = "KRW"
    case btc = "BTC"
    case usdt = "USDT"
}

enum DetailViewType: String, CaseIterable, Hashable {
    case order = "호가"
    case chart = "차트"
}
