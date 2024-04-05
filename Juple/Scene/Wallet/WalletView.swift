//
//  WalletView.swift
//  Juple
//
//  Created by 박소진 on 2024/03/20.
//

import SwiftUI

struct WalletView: View {
    
//    var wallets = [
//        Wallets(color: .walletYellow.opacity(0.2), index: 0),
//        Wallets(color: .walletYellow.opacity(0.5), index: 1),
//        Wallets(color: .walletYellow, index: 2)
//    ]
    
    @State private var searchText = ""
    
    var body: some View {
        
        NavigationStack {
            ScrollView() {
                VStack {
                    title("내 코인", size: 24)
                    cardView()
                    HStack {
                        title("거래소", size: 24)
                        
                        }
                        .padding(.trailing, 20)

                    }
                    CoinlistView()
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
    
//    func cardSpace() -> some View {
//        ForEach(wallets, id: \.self) { item in
//            cardView(item)
//        }
//    }
//    
//    func cardView(_ data: Wallets) -> some View {
//        RoundedRectangle(cornerRadius: 20)
//            .fill(data.color)
//            .frame(width: CGFloat(data.index + 15) * 20,
//                   height: 180)
//            .padding(EdgeInsets(top: 4, leading: 20, bottom: 4, trailing: 20))
//            .offset(y: CGFloat(data.index) * -188)
//    }
    
    func cardView() -> some View {
        ZStack {
            
            RoundedRectangle(cornerRadius: 20)
                .foregroundStyle(.walletYellow.opacity(0.3))
                .frame(maxWidth: .infinity)
                .frame(height: 160)
                .offset(y: -16)
                .padding(20)
            
            RoundedRectangle(cornerRadius: 20)
                .foregroundStyle(.walletYellow.opacity(0.6))
                .frame(maxWidth: .infinity)
                .frame(height: 160)
                .offset(y: -8)
                .padding(10)
            
            RoundedRectangle(cornerRadius: 20)
                .fill(.walletYellow)
                .overlay {
                    Circle()
                        .stroke(style: StrokeStyle(lineWidth: 2))
                        .offset(x: 60, y: -10)
                        .scaleEffect(1.5, anchor: .topLeading)
                    
                    Circle()
                        .stroke(style: StrokeStyle(lineWidth: 2))
                        .offset(x: 40, y: -110)
                        .scaleEffect(1.7, anchor: .topLeading)
                    
                    Circle()
                        .stroke(style: StrokeStyle(lineWidth: 2))
                        .offset(x: -60, y: 40)
                        .scaleEffect(1.5, anchor: .topLeading)
                }
                .foregroundStyle(.orange.opacity(0.1))
                .clipShape(RoundedRectangle(cornerRadius: 20)) //클리핑 마스크
                .frame(maxWidth: .infinity)
                .frame(height: 160)
            
            VStack(alignment: .leading) {
                Text("총 보유자산")
                    .font(.system(size: 16))
                    .foregroundStyle(Color(uiColor: .darkGray))
                    .padding(.vertical, 1)
                Text("3,080,160")
                    .font(.system(size: 32, weight: .bold))
                    .bold()
            }
            .padding(.horizontal, 24)
            .frame(maxWidth: .infinity, alignment: .leading)
            
        } //ZStack
        .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20))
        
    }
}

#Preview {
    WalletView()
}
