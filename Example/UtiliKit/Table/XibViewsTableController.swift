//
//  XibViewsTableController.swift
//  UtiliKit
//
//  Copyright © 2017 Bottle Rocket Studios. All rights reserved.
//

import UIKit

/**
 Example table controller showcasing how to programmatically register and dequeue table view cells.
 Check out how the XibTableViewCell, XibHeaderView, and XibFooterView are registered with the table view in the 'init()' method below.
 Then check out how the views are dequeued in the '(_:, cellForRowAt:),' UITableViewDataSource method and the '(_:, viewForFooterInSection:)' and '(_:, viewForHeaderInSection:)' UITableViewDelegate methods below.
 */
class XibViewsTableController: NSObject {
    private var tableView: UITableView
    let dataA: [Int] = [0, 1, 2]
    let dataB: [Int] = [0, 1, 2]
    let dataC: [Int] = [0, 1, 2]
    var data: [[Int]] = []
    
    init(with tableView: UITableView) {
        self.tableView = tableView
        super.init()
        
        data = [dataA, dataB, dataC]
        
        // Register cells and header/footer views programmatically.
        // This can be done as an alternative, or in addition to designing your cells in a storyboard using storyboard prototype cells.
        
        // Notice how the type of the cell or header/footer view is all that's needed to register your class with the table view.
        // The extension on UITableView will automatically use the name of the class to loading the xib from the bundle and register it with the table view.
        tableView.registerNib(for: XibTableViewCell.self)
        tableView.registerNib(forHeaderFooterView: XibHeaderView.self)
        tableView.registerNib(forHeaderFooterView: XibFooterView.self)
        
        tableView.delegate = self
        tableView.dataSource = self
    }
}

// MARK: - UITableViewDataSource
extension XibViewsTableController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Dequeue a "XibTableViewCell" from the table view
        // Notice that the desired type of cell that you want to dequeue must be provided.
        // The UITableView extension will automatically attempt to dequeue a cell with a reuse identifier that matches the name of the cell's type and then cast it into that type.
        let cell: XibTableViewCell = tableView.dequeueReusableCell(for: indexPath)
        return cell
    }
}

// MARK: - UITableViewDelegate
extension XibViewsTableController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        // The same scheme used to dequeue the "XibTableViewCell" is used to dequeue header and footer views.
        // You need only provide the desired type to receive a typed UITableViewHeaderFooterView
        let footer: XibFooterView = tableView.dequeueReusableHeaderFooterView()
        return footer
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header: XibHeaderView = tableView.dequeueReusableHeaderFooterView()
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 25
    }
}
