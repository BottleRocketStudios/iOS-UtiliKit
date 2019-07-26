//
//  UICollectionView+Extensions.swift
//  UtiliKit
//
//  Copyright © 2017 Bottle Rocket Studios. All rights reserved.
//

import UIKit

public extension UICollectionView {
    
    /// Enum defining UICollectionElementKind
    enum SupplementaryElementKind {
        case sectionHeader
        case sectionFooter
        
        /// Attempt to create a `UICollectionView.SupplementaryElementKind` from the given string.
        ///
        /// - Parameter kind: The type of supplementary view to be instantiated or dequeued.
        public init?(kind: String) {
            let headerKind: String = UICollectionView.elementKindSectionHeader
            let footerKind: String = UICollectionView.elementKindSectionFooter

            if kind == headerKind {
                self = .sectionHeader
            } else if kind == footerKind {
                self = .sectionFooter
            } else {
                return nil
            }
        }
    
        /// Either UICollectionElementKindSectionHeader or UICollectionElementKindSectionFooter
        public var type: String {
            switch self {
            case .sectionHeader: return UICollectionView.elementKindSectionHeader
            case .sectionFooter: return UICollectionView.elementKindSectionFooter
            }
        }
    }
    
    //MARK: Registration
    /**
     Registers a cell for use with a collection view.
    
     - Parameter type: The type of the cell being registered.
    */
    func register<T: UICollectionViewCell>(_ type: T.Type) {
        register(type, forCellWithReuseIdentifier: T.reuseIdentifier)
    }
    
    /**
     Registers a nib for use with a collection view.
    
     - Parameter type: The class of the nib being registered. This should match its reuse identifier.
    */
    func registerNib<T: UICollectionViewCell>(for type: T.Type) {
        register(UINib(nibName: T.nibName, bundle: Bundle(for: type)), forCellWithReuseIdentifier: T.reuseIdentifier)
    }
    
    /**
     Registers a view as a supplementary view for a collection view.
    
     - Parameter type: The type of the view being registered.
     */
    func registerHeaderFooter<T: UICollectionReusableView>(_ type: T.Type) {
        register(type, forSupplementaryViewOfKind: .sectionHeader)
        register(type, forSupplementaryViewOfKind: .sectionFooter)
    }
    
    /**
     Registers a view as a header or footer for a collection view.
    
     - Parameter type: The type of the view being registered.
     - Parameter kind: The kind of supplementary view to make.
    */
    func register<T: UICollectionReusableView>(_ type: T.Type, forSupplementaryViewOfKind kind: SupplementaryElementKind) {
        register(type, forSupplementaryViewOfKind: kind.type, withReuseIdentifier: T.reuseIdentifier)
    }
    
    /**
     Registers a nib as a supplementary view for a collection view.
    
     - Parameter type: The type of the view being registered.
    */
    func registerNib<T: UICollectionReusableView>(forHeaderFooterView type: T.Type) {
        registerNib(forHeaderFooterView: type, forSupplementaryViewOfKind: .sectionHeader)
        registerNib(forHeaderFooterView: type, forSupplementaryViewOfKind: .sectionFooter)
    }
    
    /**
     Registers a nib as a header or footer for a collection view.
    
     - Parameter type: The type of the view being registered.
     - Parameter kind: The kind of supplementary view to make.
    */
    func registerNib<T: UICollectionReusableView>(forHeaderFooterView type: T.Type, forSupplementaryViewOfKind kind: SupplementaryElementKind) {
        register(UINib(nibName: T.nibName, bundle: Bundle(for: type)), forSupplementaryViewOfKind: kind.type, withReuseIdentifier: T.reuseIdentifier)
    }
    
    //MARK: Dequeue
    /**
     Returns a reusable collection view cell of type T.
    
     - Parameter indexPath: The index path of the cell.
     - Returns: A collection view cell of type T.
    */
    func dequeueReusableCell<T: UICollectionViewCell>(for indexPath: IndexPath) -> T {
        guard let reusableCell = dequeueReusableCell(withReuseIdentifier: T.reuseIdentifier, for: indexPath) as? T else {
            fatalError("Could not dequeue a reusable cell of type \(T.self) with identifier \(T.reuseIdentifier) for use in \(self)")
        }
        
        return reusableCell
    }
    
    /**
     Returns a reusable collection view cell of type T.
     
     - Parameter indexPath: The index path of the cell.
     - Parameter element: An object used to configure the newly dequeued cell.
     - Returns: A collection view cell of type T configured with `element`.
     */
    func dequeueReusableCell<T: UICollectionViewCell & Configurable>(for indexPath: IndexPath, configuredWith element: T.ConfiguringType) -> T {
        let reusableCell: T = dequeueReusableCell(for: indexPath)
        reusableCell.configure(with: element)
        
        return reusableCell
    }
    
    /**
     Returns a reusable supplementary view of type T.
    
     - Parameter kind: The kind of supplementary view to make.
     - Parameter indexPath: The index path of the cell.
     - Returns: A collection view cell of type T.
    */
    func dequeueReusableSupplementaryView<T: UICollectionReusableView>(of kind: SupplementaryElementKind, for indexPath: IndexPath) -> T {
        guard let reusableView = dequeueReusableSupplementaryView(ofKind: kind.type, withReuseIdentifier: T.reuseIdentifier, for: indexPath) as? T else {
            fatalError("Could not dequeue a reusable supplementary view of type \(T.self) with identifier \(T.reuseIdentifier) for use in \(self)")
        }
        
        return reusableView
    }
    
    /**
     Returns a reusable supplementary view of type T.
     
     - Parameter kind: The kind of supplementary view to make.
     - Parameter indexPath: The index path of the cell.
     - Parameter element: An object used to configure the newly dequeued cell.
     - Returns: A collection reusable view of type T configured with `element`.
     */
    func dequeueReusableSupplementaryView<T: UICollectionReusableView & Configurable>(of kind: SupplementaryElementKind, for indexPath: IndexPath, configuredWith element: T.ConfiguringType) -> T {
        let reusableView: T = dequeueReusableSupplementaryView(of: kind, for: indexPath)
        reusableView.configure(with: element)
        
        return reusableView
    }
}
