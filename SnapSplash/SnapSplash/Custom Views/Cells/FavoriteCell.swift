//
//  FavoriteCell.swift
//  SnapSplash
//
//  Created by Mikhail Ustyantsev on 29.06.2024.
//

import UIKit
import Kingfisher

class FavoriteCell: UITableViewCell {

    let avatarImageView = SSAvatarImageView(frame: .zero)
    let nameLabel = SSTitleLabel(textAlignment: .left, fontSize: 20)

    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        avatarImageView.image = nil
        nameLabel.text = nil
    }
    
    
    func set(favorite: Photo) {
        guard let imageUrl = URL(string: favorite.urls?.thumb?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")  else {
            return
        }
        avatarImageView.kf.setImage(with: imageUrl)
        nameLabel.text = "\(favorite.user?.name ?? "No author available")"
    }
    
    
    private func configure() {
        addView(avatarImageView)
        addView(nameLabel)
        accessoryType = .disclosureIndicator
        let padding: CGFloat  = 12
        
        NSLayoutConstraint.activate([
            avatarImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            avatarImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
            avatarImageView.heightAnchor.constraint(equalToConstant: 60),
            avatarImageView.widthAnchor.constraint(equalToConstant: 60),
            
            nameLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            nameLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 24),
            nameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding),
            nameLabel.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
}
