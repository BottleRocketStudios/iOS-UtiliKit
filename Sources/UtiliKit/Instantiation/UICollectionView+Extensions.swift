//
//  UICollectionView+Extensions.swift
//  UtiliKit
//
//  Copyright © 2017 Bottle Rocket Studios. All rights reserved.
//

import UIKit

public extension UICollectionView {
    
    /// Enum defining UICollectionElementKind
    public enum SupplementaryElementKind {
        case sectionHeader
        case sectionFooter
        
        /// Either UICollectionElementKindSectionHeader or UICollectionElementKindSectionFooter
        var type: String {
            switch self {
            case .sectionHeader: return UICollectionElementKindSectionHeader
            case .sectionFooter: return UICollectionElementKindSectionFooter
            }
        }
    }
    
    //MARK: Registration
    /**
     Registers a cell for use with a collection view.
    
     - Parameter type: The type of the cell being registered.
    */
    public func register<T: UICollectionViewCell>(_ type: T.Type) {
        register(type, forCellWithReuseIdentifier: T.reuseIdentifier)
    }
    
    /**
     Registers a nib for use with a collection view.
    
     - Parameter type: The class of the nib being registered. This should match its reuse identifier.
    */
    public func registerNib<T: UICollectionViewCell>(for type: T.Type) {
        register(UINib(nibName: T.nibName, bundle: Bundle(for: type)), forCellWithReuseIdentifier: T.reuseIdentifier)
    }
    
    /**
     Registers a view as a supplementary view for a collection view.
    
     - Parameter type: The type of the view being registered.
     */
    public func registerHeaderFooter<T: UICollectionReusableView>(_ type: T.Type) {
        register(type, forSupplementaryViewOfKind: .sectionHeader)
        register(type, forSupplementaryViewOfKind: .sectionFooter)
    }
    
    /**
     Registers a view as a header or footer for a collection view.
    
     - Parameter type: The type of the view being registered.
     - Parameter kind: The kind of supplementary view to make.
    */
    public func register<T: UICollectionReusableView>(_ type: T.Type, forSupplementaryViewOfKind kind: SupplementaryElementKind) {
        register(type, forSupplementaryViewOfKind: kind.type, withReuseIdentifier: T.reuseIdentifier)
    }
    
    /**
     Registers a nib as a supplementary view for a collection view.
    
     - Parameter type: The type of the view being registered.
    */
    public func registerNib<T: UICollectionReusableView>(forHeaderFooterView type: T.Type) {
        registerNib(forHeaderFooterView: type, forSupplementaryViewOfKind: .sectionHeader)
        registerNib(forHeaderFooterView: type, forSupplementaryViewOfKind: .sectionFooter)
    }
    
    /**
     Registers a nib as a header or footer for a collection view.
    
     - Parameter type: The type of the view being registered.
     - Parameter kind: The kind of supplementary view to make.
    */
    public func registerNib<T: UICollectionReusableView>(forHeaderFooterView type: T.Type, forSupplementaryViewOfKind kind: SupplementaryElementKind) {
        register(UINib(nibName: T.nibName, bundle: Bundle(for: type)), forSupplementaryViewOfKind: kind.type, withReuseIdentifier: T.reuseIdentifier)
    }
    
    //MARK: Dequeue
    /**
     Returns a reusable collection view cell of type T.
    
     - Parameter indexPath: The index path of the cell.
     - Returns: A collection view cell of type T.
    */
    public func dequeueReusableCell<T: UICollectionViewCell>(for indexPath: IndexPath) -> T {
        guard let reusableCell = dequeueReusableCell(withReuseIdentifier: T.reuseIdentifier, for: indexPath) as? T else {
            fatalError("Could not dequeue a reusable cell of type \(T.self) with identifier \(T.reuseIdentifier) for use in \(self)")
        }
        
        return reusableCell
    }
    
    /**
     Returns a reusable supplementary view of type T.
    
     - Parameter kind: The kind of supplementary view to make.
     - Parameter indexPath: The index path of the cell.
     - Returns: A collection view cell of type T.
    */
    public func dequeueReusableSupplementaryView<T: UICollectionReusableView>(of kind: SupplementaryElementKind, for indexPath: IndexPath) -> T {
        guard let reusableView = dequeueReusableSupplementaryView(ofKind: kind.type, withReuseIdentifier: T.reuseIdentifier, for: indexPath) as? T else {
            fatalError("Could not dequeue a reusable supplementary view of type \(T.self) with identifier \(T.reuseIdentifier) for use in \(self)")
        }
        
        return reusableView
    }
}
