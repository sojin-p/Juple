//
//  OrderViewModel.swift
//  Juple
//
//  Created by 박소진 on 2024/04/04.
//

import Foundation
import Combine

final class OrderViewModel: ObservableObject {
    
    @Published var askOrderBook: [OrderbookItem] = []
    
    @Published var bidOrderBook: [OrderbookItem] = []
    
    private var cancellable = Set<AnyCancellable>()
    
    func fetchOrder(_ marketCode: [String]) {
        
        WebSocketManager.shared.send(marketCode)
        
        WebSocketManager.shared.orderBookSubject
            .receive(on: DispatchQueue.main)
            .sink { [weak self] orderBook in
                guard let self else { return }
                self.askOrderBook = orderBook.orderbookUnits
                    .map { .init(price: $0.askPrice, size: $0.askSize) }
                    .sorted { $0.price > $1.price }
                self.bidOrderBook = orderBook.orderbookUnits
                    .map { .init(price: $0.bidPrice, size: $0.bidSize) }
                    .sorted { $0.price > $1.price }
            }
            .store(in: &cancellable)
    }
    
    func largestAskSize() -> Double {
        return askOrderBook.sorted {  $0.size > $1.size  }.first!.size
    }
    
    func largestBidSize() -> Double {
        return bidOrderBook.sorted {  $0.size > $1.size  }.first!.size
    }
    
}
