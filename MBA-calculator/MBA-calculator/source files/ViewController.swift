//
//  ViewController.swift
//  MBA-calculator
//
//  Created by Moonbeom KWON on 2/22/25.
//

import MBAkit
import UIKit

class ViewController: UIViewController {
    
    @IBOutlet private weak var resultLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
}

extension ViewController {
    @IBAction private func pushButton(_ sender: UIButton) {
        let buttonContent = sender.currentTitle
    }
}

extension ViewController: ViewControllerConfigurable {
    typealias VM = ViewModel
    
    typealias I = CalcMessage
    enum CalcMessage: InputMessage {
        case pushNumber(number: Int)
        case pushClearButton
        case pushEqualButton
        case pushPlusButton
        case pushSubstractButton
        case pushMultiplyButton
        case pushDevideButton
    }
    
    typealias O = ResultMessage
    enum ResultMessage: OutputMessage {
        case showResult(text: String)
    }
}
