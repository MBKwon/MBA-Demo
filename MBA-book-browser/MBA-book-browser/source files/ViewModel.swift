//
//  ViewModel.swift
//  MBA-book-browser
//
//  Created by Moonbeom KWON on 2/26/25.
//

import Combine
import MBAkit_core

class ViewModel: ViewModelConfigurable {
    
    typealias VC = ViewController
    private(set) var outputSubject = PassthroughSubject<Result<VC.O, Error>, Never>()
    
    private lazy var apiLibrary: APIOpenLibrary = .init()
    
    func handleMessage(_ inputMessage: VC.I) {
        Task {
            switch inputMessage {
            case .loadBookListData(let keyword, let startIndex):
                await loadBookListData(with: keyword, from: startIndex)
            }
        }
    }
}

extension ViewModel {
    private func loadBookListData(with keyword: String, from startIndex: Int?) async {
        await apiLibrary
            .request(with: .search(text: keyword, startIndex: startIndex))
            .decode(decoder: APISearchDataModel.self)
            .map({ VC.O.updateBookList(keyword: keyword, result: $0, paging: startIndex != nil) })
            .send(through: outputSubject)
    }
}
