//
//  ProgrammaticHeaderFooterView.swift
//  UtiliKit
//
//  Copyright © 2017 Bottle Rocket Studios. All rights reserved.
//

import UIKit
import UtiliKit

class ProgrammaticHeaderFooterView: UICollectionReusableView {

    private var label = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        initializeView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initializeView()
    }
    
    private func initializeView() {
        addSubview(label)
        label.textAlignment = .center

        label.translatesAutoresizingMaskIntoConstraints = false
        label.constrainEdgesToSuperview()
    }
}

// MARK: - Configurable
extension ProgrammaticHeaderFooterView: Configurable {

    struct Configuration {
        let title: String
    }

    func configure(with element: Configuration) {
        label.text = element.title
    }
}
