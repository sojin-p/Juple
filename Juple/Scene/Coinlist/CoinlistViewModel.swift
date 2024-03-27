//
//  CoinlistViewModel.swift
//  Juple
//
//  Created by 박소진 on 2024/03/27.
//

import Foundation

final class CoinlistViewModel: ObservableObject {
    
    @Published var market = [
        Market(market: "market", koreanName: "비트코인", englishName: "bitcoin"),
        Market(market: "market", koreanName: "비트코인", englishName: "bitcoin")
    ]
    
    func callRequest() {
        
        APIManager.fetchAllmarket { [weak self] data in
            self?.market = data
        }
        
    }
    
}
