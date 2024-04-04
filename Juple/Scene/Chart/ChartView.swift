//
//  ChartView.swift
//  Juple
//
//  Created by 박소진 on 2024/04/01.
//

import SwiftUI
import Charts

struct ChartView: View {
    
    @EnvironmentObject var viewModel: CoinlistViewModel
    
    let market: Market
    
    var body: some View {
        
        VStack {
            Chart {
                ForEach(viewModel.candles, id: \.self) { item in
                    LineMark(
                        x: .value("Time", item.date.toDate() ?? Date()),
                        y: .value("Price", item.tradePrice)
                    )
                    .interpolationMethod(.catmullRom)
                } //ForEach
            } //Chart
        } //VStack
        .task {
            print("task")
            viewModel.fetchCandle(market.market)
        }
//        .frame(width: .infinity, height: .infinity)
        .padding(EdgeInsets(top: 0, leading: 0, bottom: 12, trailing: 20))
        
    }
    
}

//#Preview {
//    ChartView()
//}
