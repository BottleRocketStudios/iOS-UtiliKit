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

    func configure(with text: String) {
        label.text = text
    }
}
