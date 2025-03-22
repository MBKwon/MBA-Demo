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
            case .searchBookListData(let keyword):
                await searchBookListData(with: keyword)
            case .pageBookListData(let keyword, let startIndex):
                await pageBookListData(with: keyword, from: startIndex)
            }
        }
    }
}

extension ViewModel {
    private func searchBookListData(with keyword: String) async {
        await apiLibrary
            .request(with: .search(text: keyword, startIndex: 0))
            .decode(decoder: APISearchDataModel.self)
            .map({ VC.O.searchBookList(keyword: keyword, result: $0) })
            .send(through: outputSubject)
    }
    
    private func pageBookListData(with keyword: String, from startIndex: Int) async {
        await apiLibrary
            .request(with: .search(text: keyword, startIndex: startIndex))
            .decode(decoder: APISearchDataModel.self)
            .map({ VC.O.pageBookList(result: $0) })
            .send(through: outputSubject)
    }
}
