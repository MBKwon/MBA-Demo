//
//  ViewController.swift
//  MBA-book-browser
//
//  Created by Moonbeom KWON on 2/24/25.
//

import MBAkit_image_loader
import UIKit

class ViewController: UIViewController {
    
    enum SegueIdentifier: String {
        case showBookDetail
    }
    
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var loadingBackgroundView: UIView!
    @IBOutlet private weak var loadingIndicatorView: UIActivityIndicatorView!
    
    private lazy var apiLibrary: APIOpenLibrary = .init()
    private var selectedBook: APIBookDataModel?
    private var datasource: BookListData?
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
    
    struct BookListData {
        let keyword: String
        let latestResponse: APISearchDataModel
        let itemList: [APIBookDataModel]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView.isPrefetchingEnabled = true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == SegueIdentifier.showBookDetail.rawValue,
           let detailVC = segue.destination as? BookDetailViewController,
           let targetBook = selectedBook {
            detailVC.selectedBook = targetBook
            selectedBook = nil
        }
    }
    
    private func loadBookList(with keyword: String) async -> Result<APISearchDataModel, Error> {
        let searchIndex = datasource?.itemList.count
        let result = await apiLibrary.request(with: .search(text: keyword, startIndex: searchIndex),
                                              decoder: APISearchDataModel.self)
        
        switch result {
        case .success(let searchDataModel):
            if let originDatasource = datasource {
                if originDatasource.keyword == keyword {
                    let newItemList = originDatasource.itemList + searchDataModel.items
                    datasource = BookListData(keyword: keyword,
                                              latestResponse: searchDataModel,
                                              itemList: newItemList)
                } else {
                    datasource = BookListData(keyword: keyword,
                                              latestResponse: searchDataModel,
                                              itemList: searchDataModel.items)
                }
            } else {
                datasource = BookListData(keyword: keyword,
                                          latestResponse: searchDataModel,
                                          itemList: searchDataModel.items)
            }
        case .failure(let error):
            print(error)
        }
        
        return result
    }
    
    private func reloadTableView(with result: Result<APISearchDataModel, Error>) {
        switch result {
        case .success:
            tableView.reloadData()
        case.failure(let error):
            print(error.localizedDescription)
        }
        
        isPrefetching = false
    }
}

extension ViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let text = textField.text, text.isEmpty == false {
            Task {
                let result = await loadBookList(with: text)
                reloadTableView(with: result)
            }
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
        Task {
            let result = await loadBookList(with: datasource.keyword)
            reloadTableView(with: result)
        }
    }
}

extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let datasource = datasource {
            return datasource.latestResponse.totalItems
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "BookImageCell") as? BookImageCell else {
            return UITableViewCell()
        }
        
        cell.selectionStyle = .none
        
        if let datasource = datasource, datasource.itemList.count > indexPath.row {
            let bookDataModel = datasource.itemList[indexPath.row]
            cell.bookTitleLabel.text = bookDataModel.volumeInfo.title
            cell.bookSubtitleLabel.text = bookDataModel.volumeInfo.subtitle
            cell.saleStatusLabel.text = bookDataModel.saleInfo.saleability
            
            
            if let thumbnailURL = bookDataModel.volumeInfo.imageLinks?.smallThumbnail,
               let imageURL = URL(string: thumbnailURL) {
                
                cell.photoImageURL = thumbnailURL
                Task {
                    switch await ImageLoader.loadImage(with: imageURL) {
                    case .success(let imageData):
                        guard imageData.url == cell.photoImageURL else { return }
                        DispatchQueue.main.async {
                            cell.photoImageView.image = UIImage(data: imageData.data)
                        }
                        
                    case .failure(let error):
                        print("ImageLoad Error: \(error)")
                    }
                }
            } else {
                cell.photoImageView.image = nil
            }
        } else {
            cell.photoImageView.image = nil
        }
        return cell
    }
}

extension ViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let datasource = datasource, datasource.itemList.count > indexPath.row {
            selectedBook = datasource.itemList[indexPath.row]
            performSegue(withIdentifier: SegueIdentifier.showBookDetail.rawValue,
                         sender: nil)
        } else {
            selectedBook = nil
        }
    }
}
