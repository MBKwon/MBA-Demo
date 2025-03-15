//
//  ViewInteractor.swift
//  MBA-book-browser
//
//  Created by Moonbeom KWON on 2/26/25.
//

import MBAkit_core

class ViewInteractor: ViewInteractorConfigurable {
    
    typealias VC = ViewController
    private var tableViewDelegate: TableViewDelegate?
    
    func handleMessage(_ interactionMessage: ViewController.ViewInteractionMessage) {
        switch interactionMessage {
        case .reloadBookList(let tableView, let datasource, let vc):
            let tableViewDelegate = TableViewDelegate(with: datasource, vc: vc)
            tableView.dataSource = tableViewDelegate
            tableView.delegate = tableViewDelegate
            tableView.reloadData()
            
            self.tableViewDelegate = tableViewDelegate
        }
    }
}
