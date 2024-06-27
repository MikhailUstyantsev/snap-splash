//
//  PicGridCell.swift
//  SnapSplash
//
//  Created by Mikhail Ustyantsev on 27.06.2024.
//

import UIKit
import Kingfisher

class PicGridCell: UICollectionViewCell {
    
    var picItem: Result? {
        didSet {
            guard let imageUrl = URL(string: picItem?.urls?.small?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")  else {
                return
            }
            photoContainer.kf.setImage(with: imageUrl)
        }
    }
    let photoContainer = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        constraintViews()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        fatalError("Interface Builder is not supported!")
    }
    
    
    private func setupViews() {
        photoContainer.clipsToBounds = true
        photoContainer.contentMode = .scaleAspectFill
    }
    
    
    private func constraintViews() {
        contentView.addView(photoContainer)
        photoContainer.pinToSuperviewEdges()
    }

    
}
