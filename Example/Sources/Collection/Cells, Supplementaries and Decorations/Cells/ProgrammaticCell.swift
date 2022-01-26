//
//  ProgrammaticCell.swift
//  UtiliKit
//
//  Copyright © 2017 Bottle Rocket Studios. All rights reserved.
//

import UIKit
import UtiliKit

class ProgrammaticCell: UICollectionViewCell { }

// MARK: - Configurable
extension ProgrammaticCell: Configurable {

    struct Configuration {
        let backgroundColor: UIColor
    }

    func configure(with element: Configuration) {
        backgroundColor = element.backgroundColor
    }
}
