//
//  NibDrivenCell.swift
//  UtiliKit
//
//  Copyright © 2021 Bottle Rocket Studios. All rights reserved.
//

import UIKit
import UtiliKit

class NibDrivenCell: UICollectionViewCell { }

// MARK: - Configurable
extension NibDrivenCell: Configurable {

    func configure(with color: UIColor) {
        backgroundColor = color
    }
}
