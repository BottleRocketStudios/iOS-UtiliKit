//
//  TableViewController.swift
//  UtiliKit
//
//  Copyright © 2017 Bottle Rocket Studios. All rights reserved.
//

import UIKit

/**
 Example view controller showcasing how to programmatically register and dequeue table view cells, headers, and footers.
 
 Check out XibViewsTableController to see how the views are registered and dequeued in a type-safe fashion.
 */
class TableViewController: UIViewController {
    @IBOutlet private var tableView: UITableView!
    private var tableController: XibViewsTableController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure(for: .nib)
    }
    
    func configure(for dataType: DataType) {
        switch dataType {
        case .nib:
            tableController = XibViewsTableController(with: tableView)
        case .storyboard: break
        case .programmatic: break
        }
    }
}
