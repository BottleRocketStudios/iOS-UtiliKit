//
//  UICollectionView+Extensions.swift
//  UtiliKit
//
//  Copyright © 2017 Bottle Rocket Studios. All rights reserved.
//

import UIKit

public extension UICollectionView {

    @available(*, deprecated, message: "Prefer `ElementKind` instead.")
    typealias SupplementaryElementKind = ElementKind
    
    /// Struct defining UICollection.ElementKind
    struct ElementKind: RawRepresentable, Equatable {
        public let rawValue: String

        public init(rawValue: String) {
            self.rawValue = rawValue
        }

        @available(*, deprecated, message: "Prefer `rawValue` instead.")
        public var type: String {
            return rawValue
        }

        public static func ~=(lhs: ElementKind, rhs: ElementKind) -> Bool {
            return lhs.rawValue ~= rhs.rawValue
        }

        // MARK: - Preset
        public static let sectionHeader = ElementKind(rawValue: UICollectionView.elementKindSectionHeader)
        public static let sectionFooter = ElementKind(rawValue: UICollectionView.elementKindSectionFooter)
    }
    
    //MARK: Registration

    /// Registers a cell for use with a collection view.
    /// - Parameter type: The type of the cell being registered.
    func register<T: UICollectionViewCell>(_ type: T.Type) {
        register(type, forCellWithReuseIdentifier: T.reuseIdentifier)
    }

    /// Registers a nib for use with a collection view.
    /// - Parameter type: The class of the nib being registered. This should match its reuse identifier.
    func registerNib<T: UICollectionViewCell>(for type: T.Type) {
        register(UINib(nibName: T.nibName, bundle: Bundle(for: type)), forCellWithReuseIdentifier: T.reuseIdentifier)
    }

    /// Registers a view as a supplementary view for a collection view.
    /// - Parameter type: The type of the view being registered.
    @available(*, deprecated, message: "Prefer `register(_:forSupplementaryViewOfKind:) instead.")
    func registerHeaderFooter<T: UICollectionReusableView>(_ type: T.Type) {
        register(type, forSupplementaryViewOfKind: .sectionHeader)
        register(type, forSupplementaryViewOfKind: .sectionFooter)
    }

    /// Registers a nib as a supplementary view for a collection view.
    /// - Parameter type: The type of the view being registered.
    @available(*, deprecated, message: "Prefer `registerNib(_:forSupplementaryViewOfKind:) instead.")
    func registerNib<T: UICollectionReusableView>(forHeaderFooterView type: T.Type) {
        registerNib(forSupplementaryView: type, of: .sectionHeader)
        registerNib(forSupplementaryView: type, of: .sectionFooter)
    }

    /// Registers a view as a supplementary view for a collection view.
    /// - Parameter type: The type of the view being registered.
    /// - Parameter kind: The `ElementKind` of supplementary view to register as.
    func register<T: UICollectionReusableView>(_ type: T.Type, forSupplementaryViewOfKind kind: ElementKind) {
        register(type, forSupplementaryViewOfKind: kind.rawValue, withReuseIdentifier: T.reuseIdentifier)
    }

    /// Registers a nib as a header or footer for a collection view.
    /// - Parameter type: The type of the view being registered.
    /// - Parameter kind: The `ElementKind` of supplementary view to register as.
    func registerNib<T: UICollectionReusableView>(forSupplementaryView type: T.Type, of kind: ElementKind) {
        register(UINib(nibName: T.nibName, bundle: Bundle(for: type)), forSupplementaryViewOfKind: kind.rawValue, withReuseIdentifier: T.reuseIdentifier)
    }


    //MARK: Dequeue

    /// Returns a reusable collection view cell of type T.
    /// - Parameter indexPath: The index path of the cell.
    /// - Returns: A collection view cell of type T.
    func dequeueReusableCell<T: UICollectionViewCell>(for indexPath: IndexPath) -> T {
        guard let reusableCell = dequeueReusableCell(withReuseIdentifier: T.reuseIdentifier, for: indexPath) as? T else {
            fatalError("Could not dequeue a reusable cell of type \(T.self) with identifier \(T.reuseIdentifier) for use in \(self)")
        }
        
        return reusableCell
    }

    /// Returns a reusable collection view cell of type T.
    /// - Parameter indexPath: The index path of the cell.
    /// - Parameter element: An object used to configure the newly dequeued cell.
    /// - Returns: A collection view cell of type T configured with `element`.
    func dequeueReusableCell<T: UICollectionViewCell & Configurable>(for indexPath: IndexPath, configuredWith element: T.ConfiguringType) -> T {
        let reusableCell: T = dequeueReusableCell(for: indexPath)
        reusableCell.configure(with: element)
        
        return reusableCell
    }

    /// Returns a reusable supplementary view of type T.
    /// - Parameter kind: The kind of supplementary view to make.
    /// - Parameter indexPath: The index path of the cell.
    /// - Returns: A collection view cell of type T.
    func dequeueReusableSupplementaryView<T: UICollectionReusableView>(of kind: ElementKind, for indexPath: IndexPath) -> T {
        guard let reusableView = dequeueReusableSupplementaryView(ofKind: kind.rawValue, withReuseIdentifier: T.reuseIdentifier, for: indexPath) as? T else {
            fatalError("Could not dequeue a reusable supplementary view of type \(T.self) with identifier \(T.reuseIdentifier) for use in \(self)")
        }
        
        return reusableView
    }

    /// Returns a reusable supplementary view of type T.
    /// - Parameter kind: The kind of supplementary view to make.
    /// - Parameter indexPath: The index path of the cell.
    /// - Parameter element: An object used to configure the newly dequeued cell.
    /// - Returns: A collection reusable view of type T configured with `element`.
    func dequeueReusableSupplementaryView<T: UICollectionReusableView & Configurable>(of kind: ElementKind, for indexPath: IndexPath, configuredWith element: T.ConfiguringType) -> T {
        let reusableView: T = dequeueReusableSupplementaryView(of: kind, for: indexPath)
        reusableView.configure(with: element)
        
        return reusableView
    }
}

public extension UICollectionViewLayout {

    /// Registers a decoration view for use with a collection view layout.
    /// - Parameter type: The type of the decoration view being registered.
    func register<T: UICollectionReusableView>(_ type: T.Type) {
        register(type, forDecorationViewOfKind: T.reuseIdentifier)
    }

    /// Registers a nib for use as a decoration view with a collection view layout.
    /// - Parameter type: The class of the nib being registered. This should match its reuse identifier.
    func registerNib<T: UICollectionReusableView>(forDecorationView type: T.Type) {
        register(UINib(nibName: T.nibName, bundle: Bundle(for: type)), forDecorationViewOfKind: T.reuseIdentifier)
    }
}

@available(iOS 13.0, *)
public extension NSCollectionLayoutDecorationItem {

    /// Creates a section background with an `ElementKind` instance to identify the kind of decoration
    class func background<T: UICollectionReusableView>(forDecorationView type: T.Type) -> NSCollectionLayoutDecorationItem {
        return .background(elementKind: T.reuseIdentifier)
    }
}

@available(iOS 13.0, *)
public extension NSCollectionLayoutBoundarySupplementaryItem {

    /// Creates a boundary supplementary item of the specified size, with an `ElementKind` to identify the element kind and an alignment relative to a section or layout.
    convenience init(layoutSize: NSCollectionLayoutSize, elementKind: UICollectionView.ElementKind, alignment: NSRectAlignment) {
        self.init(layoutSize: layoutSize, elementKind: elementKind.rawValue, alignment: alignment)
    }

    /// Creates a boundary supplementary item of the specified size, with an `ElementKind` to identify the element kind and an alignment relative to a section or layout at an absolute offset.
    convenience init(layoutSize: NSCollectionLayoutSize, elementKind: UICollectionView.ElementKind, alignment: NSRectAlignment, absoluteOffset: CGPoint) {
        self.init(layoutSize: layoutSize, elementKind: elementKind.rawValue, alignment: alignment, absoluteOffset: absoluteOffset)
    }
}

@available(iOS 13.0, *)
public extension NSCollectionLayoutSupplementaryItem {

    /// Creates a supplementary item of the specified size, with an `ElementKind` to identify the element kind and an anchor relative to a container.
    convenience init(layoutSize: NSCollectionLayoutSize, elementKind: UICollectionView.ElementKind, containerAnchor: NSCollectionLayoutAnchor) {
        self.init(layoutSize: layoutSize, elementKind: elementKind.rawValue, containerAnchor: containerAnchor)
    }

    /// Creates a supplementary item of the specified size, with an `ElementKind` to identify the element kind, an anchor relative to a container, and an anchor relative to an item.
    convenience init(layoutSize: NSCollectionLayoutSize, elementKind: UICollectionView.ElementKind, containerAnchor: NSCollectionLayoutAnchor, itemAnchor: NSCollectionLayoutAnchor) {
        self.init(layoutSize: layoutSize, elementKind: elementKind.rawValue, containerAnchor: containerAnchor, itemAnchor: itemAnchor)
    }
}
