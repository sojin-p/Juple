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
            
            SegmentedView(
                segments: [CurrencyType.krw, CurrencyType.btc, CurrencyType.usdt],
                selectedSegment: viewModel.selectedSegment,
                selectionChanged: {  selectedSeg in
                    viewModel.filteredCoins(selectedSeg)
                    viewModel.selectedSegment = selectedSeg
                })
            
            .padding(.vertical, 8)
            
            ForEach(viewModel.filteredCoins, id: \.self) { item in
                NavigationLink(value: item) {
                    HStack {
                        cells(.leading,
                              topTitle: item.koreanName,
                              bottomTitle: item.englishName,
                              color: .gray)
                        Spacer()
                        cells(.trailing,
                              topTitle: viewModel.getTradePrice(item.market, selectedSeg: viewModel.selectedSegment),
                              bottomTitle: viewModel.getSignedChangeRateToString(item.market),
                              color: viewModel.getSignedChangeRate(item.market).signedColor())
                    } //HStack
                    .padding(.vertical, 8)
                    .buttonStyle(.plain)
                } //NavigationLink
            } //ForEach
        } //LazyVStack
        .padding(.horizontal, 25)
        .onAppear {
            viewModel.callRequest()
        }
        .onDisappear {
            viewModel.closeWebSocket()
        }
        .navigationDestination(for: Market.self) { market in
            DetailView(market: market)
        }
        .buttonStyle(.plain)
        
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
    
}

#Preview {
    CoinlistView()
}
