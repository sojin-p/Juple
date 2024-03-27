//
//  WalletView.swift
//  Juple
//
//  Created by 박소진 on 2024/03/20.
//

import SwiftUI

struct WalletView: View {
    
    var wallets = [
        Wallets(color: .cyan, index: 0),
        Wallets(color: .blue, index: 1),
        Wallets(color: .indigo, index: 2)
    ]
    
    var body: some View {
        
        VStack {
            title("My Wallet", size: 30)
            ScrollView() {
                VStack {
                    cardSpace()
                    VStack {
                        title("title", size: 28)
                        CoinlistView()
                    }
                    .offset(y: -365)
                }
            }
        }
        
    }
    
    func title(_ title: String, size: CGFloat) -> some View {
        HStack {
            Text(title)
                .font(.system(size: size, weight: .bold))
                .padding(.horizontal, 25)
                .padding(.vertical, 10)
            Spacer()
        }
    }
    
    func cardSpace() -> some View {
        ForEach(wallets, id: \.self) { item in
            cardView(item)
        }
    }
    
    func cardView(_ data: Wallets) -> some View {
        RoundedRectangle(cornerRadius: 20)
            .fill(data.color)
            .frame(width: CGFloat(data.index + 15) * 20,
                   height: 180)
            .padding(EdgeInsets(top: 4, leading: 20, bottom: 4, trailing: 20))
            .offset(y: CGFloat(data.index) * -188)
    }
}

#Preview {
    WalletView()
}