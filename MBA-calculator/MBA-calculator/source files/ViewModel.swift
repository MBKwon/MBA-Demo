//
//  ViewModel.swift
//  MBA-calculator
//
//  Created by Moonbeom KWON on 2/22/25.
//

import Combine
import Foundation
import MBAkit

class ViewModel: ViewModelConfigurable {
    
    typealias VC = ViewController
    private(set) var outputSubject = PassthroughSubject<Result<VC.O, Error>, Never>()
    
    func handleMessage(_ inputMessage: VC.I) {
        switch inputMessage {
        case .pushNumber(let number):
            do { }
        case .pushClearButton:
            do { }
        case .pushEqualButton:
            do { }
        case .pushPlusButton:
            do { }
        case .pushSubstractButton:
            do { }
        case .pushMultiplyButton:
            do { }
        case .pushDevideButton:
            do { }
        }
    }
}

extension ViewModel {
    private func requestUserInfo() {
    }
}
