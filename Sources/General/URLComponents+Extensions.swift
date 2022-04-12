//
//  URLComponents+Extensions.swift
//  UtiliKit-iOS
//
//  Created by Nathan Chiu on 9/26/21.
//  Copyright © 2021 Bottle Rocket Studios. All rights reserved.
//

import Foundation

public extension URLComponents {

    /// Adds a `URLQueryItem` to the `queryItems`. `queryItems` will be initialized if it wasn't already. Any existing `URLQueryItem` in `queryItems` with the same `name` will be replaced.
    /// - Parameter newQueryItem: The `URLQueryItem` to add.
    mutating func addQueryItem(_ newQueryItem: URLQueryItem) {
        if queryItems == nil { queryItems = .init() }
        if let existingIndex = queryItems?.firstIndex(where: { $0.name == newQueryItem.name }) {
            queryItems?[existingIndex] = newQueryItem
        } else {
            queryItems?.append(newQueryItem)
        }
    }

    /// Adds an array of `URLQueryItem` to the `queryItems`. `queryItems` will be initialized if it wasn't already. Any existing `URLQueryItem` in `queryItems` with the same `name` as an item in `newQueryItems` will be replaced.
    /// - Parameter newQueryItems: The array of `URLQueryItem` to add.
    mutating func addQueryItems(_ newQueryItems: [URLQueryItem]) {
        newQueryItems.forEach { addQueryItem($0) }
    }
}
