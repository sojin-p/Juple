//
//  DetailView.swift
//  Juple
//
//  Created by 박소진 on 2024/04/01.
//

import SwiftUI

struct DetailView: View {
    
    @Environment(\.dismiss) var dismiss
    
    let market: Market
    
    let selectedSegment: DetailViewType = .chart
    
    var body: some View {
        
        VStack {
            
            SegmentedView(
                segments: [DetailViewType.chart, DetailViewType.order],
                selectedSegment: selectedSegment) { seg in
                    
                }
                .padding(.vertical, 12)
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
