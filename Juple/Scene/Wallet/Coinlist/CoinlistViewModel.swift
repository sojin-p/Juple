//
//  CoinlistViewModel.swift
//  Juple
//
//  Created by 박소진 on 2024/03/27.
//

import Foundation

final class CoinlistViewModel: ObservableObject {
    
    @Published var coins: [Market] = [
        Market(market: "market", koreanName: "비트코인", englishName: "bitcoin")
    ]
    
    func callRequest(_ selectedSeg: SegmentTitle) {
        
        APIManager.fetchAllmarket { [weak self] data in
            
            switch selectedSeg {
            case .krw:
                self?.coins = data.filter { $0.market.hasPrefix(SegmentTitle.krw.rawValue) }
            case .btc:
                self?.coins = data.filter { $0.market.hasPrefix(SegmentTitle.btc.rawValue) }
            case .usdt:
                self?.coins = data.filter { $0.market.hasPrefix(SegmentTitle.usdt.rawValue) }
            }
            
        }
        
    }
    
}
