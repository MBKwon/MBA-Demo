//
//  ViewController.swift
//  MBA-book-browser
//
//  Created by Moonbeom KWON on 2/24/25.
//

import MBAkit_core
import UIKit

class ViewController: UIViewController {
    
    enum SegueIdentifier: String {
        case showBookDetail
    }
    
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var loadingBackgroundView: UIView!
    @IBOutlet private weak var loadingIndicatorView: UIActivityIndicatorView!
    
    private var datasource: TableViewDelegate.BookListData?
    
    private var isPrefetching: Bool = false {
        didSet {
            loadingBackgroundView.isHidden = !isPrefetching
            if isPrefetching {
                loadingIndicatorView.startAnimating()
            } else {
                loadingIndicatorView.stopAnimating()
            }
        }
    }
    
    private(set) var microBean: MicroBean<ViewController, ViewModel, ViewInteractor>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView.isPrefetchingEnabled = true
        tableView.prefetchDataSource = self
        
        microBean = MicroBean(withVC: self,
                              viewModel: ViewModel(),
                              viewInteractor: ViewInteractor())
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == SegueIdentifier.showBookDetail.rawValue,
           let detailVC = segue.destination as? BookDetailViewController,
           let selectedBook = sender as? APIBookDataModel {
            detailVC.selectedBook = selectedBook
        }
    }
    
    private func loadBookList(with keyword: String) {
        let message = {
            if let datasource = self.datasource, datasource.keyword == keyword {
                return I.pageBookListData(keyword: keyword,
                                          startIndex: datasource.itemList.count)
            } else {
                return I.searchBookListData(keyword: keyword)
            }
        }()
        microBean?.handle(inputMessage: message)
    }
    
    private func reloadTableView(with result: Result<APISearchDataModel, Error>) {
        result.fold(success: { _ in tableView.reloadData() },
                    failure: { print($0.localizedDescription) })
        
        isPrefetching = false
    }
}

extension ViewController: ViewControllerConfigurable {
    
    typealias VM = ViewModel
    
    typealias I = ViewInputMessage
    enum ViewInputMessage: InputMessage {
        case searchBookListData(keyword: String)
        case pageBookListData(keyword: String, startIndex: Int)
    }
    
    typealias O = ViewOutputMessage
    enum ViewOutputMessage: OutputMessage {
        case searchBookList(keyword:String, result: APISearchDataModel)
        case pageBookList(result: APISearchDataModel)
    }
}

extension ViewController: ViewContollerInteractable {
    
    typealias VI = ViewInteractor
    
    typealias IM = ViewInteractionMessage
    enum ViewInteractionMessage: InteractionMessage {
        case reloadBookList(tableView: UITableView,
                            datasource: TableViewDelegate.BookListData,
                            vc: ViewController)
    }
    
    func convertToInteraction(from outputMessage: ViewOutputMessage) -> ViewInteractionMessage {
        let datasource: TableViewDelegate.BookListData
        switch outputMessage {
        case .searchBookList(let keyword, let result):
            datasource = TableViewDelegate.BookListData(keyword: keyword,
                                                        latestResponse: result,
                                                        itemList: result.items)
        case .pageBookList(let result):
            let keyword = self.datasource?.keyword ?? ""
            let exList = self.datasource?.itemList ?? []
            datasource = TableViewDelegate.BookListData(keyword: keyword,
                                                        latestResponse: result,
                                                        itemList: exList + result.items)
        }
        isPrefetching = false
        self.datasource = datasource
        return .reloadBookList(tableView: tableView, datasource: datasource, vc: self)
    }
}

extension ViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let text = textField.text, text.isEmpty == false {
            loadBookList(with: text)
        } else {
            print("Empty text")
        }
        textField.resignFirstResponder()
        return true
    }
}

extension ViewController: UITableViewDataSourcePrefetching {
    
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        guard let datasource, isPrefetching == false else { return }
        let indexForPrefetching = indexPaths.first?.row ?? 0
        guard datasource.latestResponse.totalItems >= indexForPrefetching + 1,
              datasource.itemList.count < indexForPrefetching else { return }
        
        isPrefetching = true
        loadBookList(with: datasource.keyword)
    }
}

extension ViewController {
    func selectBookCell(at indexPath: IndexPath) {
        guard let datasource = datasource, datasource.itemList.count > indexPath.row else { return }
        performSegue(withIdentifier: SegueIdentifier.showBookDetail.rawValue,
                     sender: datasource.itemList[indexPath.row])
    }
}
