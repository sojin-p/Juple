//
//  SegmentedView.swift
//  Juple
//
//  Created by 박소진 on 2024/03/28.
//

import SwiftUI

struct SegmentedView: View {
    
    let segments: [SegmentTitle]
    
    @State var selectedSegment: SegmentTitle
    
    @Namespace var name
    
    let selectionChanged: (SegmentTitle) -> Void
    
    var body: some View {
        
        HStack {
            ForEach(segments, id: \.self) { seg in
                Button {
                    selectedSegment = seg
                } label: {
                    segmentsStyle(seg.rawValue, basicColor: .clear, selectedColor: .indigo)
                }
                .foregroundStyle(.black)
            } //forEach
            .onChange(of: selectedSegment) { newValue in
                selectionChanged(newValue)
            }
        }
    } //body
    
    func segmentsStyle(_ segment: String, basicColor: Color, selectedColor: Color) -> some View {
        VStack {
            Text(segment)
                .foregroundColor(selectedSegment.rawValue == segment ? selectedColor : Color(uiColor: .systemGray))
            ZStack {
                Capsule()
                    .fill(basicColor)
                    .frame(height: 3)
                if selectedSegment.rawValue == segment {
                    Capsule()
                        .fill(selectedColor)
                        .frame(height: 3)
                        .matchedGeometryEffect(id: "Tab", in: name)
                }
            } //ZStack
        } //VStack
    }
}
