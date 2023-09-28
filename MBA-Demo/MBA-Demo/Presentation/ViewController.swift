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
    
    
    private(set) var viewInteractor = ViewInteractor()
    private(set) var viewModel = ViewModel()
    private(set) var cancellables = Set<AnyCancellable>()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.bindViewModel(self.viewModel)
        self.viewModel.handleMessage(.requestUserInfo)
    }
}

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
    
    func bindViewModel(_ viewModel: ViewModel) {
        viewModel.outputSubject
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: self.handleResult(_:))
            .store(in: &self.cancellables)
    }
    
    func handleResult(_ result: Result<ViewOutputMessage, Error>) {
        let handleOutputMessage: (ViewOutputMessage) -> Void = {
            self.viewInteractor.handleMessage(self.convertToInteraction(from: $0))
        }
        
        result.fold(success: handleOutputMessage,
                    failure: { (error) in
            print(error.localizedDescription)
        })
    }
}

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
