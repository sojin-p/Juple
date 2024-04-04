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
            .chartYScale(domain: viewModel.getChartDomain()) // y 범위
            .chartOverlay { proxy in
                
                let highPos = proxy.position(for: (viewModel.getHighXPosition(), viewModel.highTrade))
                let lowPos = proxy.position(for: (viewModel.getLowXPosition(), viewModel.lowTrade))
                
                Group {
                    Circle()
                        .frame(width: 6, height: 6)
                    Text("최고 \(viewModel.highPrice.toCommaString())")
                        .offset(CGSize(width: 0, height: -18))
                        .shadow(color: .white, radius: 2)
                        .font(.caption)
                }
                .position(highPos ?? .zero)
                .foregroundColor(.red)
                
                Group {
                    Circle()
                        .frame(width: 6, height: 6)
                    Text("최저 \(viewModel.lowPrice.toCommaString())")
                        .offset(CGSize(width: 0, height: 18))
                        .shadow(color: .white, radius: 2)
                        .font(.caption)
                }
                .position(lowPos ?? .zero)
                .foregroundColor(.indigo)
                
            }
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
