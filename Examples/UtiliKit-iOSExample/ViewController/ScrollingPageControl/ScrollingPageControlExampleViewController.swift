//
//  ScrollingPageControlExampleViewController.swift
//  UtiliKit-iOS
//
//  Created by Nathan Chiu on 5/6/20.
//  Copyright © 2020 Bottle Rocket Studios. All rights reserved.
//

import UIKit

class ScrollingPageControlExampleViewController: UIViewController {
    
    // MARK: Properties
    private var initialConfiguration: Configuration?
    private var pendingOffset: CGFloat?
    
    // MARK: Outlets
    @IBOutlet private var scrollView: UIScrollView!
    @IBOutlet private var pageStackView: UIStackView!
    @IBOutlet private var scrollingPageControl: ScrollingPageControl!

    // MARK: Public
    struct Configuration {
        let numberOfPages: Int
        let currentPage: Int
        let hidesForSinglePage: Bool
        let pageIndicatorTintColor: UIColor
        let currentPageIndicatorTintColor: UIColor
        let mainDotCount: Int
        let marginDotCount: Int
        let dotSize: CGSize
        let dotSpacing: CGFloat
        let minimumDotScale: CGFloat
    }
    
    func configure(with configuration: Configuration) {
        print(configuration)
        initialConfiguration = configuration
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        applyInitialConfifuration()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let pendingOffset = pendingOffset {
            scrollView.scrollRectToVisible(CGRect(origin: CGPoint(x: pendingOffset, y: 0.0), size: .zero), animated: true)
        }
    }
    
    // MARK: Private
    private func applyInitialConfifuration() {
        guard let initialConfiguration = initialConfiguration,
            let scrollingPageControl = scrollingPageControl else { return }
        
        (0..<initialConfiguration.numberOfPages).forEach {
            let newPageView = buildPageView(forPageNumber: $0)
            pageStackView.addArrangedSubview(newPageView)
        }
        pageStackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: CGFloat(initialConfiguration.numberOfPages)).isActive = true
        scrollView.setNeedsLayout()
        scrollView.layoutIfNeeded()
        
        scrollingPageControl.didSetCurrentPage = { [weak self] index in
            guard let self = self, !self.scrollView.isDragging else { return }
            self.scrollView.contentOffset.x = CGFloat(index) * self.scrollView.frame.width
        }
        
        scrollingPageControl.numberOfPages = initialConfiguration.numberOfPages
        scrollingPageControl.currentPage = initialConfiguration.currentPage
        scrollingPageControl.hidesForSinglePage = initialConfiguration.hidesForSinglePage
        scrollingPageControl.pageIndicatorTintColor = initialConfiguration.pageIndicatorTintColor
        scrollingPageControl.currentPageIndicatorTintColor = initialConfiguration.currentPageIndicatorTintColor
        scrollingPageControl.mainDotCount = initialConfiguration.mainDotCount
        scrollingPageControl.marginDotCount = initialConfiguration.marginDotCount
        scrollingPageControl.dotSize = initialConfiguration.dotSize
        scrollingPageControl.dotSpacing = initialConfiguration.dotSpacing
        scrollingPageControl.minimumDotScale = initialConfiguration.minimumDotScale
        
        self.initialConfiguration = nil
    }
    
    private func buildPageView(forPageNumber number: Int) -> UIView {
        let pageNumberLabel = UILabel()
        pageNumberLabel.text = "\(number)"
        pageNumberLabel.font = UIFont.boldSystemFont(ofSize: 35.0)
        pageNumberLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let pageView = UIView()
        pageView.backgroundColor = UIColor.white.withAlphaComponent(0.9)
        pageView.layer.borderColor = UIColor.black.cgColor
        pageView.layer.borderWidth = 2.0
        pageView.translatesAutoresizingMaskIntoConstraints = false
        pageView.addSubview(pageNumberLabel)
        pageNumberLabel.centerXAnchor.constraint(equalTo: pageView.centerXAnchor).isActive = true
        pageNumberLabel.centerYAnchor.constraint(equalTo: pageView.centerYAnchor).isActive = true
        
        return pageView
    }
    
    // MARK: Actions
}

extension ScrollingPageControlExampleViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.isDragging {
            let page = Int((scrollView.contentOffset.x / scrollView.frame.width).rounded())
            if scrollingPageControl.currentPage != page { scrollingPageControl.currentPage = page}
        }
    }
}
