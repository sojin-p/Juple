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
            ForEach(viewModel.market, id: \.self) { item in
                
                HStack {
                    
                    cells(.leading, topTitle: item.koreanName, bottomTitle: item.englishName, color: .gray)
                    
                    Spacer()
                    
                    cells(.trailing, topTitle: item.market, bottomTitle: "+20%", color: .indigo)
                    
                } //HStack
                .padding(.horizontal, 25)
                .padding(.vertical, 8)
                
            } //ForEach
        } //LazyVStack
//        .frame(width: .infinity, height: .infinity)
        .onAppear {
            viewModel.callRequest()
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
    
}

#Preview {
    CoinlistView()
}
