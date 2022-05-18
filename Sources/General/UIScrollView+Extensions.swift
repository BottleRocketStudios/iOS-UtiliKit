//
//  UIScrollView+Extensions.swift
//  UtiliKit iOS
//
//  Created by Nathan Chiu on 5/18/22.
//  Copyright © 2022 Bottle Rocket Studios. All rights reserved.
//

import UIKit

// MARK: - Scroll position
extension UIScrollView {

    /// Content offset including `adjustedContentInset`
    var insetAdjustedContentOffset: CGPoint {
        .init(x: contentOffset.x + adjustedContentInset.left,
              y: contentOffset.y + adjustedContentInset.top)
    }

    /// Content size including `adjustedContentInset`
    var insetAdjustedContentSize: CGSize {
        .init(width: contentSize.width + adjustedContentInset.left + adjustedContentInset.right,
              height: contentSize.height + adjustedContentInset.top + adjustedContentInset.bottom)
    }

    /// Percentage the user has scrolled
    var scrollPercentage: (horizontal: CGFloat, vertical: CGFloat) {
        var totalScrollableHeight = insetAdjustedContentSize.height - frame.height
        if insetAdjustedContentSize.height <= frame.height {
            totalScrollableHeight = frame.height
        }
        let verticalPercentage = insetAdjustedContentOffset.y / totalScrollableHeight

        var totalScrollableWidth = insetAdjustedContentSize.width - frame.width
        if insetAdjustedContentSize.width <= frame.width {
            totalScrollableWidth = frame.width
        }
        let horizontalPercentage = insetAdjustedContentOffset.x / totalScrollableWidth

        return (horizontal: min(max(horizontalPercentage, 0), 1), vertical: min(max(verticalPercentage, 0), 1))
    }

    /// `true` if the scroll view is scrolled to the top, else `false`
    var isScrolledToTop: Bool {
        guard insetAdjustedContentSize.height > frame.height else {
            return insetAdjustedContentOffset.y <= 0
        }
        return scrollPercentage.vertical <= .leastNormalMagnitude
    }

    /// `true` if the scroll view is scrolled to the bottom, else `false`
    var isScrolledToBottom: Bool {
        guard insetAdjustedContentSize.height > frame.height else {
            return insetAdjustedContentOffset.y > insetAdjustedContentSize.height - frame.height
        }

        // Ideally this wouldn't be hard coded, but `1 - .leastNormalMagnitude` doesn't always recognize when the bottom is reached. This could potentially be a problem on a very tall contentSize
        return 1.0 - scrollPercentage.vertical <= .leastNormalMagnitude
    }

    /// This method scrolls the content view to the top. If already at the top, the method does nothing.
    /// - Parameter animated: `true` if the scrolling should be animated, `false` if it should be immediate.
    func scrollToTop(animated: Bool) {
        scrollRectToVisible(.init(origin: .zero, size: .one), animated: animated)
        delegate?.scrollViewDidScroll?(self)
    }
}
