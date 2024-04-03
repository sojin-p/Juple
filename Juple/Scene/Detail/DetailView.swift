//
//  DetailView.swift
//  Juple
//
//  Created by 박소진 on 2024/04/01.
//

import SwiftUI

struct DetailView: View {
    
    @EnvironmentObject var viewModel: CoinlistViewModel
    
    @Environment(\.dismiss) var dismiss
    
    let market: Market
    
    let selectedSegment: DetailViewType = .chart
    
    var body: some View {
        
        VStack {
            
            VStack(alignment: .center) {
                Text("\(viewModel.getTradePrice(market.market, selectedSeg: viewModel.selectedSegment))")
                    .font(.system(size: 32, weight: .semibold))
                    .padding(EdgeInsets(top: 20, leading: 0, bottom: 4, trailing: 0))
                ZStack {
                    Capsule()
                        .fill(.yellow)
                        .frame(width: 76, height: 32)
                    Text(viewModel.getSignedChangeRateToString(market.market))
                        .foregroundStyle(viewModel.getSignedChangeRate(market.market).signedColor())
                        .font(.system(size: 16))
                } //ZStack
                .padding(EdgeInsets(top: 0, leading: 0, bottom: 16, trailing: 0))
            } //VStack
            
            SegmentedView(
                segments: [DetailViewType.chart, DetailViewType.order],
                selectedSegment: selectedSegment) { seg in
                    
                }
                .padding(.vertical, 12)
            Spacer()
        }
        .navigationTitle("\(market.koreanName)")
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItemGroup(placement: .topBarLeading) {
                Button {
                    dismiss.callAsFunction()
                } label: {
                    ZStack {
                        Circle()
                            .fill(.cyan)
                            .opacity(0.5)
                            .frame(width: 42, height: 42)
                        Image(systemName: "arrow.backward")
                            .foregroundStyle(.black)
                    } //ZStack
                } //Button Label
            } //ToolbarItemGroup
        } //toolbar
        
    }
    
}

#Preview {
    DetailView(market: Market(market: "", koreanName: "", englishName: ""))
}
