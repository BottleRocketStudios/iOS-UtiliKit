//
//  ProgrammaticHeaderFooterView.swift
//  UtiliKit
//
//  Copyright © 2017 Bottle Rocket Studios. All rights reserved.
//

import UIKit

/// Example programmatic UICollectionReusableView
class ProgrammaticHeaderFooterView: UICollectionReusableView {
    private var backgroundView = UIView()
    private var label = UILabel()
    var kind: UICollectionView.SupplementaryElementKind = .sectionHeader
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        commonInit()
    }
    
    private func commonInit() {
        backgroundView.frame = bounds
        addSubview(backgroundView)
        addSubview(label)
        label.textAlignment = .center
        label.frame = bounds
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        switch kind {
        case .sectionHeader:
            label.text = "Header"
            backgroundView.backgroundColor = .green
        case .sectionFooter:
            label.text = "Footer"
            backgroundView.backgroundColor = .blue
        }
    }
}
