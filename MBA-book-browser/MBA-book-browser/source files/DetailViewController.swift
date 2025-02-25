//
//  DetailViewController.swift
//  MBA-book-browser
//
//  Created by Moonbeom KWON on 2/24/25.
//

import MBAkit_image_loader
import SafariServices
import UIKit

class BookDetailViewController: UIViewController {
    
    @IBOutlet private weak var bookImageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var subtitleLabel: UILabel!
    @IBOutlet private weak var authorLabel: UILabel!
    @IBOutlet private weak var publishDateLabel: UILabel!
    
    @IBOutlet private weak var bookInfoTextView: UITextView!
    @IBOutlet private weak var buyLinkButton: UIButton!
    
    var selectedBook: APIBookDataModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let bookInfo = selectedBook else { return }
        if let imageUrlString = bookInfo.volumeInfo.imageLinks?.thumbnail,
           let imageURL = URL(string: imageUrlString) {
            Task {
                let imageData = try? await ImageLoader.loadImage(with: imageURL).get().data
                if let imageData = imageData {
                    DispatchQueue.main.async {
                        self.bookImageView.image = UIImage(data: imageData)
                    }
                }
            }
        }
        
        titleLabel.text = bookInfo.volumeInfo.title
        subtitleLabel.text = bookInfo.volumeInfo.subtitle
        
        let authors = bookInfo.volumeInfo.authors?.joined(separator: " / ")
        authorLabel.text = authors
        
        let publishDate = [bookInfo.volumeInfo.publishedDate, bookInfo.volumeInfo.publisher]
            .compactMap({ $0 })
            .joined(separator: " / ")
        publishDateLabel.text = publishDate
        bookInfoTextView.text = bookInfo.volumeInfo.description
        
        var priceInfo: [String] = []
        if let listPrice = bookInfo.saleInfo.listPrice {
            priceInfo.append("\(listPrice.currencyCode) \(listPrice.amount)")
        }
        if let retailPrice = bookInfo.saleInfo.retailPrice {
            priceInfo.append("\(retailPrice.currencyCode) \(retailPrice.amount)")
        }
        let priceInfoText: [String] = [
            priceInfo.joined(separator: " -> "),
            bookInfo.saleInfo.saleability
        ]
        
        buyLinkButton.titleLabel?.textAlignment = .center
        buyLinkButton.setTitle("\(priceInfoText.joined(separator: "\n"))", for: .normal)
    }
}

extension BookDetailViewController {
    @IBAction private func touchButLinkButton() {
        guard let linkString = selectedBook?.saleInfo.buyLink,
              let linkURL = URL(string: linkString) else {
            let alert = UIAlertController(title: "No Link", message: nil, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            show(alert, sender: nil)
            return
        }
        
        show(SFSafariViewController(url: linkURL), sender: nil)
    }
}
