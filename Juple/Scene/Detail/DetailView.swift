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
                    .font(.system(size: 32, weight: .bold))
                    .padding(EdgeInsets(top: 20, leading: 0, bottom: 4, trailing: 0))
                ZStack {
                    Capsule()
                        .fill(.walletYellow)
                        .frame(width: 78, height: 30)
                    Text(viewModel.getSignedChangeRateToString(market.market))
                        .foregroundStyle(viewModel.getSignedChangeRate(market.market).signedColor())
                        .font(.system(size: 16, weight: .bold))
                } //ZStack
                .padding(EdgeInsets(top: 0, leading: 0, bottom: 30, trailing: 0))
            } //VStack
            
            SegmentedView(
                segments: [DetailViewType.chart, DetailViewType.order],
                selectedSegment: selectedSegment) { seg in
                    viewModel.selectedViewType = seg
                }
                .padding(.top, 12)
                .padding(.bottom, -8.5)
            Spacer()
        }
            
        } //Vstack
        .background(.walletYellow.opacity(0.2))
        .navigationTitle("\(market.koreanName)")
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItemGroup(placement: .topBarLeading) {
                Button {
                    dismiss.callAsFunction()
                } label: {
                    ZStack {
//                        Circle()
//                            .fill(.white)
//                            .frame(width: 45, height: 45)
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
