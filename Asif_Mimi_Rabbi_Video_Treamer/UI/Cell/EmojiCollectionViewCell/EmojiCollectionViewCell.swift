//
//  EmojiCollectionViewCell.swift
//  Asif_Mimi_Rabbi_Video_Treamer
//
//  Created by Asif Rabbi on 28/8/22.
//

import UIKit

class EmojiCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "EmojiCollectionViewCell"
    
    @IBOutlet weak var emofiImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func reload(imageName: String) {
        emofiImageView.image = UIImage(named: imageName)
    }
}
