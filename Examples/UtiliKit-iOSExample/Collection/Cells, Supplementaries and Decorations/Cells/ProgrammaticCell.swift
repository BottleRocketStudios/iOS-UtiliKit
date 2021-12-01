//
//  ProgrammaticCell.swift
//  UtiliKit
//
//  Copyright © 2017 Bottle Rocket Studios. All rights reserved.
//

import UIKit
import UtiliKit

class ProgrammaticCell: UICollectionViewCell {
    override func layoutSubviews() {
        super.layoutSubviews()
    }
}

// MARK: - Configurable
extension ProgrammaticCell: Configurable {

    func configure(with color: UIColor) {
        backgroundColor = color
    }
}
