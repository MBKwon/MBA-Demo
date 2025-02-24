//
//  ViewController.swift
//  MBA-calculator
//
//  Created by Moonbeom KWON on 2/22/25.
//

import MBAkit_core
import UIKit

class ViewController: UIViewController {
    
    @IBOutlet private weak var resultLabel: UILabel!
    
    private(set) var microBean: MicroBean<ViewController, ViewModel, ViewInteractor>?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.microBean = MicroBean(withVC: self,
                                   viewModel: ViewModel(),
                                   viewInteractor: ViewInteractor(with: resultLabel))
    }
}

extension ViewController {
    @IBAction private func pushNumberButton(_ sender: UIButton) {
        let number = sender.tag
        self.microBean?.handle(inputMessage: .pushNumber(number: number))
    }
    
    @IBAction private func pushClearButton(_ sender: UIButton) {
        self.microBean?.handle(inputMessage: .pushClearButton)
    }
    
    @IBAction private func pushEqualButton(_ sender: UIButton) {
        self.microBean?.handle(inputMessage: .pushEqualButton)
    }
    
    @IBAction private func pushPlusButton(_ sender: UIButton) {
        self.microBean?.handle(inputMessage: .pushPlusButton)
    }
    
    @IBAction private func pushSubstractButton(_ sender: UIButton) {
        self.microBean?.handle(inputMessage: .pushSubstractButton)
    }
    
    @IBAction private func pushMultiplyButton(_ sender: UIButton) {
        self.microBean?.handle(inputMessage: .pushMultiplyButton)
    }
    
    @IBAction private func pushDevideButton(_ sender: UIButton) {
        self.microBean?.handle(inputMessage: .pushDevideButton)
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
        case showError(text: String)
    }
}

extension ViewController: ViewContollerInteractable {
    typealias VI = ViewInteractor
    
    typealias IM = PresentationMessage
    enum PresentationMessage: InteractionMessage {
        case updateResult(text: String)
    }
    
    func convertToInteraction(from outputMessage: ResultMessage) -> PresentationMessage {
        switch outputMessage {
        case .showResult(let text):
            return .updateResult(text: text)
        case .showError(let text):
            return .updateResult(text: text)
        }
    }
}
