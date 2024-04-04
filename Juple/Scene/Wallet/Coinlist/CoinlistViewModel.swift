//
//  CoinlistViewModel.swift
//  Juple
//
//  Created by 박소진 on 2024/03/27.
//

import Foundation
import Combine

final class CoinlistViewModel: ObservableObject {
    
    @Published var filteredCoins: [Market] = []
    
    @Published var selectedSegment: CurrencyType = .krw
    
    @Published var tickerItems: [String: TickerItem] = [:]
    
    @Published var candles: [Candle] = []
    
    @Published private var coins: [Market] = []
    
    private var cancellable = Set<AnyCancellable>()
    
    var webSocketIsOpen: Bool = false {
        didSet {
            if webSocketIsOpen {
                fetchTickers()
            } else {
                closeWebSocket()
            }
        }
    }
    
    init() {
        
        APIManager.fetchAllmarket { [weak self] data in
            
            guard let self else { return }
            
            self.coins = data
            
            filteredCoins(.krw)
            
            webSocketIsOpen = true
            
        }
        
    }
    
    func fetchCandle(_ marketCode: String) {
        
        APIManager.fetchCandle(marketCode) { [weak self] candle in
            guard let self else { return }
            self.candles = candle.reversed()
        }
        
    }
    
    func filteredCoins(_ selectedSeg: CurrencyType) {
        filteredCoins = coins.filter { $0.market.hasPrefix(selectedSeg.rawValue) }
    }
    
    func getTradePrice(_ marketCode: String, selectedSeg: CurrencyType) -> String {

        guard let tradePrice = self.tickerItems[marketCode]?.tradePrice else { return "불러오는 중" }
        
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
        guard let signedChangeRate = self.tickerItems[market]?.signedChangeRateString else { return "..." }
        return signedChangeRate
    }
    
    func getChartDomain() -> ClosedRange<Double> {
        
        guard let max = self.candles.map({ $0.tradePrice }).max() else { return 0...0 }
        guard let min = self.candles.map({ $0.tradePrice }).min() else { return 0...0 }
        
        return (min * 0.999)...(max * 1.001)
        
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
    
    private func closeWebSocket() {
        print(#function)
        WebSocketManager.shared.closeWebSocket()
    }
    
    private func roundToTwoDigits(_ num: Double) -> Double {
        let movedDemicalPoint = num * 100
        return (movedDemicalPoint * 100).rounded() / 100
    }
    
}
