//
//  BaseInfoView.swift
//  SnapSplash
//
//  Created by Mikhail Ustyantsev on 29.06.2024.
//

import UIKit

class BaseInfoView: UIView {

    let iconContainer = UIImageView()
    let label = SSBodyLabel(textAlignment: .left)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func configure() {
        backgroundColor = .systemBackground
        iconContainer.contentMode = .scaleAspectFit
        iconContainer.tintColor = .systemPink
        label.numberOfLines = 0
        
        addView(iconContainer)
        addView(label)
        
        NSLayoutConstraint.activate([
            iconContainer.heightAnchor.constraint(equalToConstant: 30),
            iconContainer.widthAnchor.constraint(equalTo:iconContainer.heightAnchor),
            iconContainer.leadingAnchor.constraint(equalTo: leadingAnchor),
            iconContainer.centerYAnchor.constraint(equalTo: label.centerYAnchor),
            
            label.leadingAnchor.constraint(equalTo: iconContainer.trailingAnchor, constant: 16),
            label.topAnchor.constraint(equalTo: topAnchor),
            label.bottomAnchor.constraint(equalTo: bottomAnchor),
            label.trailingAnchor.constraint(equalTo: trailingAnchor),
        ])
    }

    
    //MARK: - Public methods:
    func set(image: UIImage?, message: String) {
        let text = message.components(separatedBy: "T")[0]
        iconContainer.image = image
        label.text = text
    }
}
