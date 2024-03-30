//
//  CoinlistView.swift
//  Juple
//
//  Created by 박소진 on 2024/03/27.
//

import SwiftUI

struct CoinlistView: View {
    
    @StateObject var viewModel = CoinlistViewModel()
    
    var body: some View {
        LazyVStack {
            
            SegmentedView(segments: [.krw, .btc, .usdt], selectedSegment: .krw) { selectedSeg in
                viewModel.callRequest(selectedSeg)
            }
            .padding(.vertical, 8)
            
            ForEach(viewModel.coins, id: \.self) { item in
                NavigationLink(value: item) {
                    HStack {
                        cells(.leading,
                              topTitle: item.koreanName,
                              bottomTitle: item.englishName,
                              color: .gray)
                        Spacer()
                        cells(.trailing,
                              topTitle: viewModel.getTradePrice(item.market),
                              bottomTitle: viewModel.getSignedChangeRateToString(item.market),
                              color: colorForNumber(viewModel.getSignedChangeRate(item.market)))
                    } //HStack
                    .padding(.vertical, 8)
                    .buttonStyle(.plain)
                } //NavigationLink
            } //ForEach
        } //LazyVStack
        .padding(.horizontal, 25)
        .onAppear {
            viewModel.callRequest(.krw)
        }
        
    } //body
    
    func cells(_ alignment: HorizontalAlignment, topTitle: String, bottomTitle: String, color: Color) -> some View {
        VStack(alignment: alignment) {
            Text(topTitle)
                .fontWeight(.bold)
                .padding(.vertical, 1)
            Text(bottomTitle)
                .font(.caption)
                .foregroundStyle(color)
        } //VStack
    }
    
    func colorForNumber(_ num: Double) -> Color {
        return num >= 0 ? .red : .indigo
    }
    
}

#Preview {
    CoinlistView()
}
