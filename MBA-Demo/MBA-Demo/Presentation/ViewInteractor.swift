//
//  ViewInteractor.swift
//  MBA-Demo
//
//  Created by Moonbeom KWON on 2023/09/28.
//

import Foundation
import MBAkit

class ViewInteractor: ViewInteractorConfigurable {
    
    typealias VC = ViewController
    private var tableViewDelegate: TableViewDelegate?
    
    func handleMessage(_ interactionMessage: ViewController.ViewInteractionMessage) {
        switch interactionMessage {
        case .reloadUserInfoView(let tableView, let userInfoList):
            let tableViewDelegate = TableViewDelegate(with: userInfoList)
            tableView.dataSource = tableViewDelegate
            tableView.delegate = tableViewDelegate
            tableView.reloadData()
            
            self.tableViewDelegate = tableViewDelegate
        }
    }
}
