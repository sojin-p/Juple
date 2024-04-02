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
    
    @Published var filteredCoins: [Market] = []
    
    @Published private var tickerItems: [String: TickerItem] = [:]
    
    private var cancellable = Set<AnyCancellable>()
    
    func callRequest() {
        
        APIManager.fetchAllmarket { [weak self] data in
            
            guard let self else { return }
            
            self.coins = data
            
            filteredCoins(.krw)
            
        }
        
    }
    
    func filteredCoins(_ selectedSeg: CurrencyType) {
        filteredCoins = coins.filter { $0.market.hasPrefix(selectedSeg.rawValue) }
        fetchTickers()
    }
    
    func closeWebSocket() {
        print(#function)
        WebSocketManager.shared.closeWebSocket()
    }
    
    func getTradePrice(_ market: String, selectedSeg: CurrencyType) -> String {
        
        guard let tradePrice = self.tickerItems[market]?.tradePrice else { return "0" }
        
        switch selectedSeg {
        case .krw, .usdt:
            return tradePrice.toCommaString()
        case .btc:
            let formattedTradePrice = String(format: "%.8f", tradePrice)
            return formattedTradePrice
        }
        
    }
    
    func getSignedChangeRate(_ market: String) -> Double {
        guard let signedChangeRate = self.tickerItems[market]?.signedChangeRate else { return 0.0 }
        return signedChangeRate
    }
    
    func getSignedChangeRateToString(_ market: String) -> String {
        guard let signedChangeRate = self.tickerItems[market]?.signedChangeRateString else { return "0%" }
        return signedChangeRate
    }
    
    private func fetchTickers() {
        
        let codes = coins.map { $0.market }
        
        WebSocketManager.shared.openWebSocket()
        
        WebSocketManager.shared.send(codes)
        
        WebSocketManager.shared.tickerSubject
            .receive(on: DispatchQueue.main)
            .sink { [weak self] ticker in
                guard let self else { return }
                self.tickerItems[ticker.code] = TickerItem(
                    tradePrice: ticker.tradePrice,
                    signedChangeRate: roundToTwoDigits(ticker.signedChangeRate))
            }
            .store(in: &cancellable)
        
    }
    
    private func roundToTwoDigits(_ num: Double) -> Double {
        let movedDemicalPoint = num * 100
        return (movedDemicalPoint * 100).rounded() / 100
    }
    
}
