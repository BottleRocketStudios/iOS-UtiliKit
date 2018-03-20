//
//  ProgrammaticCell.swift
//  UtiliKit
//
//  Copyright © 2017 Bottle Rocket Studios. All rights reserved.
//

import UIKit

/**
 A simple collection view cell used in the example showcasing how to programmatically register and dequeue collection view cells.
 
 Check out ProgrammaticViewsCollectionController to see how the cells are registered in a type-safe fashion.
*/
class ProgrammaticCell: UICollectionViewCell {
    override func layoutSubviews() {
        super.layoutSubviews()
        
        backgroundColor = .purple
    }
}
