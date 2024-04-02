//
//  DetailView.swift
//  Juple
//
//  Created by 박소진 on 2024/04/01.
//

import SwiftUI

struct DetailView: View {
    
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
    }
    
}

#Preview {
    DetailView(market: Market(market: "", koreanName: "", englishName: ""))
}
