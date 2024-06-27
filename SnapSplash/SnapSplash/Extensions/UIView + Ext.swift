//
//  UIView + Ext.swift
//  SnapSplash
//
//  Created by Mikhail Ustyantsev on 27.06.2024.
//

import UIKit

extension UIView {
    
    enum Edge {
        case left
        case top
        case right
        case bottom
    }
    
    func pinToSuperviewEdges(_ edges: [Edge] = [.top, .bottom, .left, .right], constant: CGFloat = 0) {
        guard let superview = superview else { return }
        edges.forEach {
            switch $0 {
            case .top: topAnchor.constraint(equalTo: superview.topAnchor, constant: constant).isActive = true
            case .left:
                leadingAnchor.constraint(equalTo: superview.leadingAnchor, constant: constant).isActive = true
            case .right:
                trailingAnchor.constraint(equalTo: superview.trailingAnchor, constant: -constant).isActive = true
            case .bottom:
                bottomAnchor.constraint(equalTo: superview.bottomAnchor, constant: -constant).isActive = true
            }
        }
    }
    
    
    func addView(_ view: UIView) {
        addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
    }
}
