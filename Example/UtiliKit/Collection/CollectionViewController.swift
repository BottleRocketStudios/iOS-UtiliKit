//
//  CollectionViewController.swift
//  UtiliKit
//
//  Copyright © 2017 Bottle Rocket Studios. All rights reserved.
//

import UIKit

enum DataType {
    case programmatic
    case storyboard
    case nib
}

/**
 Example view controller showcasing how to programmatically register and dequeue collection view cells and supplementary views.
 
 Check out ProgrammaticViewsCollectionController to see how the cells are registered in a type-safe fashion.
*/
class CollectionViewController: UIViewController {
    @IBOutlet private var collectionView: UICollectionView!
    private var collectionController: ProgrammaticViewsCollectionController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure(for: .programmatic)
    }
    
    func configure(for dataType: DataType) {
        switch dataType {
        case .programmatic:
            collectionController = ProgrammaticViewsCollectionController(with: collectionView)
        case .storyboard: break
        case .nib: break
        }
    }
}

