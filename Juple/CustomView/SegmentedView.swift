//
//  SegmentedView.swift
//  Juple
//
//  Created by 박소진 on 2024/03/28.
//

import SwiftUI

struct SegmentedView<T: RawRepresentable>: View where T: Hashable, T.RawValue == String {
    
    let segments: [T]
    
    @State var selectedSegment: T
    
    @Namespace var name
    
    let selectionChanged: (T) -> Void
    
    var body: some View {
        
        HStack {
            ForEach(segments, id: \.self) { seg in
                Button {
                    selectedSegment = seg
                } label: {
                    segmentsStyle(seg.rawValue, basicColor: .clear, selectedColor: .black)
                }
                .foregroundStyle(.black)
            } //forEach
            .onChange(of: selectedSegment) { newValue in
                selectionChanged(newValue)
            }
        }
    } //body
    
    func segmentsStyle(_ segment: T.RawValue, basicColor: Color, selectedColor: Color) -> some View {
        VStack {
            Text(segment)
                .foregroundColor(selectedSegment.rawValue == segment ? selectedColor : .gray)
                .font(.system(
                    size: 18,
                    weight: selectedSegment.rawValue == segment ? .semibold : .regular))
            ZStack {
                Capsule()
                    .fill(basicColor)
                    .frame(height: 3)
                if selectedSegment.rawValue == segment {
                    Capsule()
                        .fill(selectedColor)
                        .frame(height: 2.5)
                        .matchedGeometryEffect(id: "Tab", in: name)
                }
            } //ZStack
        } //VStack
    }
}
