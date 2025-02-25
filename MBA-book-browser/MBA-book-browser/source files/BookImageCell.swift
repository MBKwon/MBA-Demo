//
//  BookImageCell.swift
//  MBA-book-browser
//
//  Created by Moonbeom KWON on 2/24/25.
//

import UIKit

class BookImageCell: UITableViewCell {
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var bookTitleLabel: UILabel!
    @IBOutlet weak var bookSubtitleLabel: UILabel!
    @IBOutlet weak var saleStatusLabel: UILabel!
    
    var photoImageURL: String?
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        photoImageView.image = nil
        bookTitleLabel.text = nil
        bookSubtitleLabel.text = nil
        saleStatusLabel.text = nil
    }
}
