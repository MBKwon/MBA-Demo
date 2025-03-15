//
//  TableViewDelegate.swift
//  MBA-book-browser
//
//  Created by Moonbeom KWON on 2/26/25.
//

import MBAkit_image_loader
import UIKit

class TableViewDelegate: NSObject {
    struct BookListData {
        let keyword: String
        let latestResponse: APISearchDataModel
        let itemList: [APIBookDataModel]
    }
    
    private let data: BookListData
    private let vc: ViewController
    
    init(with data: BookListData, vc: ViewController) {
        self.data = data
        self.vc = vc
    }
}

extension TableViewDelegate: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.latestResponse.totalItems
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "BookImageCell") as? BookImageCell else {
            return UITableViewCell()
        }
        
        cell.selectionStyle = .none
        
        if data.itemList.count > indexPath.row {
            let bookDataModel = data.itemList[indexPath.row]
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

extension TableViewDelegate: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        vc.selectBookCell(at: indexPath)
    }
}
