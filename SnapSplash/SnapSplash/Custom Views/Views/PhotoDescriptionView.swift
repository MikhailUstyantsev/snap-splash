//
//  PhotoDescriptionView.swift
//  SnapSplash
//
//  Created by Mikhail Ustyantsev on 29.06.2024.
//

import UIKit

class PhotoDescriptionView: UIView {

    let photoAuthorView = BaseInfoView()
    let creationDateView = BaseInfoView()
    let locationView = BaseInfoView()
    let downloadsView = BaseInfoView()
    
    private let stackView = UIStackView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func configure() {
        backgroundColor = .systemBackground
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 6
        
        addView(stackView)
        
        stackView.addArrangedSubview(photoAuthorView)
        stackView.addArrangedSubview(creationDateView)
        stackView.addArrangedSubview(locationView)
        stackView.addArrangedSubview(downloadsView)
        
        stackView.pinToSuperviewEdges()
    }
}
