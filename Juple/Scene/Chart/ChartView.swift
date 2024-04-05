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
    
    let chartGradient = LinearGradient(
        gradient: Gradient (
            colors: [
                .orange.opacity(0.4),
                .orange.opacity(0.1),
                .clear
            ]
        ),
        startPoint: .top,
        endPoint: .bottomTrailing
    )
    
    var body: some View {
        
        VStack {
            Chart {
                ForEach(viewModel.candles, id: \.self) { item in
                    LineMark(
                        x: .value("Time", item.date.toDate() ?? Date()),
                        y: .value("Price", item.tradePrice)
                    )
//                    .interpolationMethod(.catmullRom)
                    AreaMark (
                        x: .value("Time", item.date.toDate() ?? Date()),
                        y: .value("Price", item.tradePrice)
                    )
                    .foregroundStyle(chartGradient)
                    .alignsMarkStylesWithPlotArea()
                    
                } //ForEach
            } //Chart
            .foregroundStyle(.orange)
            .chartYScale(domain: viewModel.getChartDomain()) // y 범위
            .chartYAxis {
                AxisMarks(values: .automatic(desiredCount: 5)) {
                    AxisValueLabel()
                    AxisGridLine()
                        .foregroundStyle(.gray.opacity(0.2))
                }
            }
            .chartXAxis {
                AxisMarks(values: .automatic(desiredCount: 4)) {
                    AxisValueLabel()
                    AxisGridLine()
                        .foregroundStyle(.gray.opacity(0.2))
                }
            }
            .chartOverlay { proxy in
                
                let highPos = proxy.position(for: (viewModel.getHighXPosition(), viewModel.highTrade))
                let lowPos = proxy.position(for: (viewModel.getLowXPosition(), viewModel.lowTrade))
                
                Group {
                    Circle()
                        .frame(width: 6, height: 6)
                    Text("최고 \(viewModel.highPrice.toCommaString())")
                        .offset(CGSize(width: 0, height: -18))
                        .font(.caption)
                        .fontWeight(.semibold)
                }
                .position(highPos ?? .zero)
                .foregroundColor(.positiveRed)
                
                Group {
                    Circle()
                        .frame(width: 6, height: 6)
                    Text("최저 \(viewModel.lowPrice.toCommaString())")
                        .offset(CGSize(width: 0, height: 18))
                        .font(.caption)
                        .fontWeight(.semibold)
                }
                .position(lowPos ?? .zero)
                .foregroundColor(.negativeBlue)
                
            } //chartOverlay
        } //VStack
        .task {
            print("task")
            viewModel.fetchCandle(market.market)
        }
        .padding(EdgeInsets(top: 10, leading: 0, bottom: 12, trailing: 16))
        
    }
    
}

//#Preview {
//    ChartView()
//}
