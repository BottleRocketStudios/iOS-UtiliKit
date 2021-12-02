//
//  NibDrivenHeaderFooterView.swift
//  UtiliKit
//
//  Copyright © 2021 Bottle Rocket Studios. All rights reserved.
//

import UIKit
import UtiliKit

class NibDrivenHeaderFooterView: UICollectionReusableView {

    @IBOutlet private var label: UILabel!
}

// MARK: - Configurable
extension NibDrivenHeaderFooterView: Configurable {

    struct Configuration {
        let title: String
    }

    func configure(with element: Configuration) {
        label.text = element.title
    }
}
