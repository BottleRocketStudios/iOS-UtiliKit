//
//  UITableView+Extensions.swift
//  UtiliKit
//
//  Copyright © 2017 Bottle Rocket Studios. All rights reserved.
//

import UIKit

public extension UITableView {
    
    //MARK: Registration
    /**
     Registers a cell for use with a table view.
    
     - Parameter type: The type of the cell being registered.
    */
    public func register<T: UITableViewCell>(type: T.Type) {
        register(type, forCellReuseIdentifier: T.reuseIdentifier)
    }
    
    /**
     Registers a nib for use with a table view.
    
     - Parameter type: The class of the nib being registered. This should match its reuse identifier.
    */
    public func registerNib<T: UITableViewCell>(for type: T.Type) {
        register(UINib(nibName: T.nibName, bundle: Bundle(for: type)), forCellReuseIdentifier: T.reuseIdentifier)
    }
    
    /**
     Registers a view as a headerFooter for a table view.
    
     - Parameter type: The type of the class being registered.
    */
    public func registerHeaderFooter<T: UITableViewHeaderFooterView>(type: T.Type) {
        register(type, forHeaderFooterViewReuseIdentifier: T.reuseIdentifier)
    }
    
    /**
     Registers a nib as a headerFooter for a table view.
    
     - Parameter type: The class of the nib being registered. This should match its reuse identifier.
    */
    public func registerNib<T: UITableViewHeaderFooterView>(forHeaderFooterView type: T.Type) {
        register(UINib(nibName: T.nibName, bundle: Bundle(for: type)), forHeaderFooterViewReuseIdentifier: T.reuseIdentifier)
    }
    
    //MARK: Dequeue
    /**
     Returns a reusable table view cell of type T.
    
     - Parameter indexPath: The index path of the cell.
     - Returns: A table view cell of type T.
    */
    public func dequeueReusableCell<T: UITableViewCell>(for indexPath: IndexPath) -> T  {
        guard let reusableCell = dequeueReusableCell(withIdentifier: T.reuseIdentifier, for: indexPath) as? T else {
            fatalError("Could not dequeue a reusable cell of type \(T.self) with identifier \(T.reuseIdentifier) for use in \(self)")
        }
        
        return reusableCell
    }
    
    /**
     Returns a reusable headerFooter view of type T.
    
     - Returns: A headerFooter view of type T.
    */
    public func dequeueReusableHeaderFooterView<T: UITableViewHeaderFooterView>() -> T {
        guard let reusableView = dequeueReusableHeaderFooterView(withIdentifier: T.reuseIdentifier) as? T else {
            fatalError("Could not dequeue a reusable view of type \(T.self) with identifier \(T.reuseIdentifier) for use in \(self)")
        }
        
        return reusableView
    }
}
