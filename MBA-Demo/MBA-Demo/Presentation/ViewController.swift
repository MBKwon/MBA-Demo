//
//  ViewController.swift
//  MBA-Demo
//
//  Created by Moonbeom KWON on 2023/09/28.
//

import Combine
import MBAkit
import UIKit

class ViewController: UITableViewController {
    
    private(set) var microBean: MicroBean<ViewController, ViewModel, ViewInteractor>?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        self.microBean = MicroBean(withVC: self,
                                   viewModel: ViewModel(),
                                   viewInteractor: ViewInteractor(),
                                   observeMessage: { result in
            print(result)
        })
        
        self.microBean?.handle(inputMessage: .requestUserInfo)
    }
}

// MARK: - VC-VM : input message -> output messaage
extension ViewController: ViewControllerConfigurable {
    
    typealias VM = ViewModel
    
    typealias I = ViewInputMessage
    enum ViewInputMessage: InputMessage {
        case requestUserInfo
    }
    
    typealias O = ViewOutputMessage
    enum ViewOutputMessage: OutputMessage {
        case respondToUserInfo(userInfoList: [UserInfo])
    }
}

// MARK: - VM-VI : output messaage -> interaction message
extension ViewController: ViewContollerInteractable {
    
    typealias VI = ViewInteractor
    
    typealias IM = ViewInteractionMessage
    enum ViewInteractionMessage: InteractionMessage {
        case reloadUserInfoView(tableView: UITableView, userInfoList: [UserInfo])
    }
    
    
    func convertToInteraction(from outputMessage: ViewOutputMessage) -> ViewInteractionMessage {
        switch outputMessage {
        case .respondToUserInfo(let userInfoList):
            return .reloadUserInfoView(tableView: self.tableView, userInfoList: userInfoList)
        }
    }
}
