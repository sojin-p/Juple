//
//  CoinlistViewModel.swift
//  Juple
//
//  Created by 박소진 on 2024/03/27.
//

import Foundation
import Combine

final class CoinlistViewModel: ObservableObject {
    
    @Published var coins: [Market] = []
    
    @Published var tickers: [String: Ticker] = [:]
    
    private var cancellable = Set<AnyCancellable>()
    
    func callRequest(_ selectedSeg: SegmentTitle) {
        
        APIManager.fetchAllmarket { [weak self] data in
            
            guard let self else { return }
            
            switch selectedSeg {
            case .krw:
                self.coins = data.filter { $0.market.hasPrefix(SegmentTitle.krw.rawValue) }
            case .btc:
                self.coins = data.filter { $0.market.hasPrefix(SegmentTitle.btc.rawValue) }
            case .usdt:
                self.coins = data.filter { $0.market.hasPrefix(SegmentTitle.usdt.rawValue) }
            }
            
            self.fetchTickers()
            
        }
        
    }
    
    func fetchTickers() {
        
        let codes = coins.map { $0.market }
        
        WebSocketManager.shared.openWebSocket()
        
        WebSocketManager.shared.send(codes)
        
        WebSocketManager.shared.tickerSubject
            .receive(on: DispatchQueue.main)
            .sink { [weak self] ticker in
                guard let self else { return }
                self.tickers[ticker.code] = ticker
            }
            .store(in: &cancellable)
        
    }
    
    func closeWebSocket() {
        print(#function)
        WebSocketManager.shared.closeWebSocket()
    }
    
}
