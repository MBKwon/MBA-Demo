//
//  ViewModel.swift
//  MBA-Demo
//
//  Created by Moonbeom KWON on 2023/09/28.
//

import Combine
import Foundation
import MBAkit

class ViewModel: ViewModelConfigurable {
    
    typealias VC = ViewController
    private(set) var outputSubject = PassthroughSubject<Result<VC.O, Error>, Never>()
    
    func handleMessage(_ inputMessage: VC.I) {
        switch inputMessage {
        case .requestUserInfo:
            self.requestUserInfo()
        }
    }
}

extension ViewModel {
    private func requestUserInfo() {
        Task {
            await APIController.shared
                .request(path: APIController.Path.orderList, method:.get)
                .decode(decoder: [UserInfo].self)
                .map(VC.O.respondToUserInfo(userInfoList:))
                .send(through: self.outputSubject)
        }
    }
}
