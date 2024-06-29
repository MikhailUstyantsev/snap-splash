//
//  SSAvatarImageView.swift
//  SnapSplash
//
//  Created by Mikhail Ustyantsev on 29.06.2024.
//

import UIKit

class SSAvatarImageView: UIImageView {

    let placeholderImage = Constants.Image.placeholder
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func configure() {
        contentMode = .scaleAspectFill
        layer.cornerRadius = 10
        clipsToBounds = true
        image = placeholderImage
    }
}
