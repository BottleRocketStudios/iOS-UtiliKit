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

    struct Configuration {
        let backgroundColor: UIColor
    }

    func configure(with element: Configuration) {
        backgroundColor = element.backgroundColor
    }
}
