//
//  ViewModel.swift
//  MBA-calculator
//
//  Created by Moonbeom KWON on 2/22/25.
//

import Combine
import Foundation
import MBAkit_core

class ViewModel: ViewModelConfigurable {
    
    typealias VC = ViewController
    private(set) var outputSubject = PassthroughSubject<Result<VC.O, Error>, Never>()
    
    private let dataManager: CalcDataManager = CalcDataManager()
    
    func handleMessage(_ inputMessage: VC.I) {
        Task {
            let result: CalcDataManager.CalcResponse
            switch inputMessage {
            case .pushNumber(let number):
                result = await dataManager.push(.number(num: number))
            case .pushClearButton:
                result = await dataManager.push(.clear)
            case .pushEqualButton:
                result = await dataManager.push(.equal)
            case .pushPlusButton:
                result = await dataManager.push(.operator(text: "+"))
            case .pushSubstractButton:
                result = await dataManager.push(.operator(text: "-"))
            case .pushMultiplyButton:
                result = await dataManager.push(.operator(text: "*"))
            case .pushDevideButton:
                result = await dataManager.push(.operator(text: "/"))
            }
            
            switch result {
            case .error:
                outputSubject.send(.success(.showError(text: "[Error Message]")))
            case .result(let text):
                outputSubject.send(.success(.showResult(text: text)))
            }
        }
    }
}
