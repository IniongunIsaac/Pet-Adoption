//
//  PetPageCollectionViewCell.swift
//  Pet Adoption
//
//  Created by Isaac Iniongun on 12/11/2019.
//  Copyright © 2019 InGroups. All rights reserved.
//

import UIKit
import Entities

class PetPageCollectionViewCell: UICollectionViewCell {
    
    private let parentScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private let parentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var page: Page? {
        didSet {
            guard let pg = page else { return }
            
            let label = UILabel()
            label.text = pg.label
            label.translatesAutoresizingMaskIntoConstraints = false
            parentView.addSubview(label)
            NSLayoutConstraint.activate([
                label.centerXAnchor.constraint(equalTo: parentView.centerXAnchor),
                label.centerYAnchor.constraint(equalTo: parentView.centerYAnchor)
            ])
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setupLayout() {
        addSubview(parentScrollView)
        parentScrollView.addSubview(parentView)
        
        NSLayoutConstraint.activate([
            
            parentScrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            parentScrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            parentScrollView.topAnchor.constraint(equalTo: topAnchor),
            parentScrollView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            parentView.leadingAnchor.constraint(equalTo: parentScrollView.leadingAnchor),
            parentView.trailingAnchor.constraint(equalTo: parentScrollView.trailingAnchor),
            parentView.topAnchor.constraint(equalTo: parentScrollView.topAnchor),
            parentView.bottomAnchor.constraint(equalTo: parentScrollView.bottomAnchor),
            parentView.heightAnchor.constraint(equalTo: heightAnchor),
            parentView.widthAnchor.constraint(equalTo: widthAnchor)
            
        ])
    }
}
