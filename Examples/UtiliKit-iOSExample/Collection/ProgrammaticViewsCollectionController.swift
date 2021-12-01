//
//  ProgrammaticViewsCollectionController.swift
//  UtiliKit
//
//  Copyright © 2017 Bottle Rocket Studios. All rights reserved.
//

import UIKit

/**
 Example collection controller showcasing how to programmatically register and dequeue collection view cells.
 Check out how ProgrammaticCell and ProgrammaticHeaderFooterView are registered with the collection view in the 'init()' method below.
 Then check out the cells are dequeued in the 'collectionView(_:cellForItemAt:)' and 'collectionView(_:viewForSupplementaryElementOfKind:at:)' UICollectionViewDataSource methods below.
*/
class ProgrammaticViewsCollectionController: NSObject {
    private var collectionView: UICollectionView
    let dataA: [Int] = [0, 1, 2]
    let dataB: [Int] = [0, 1, 2]
    let dataC: [Int] = [0, 1, 2]
    var data: [[Int]] = []
	
    init(with collectionView: UICollectionView) {
        self.collectionView = collectionView
        super.init()
        
        data = [dataA, dataB, dataC]
		
		// Register cells and header/footer views programmatically.
		// This can be done as an alternative, or in addition to designing your cells in a storyboard using storyboard prototype cells.
		
		// Notice how the type of the cell or header/footer view is all that's needed to register your class with the collection view.
		// The extension on UICollectionView will automatically use the name of the class to the view from the bundle and register it with the collection view.
        collectionView.register(ProgrammaticCell.self)
        collectionView.register(ProgrammaticHeaderFooterView.self, forSupplementaryViewOfKind: .sectionHeader)
        collectionView.register(ProgrammaticHeaderFooterView.self, forSupplementaryViewOfKind: .sectionFooter)
        
        collectionView.delegate = self
        collectionView.dataSource = self
    }
}

// MARK: - UICollectionViewDataSource
extension ProgrammaticViewsCollectionController: UICollectionViewDataSource {
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data[section].count
    }
    
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return data.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		// Dequeue a "ProgrammaticCell" from the collection view
		// Notice that the desired type of cell that you want to dequeue must be provided.
		// The UICollectionView extension will automatically attempt to dequeue a cell with a reuse identifier that matches the name of the cell's type and then cast it into that type.
        let cell: ProgrammaticCell = collectionView.dequeueReusableCell(for: indexPath)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
		// The same scheme used to dequeue the "ProgrammaticCell" is used to dequeue header and footer views.
		// You need only provide the desired type and SupplementaryElementKind to receive a typed UICollectionReusableView
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            let header: ProgrammaticHeaderFooterView = collectionView.dequeueReusableSupplementaryView(of: .sectionHeader, for: indexPath)
            return header
        default:
            let footer: ProgrammaticHeaderFooterView = collectionView.dequeueReusableSupplementaryView(of: .sectionFooter, for: indexPath)
            footer.kind = .sectionFooter
            return footer
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension ProgrammaticViewsCollectionController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 50)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 25)
    }
}
