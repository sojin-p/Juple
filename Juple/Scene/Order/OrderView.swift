//
//  OrderView.swift
//  Juple
//
//  Created by 박소진 on 2024/03/30.
//

import SwiftUI

struct OrderView: View {
    
    @StateObject var viewModel = OrderViewModel()
    
    let market: Market
    
    var body: some View {
        
        GeometryReader { proxy in
            
            ScrollView {
                
                let graphWidth = proxy.size.width / 3 //그래프 최대 너비
                
                LazyVStack {
                    
                    ForEach(viewModel.askOrderBook, id: \.id) { item in
                        
                        HStack(spacing: 0) {
                            
                            ZStack(alignment: .trailing) { //그래프
                                
                                let graphSize = item.size / viewModel.largestAskSize() * graphWidth
                                
                                Rectangle()
                                    .foregroundStyle(.negativeBlue.opacity(0.3))
                                    .frame(maxWidth: graphSize)
                                
                                Text(item.size.formatted())
                                    .padding(.horizontal, 8)
                                    .frame(width: graphWidth, alignment: .trailing)
                                
                            } //ZStack
                            .frame(width: graphWidth)
                            .background(.negativeBlue.opacity(0.1))
                            
                            Text(item.price.formatted()) //호가
                                .frame(width: graphWidth, height: 40)
                                .background(.negativeBlue.opacity(0.1))
//                                .padding(.horizontal, 2)
                            
                            Spacer()
                            
                        } //HStack
                        .frame(height: 40)
                        .padding(.vertical, -3)
                        
                    } //ForEach_Ask
                    
                    ForEach(viewModel.bidOrderBook, id: \.id) { item in
                        
                        HStack(spacing: 0) {
                            
                            Spacer()
                            
                            Text(item.price.formatted()) //호가
                                .frame(width: graphWidth, height: 40)
                                .background(.positiveRed.opacity(0.1))
//                                .padding(.horizontal, 2)
                            
                            ZStack(alignment: .leading) { //그래프
                                
                                let graphSize = item.size / viewModel.largestBidSize() * graphWidth
                                
                                Rectangle()
                                    .foregroundStyle(.positiveRed.opacity(0.3))
                                    .frame(maxWidth: graphSize)
                                
                                Text(item.size.formatted())
                                    .padding(.horizontal, 8)
                                    .frame(width: graphWidth, alignment: .leading)
                                
                            } //ZStack
                            .frame(width: graphWidth)
                            .background(.positiveRed.opacity(0.1))
                            
                        } //HStack
                        .frame(height: 40)
                        .padding(.vertical, -3)
                        
                    } //ForEach_Bid
                    
                } //VStack
            } //ScrollView
        } //Geometry
        .task {
            viewModel.fetchOrder([market.market])
        }
    }
    
}

//#Preview {
//    OrderView()
//}
