//
//  URLComponents+Extensions.swift
//  UtiliKit-iOSTests
//
//  Created by Nathan Chiu on 9/26/21.
//  Copyright © 2021 Bottle Rocket Studios. All rights reserved.
//

import Foundation

public extension URLComponents {

    mutating func addQueryItem(_ newQueryItem: URLQueryItem) {
        if queryItems == nil { queryItems = .init() }
        if let existingIndex = queryItems?.firstIndex(where: { $0.name == newQueryItem.name }) {
            queryItems?[existingIndex] = newQueryItem
        } else {
            queryItems?.append(newQueryItem)
        }
    }

    mutating func addQueryItems(_ newQueryItems: [URLQueryItem]) {
        newQueryItems.forEach { addQueryItem($0) }
    }
}
