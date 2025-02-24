//
//  ViewInteractor.swift
//  MBA-calculator
//
//  Created by Moonbeom KWON on 2/24/25.
//

import MBAkit
import UIKit

class ViewInteractor: ViewInteractorConfigurable {
    
    typealias VC = ViewController
    private let resultLabel: UILabel
    
    init(with label: UILabel) {
        resultLabel = label
    }
    
    func handleMessage(_ interactionMessage: ViewController.IM) {
        switch interactionMessage {
        case .updateResult(let text):
            resultLabel.text = text
        }
    }
}
