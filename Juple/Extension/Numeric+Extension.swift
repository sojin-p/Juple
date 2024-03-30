//
//  Numeric+Extension.swift
//  Juple
//
//  Created by 박소진 on 2024/03/30.
//

import Foundation

extension Numeric {
    
    func toCommaString() -> String {
        let numberFormatter: NumberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        guard let result = numberFormatter.string(for: self) else { return "" }
        return result
    }
    
}
