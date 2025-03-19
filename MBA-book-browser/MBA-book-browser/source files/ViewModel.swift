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
    
    func handleMessage(_ inputMessage: VC.I) {
        Task {
            switch inputMessage {
            case .loadBookListData(let keyword, let startIndex, let library):
                await loadBookListData(with: keyword, from: startIndex, in: library)
            }
        }
    }
}

extension ViewModel {
    private func loadBookListData(with keyword: String, from startIndex: Int?, in library: APIOpenLibrary) async {
        await library
            .request(with: .search(text: keyword, startIndex: startIndex))
            .decode(decoder: APISearchDataModel.self)
            .map({ VC.O.updateBookList(keyword: keyword, result: $0, paging: startIndex != nil) })
            .send(through: outputSubject)
    }
}
