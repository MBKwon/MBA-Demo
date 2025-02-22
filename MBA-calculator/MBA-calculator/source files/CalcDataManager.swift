//
//  CalcDataManager.swift
//  MBA-calculator
//
//  Created by Moonbeom KWON on 2/22/25.
//

import Foundation

actor CalcDataManager {
    enum CalcElement {
        case number(num: Int)
        case `operator`(text: String)
        case clear
        case equal
    }
    
    enum CalcResponse {
        case error
        case result(text: String)
    }
    
    private var currentText: String = ""
}

extension CalcDataManager {
    func push(_ element: CalcElement) -> CalcResponse {
        switch element {
        case .number(num: let num):
            currentText += "\(num)"
        case .operator(text: let text):
            currentText += text
        case .clear:
            currentText.removeLast()
        case .equal:
            let expression = NSExpression(format: currentText)
            if let result = expression.expressionValue(with: nil, context: nil) {
                currentText = "\(result)"
            } else {
                return .error
            }
        }
        
        return .result(text: currentText)
    }
}
