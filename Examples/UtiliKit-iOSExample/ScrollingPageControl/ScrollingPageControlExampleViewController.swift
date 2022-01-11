//
//  ScrollingPageControlExampleViewController.swift
//  UtiliKit-iOS
//
//  Created by Nathan Chiu on 5/6/20.
//  Copyright © 2020 Bottle Rocket Studios. All rights reserved.
//

import UIKit

class ScrollingPageControlExampleViewController: UIViewController, Configurable {
    
    // MARK: Properties
    private var initialConfiguration: Configuration?
    private var pendingOffset: CGFloat?
    private var favoriteButtons = [UIButton]()
    
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
    
    func configure(with element: Configuration) {
        initialConfiguration = element
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        applyInitialConfiguration()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let pendingOffset = pendingOffset {
            scrollView.scrollRectToVisible(CGRect(origin: CGPoint(x: pendingOffset, y: 0.0), size: .zero), animated: true)
        }
    }
    
    // MARK: Private
    private func applyInitialConfiguration() {
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
        
        scrollingPageControl.customPageDotAtIndex = { [weak self] index in
            guard let self = self, index < self.favoriteButtons.count, self.favoriteButtons[index].isSelected else { return nil }
            let label = TintableLabel(frame: CGRect(origin: .zero, size: initialConfiguration.dotSize))
            label.font = UIFont.boldSystemFont(ofSize: initialConfiguration.dotSize.height * 1.5)
            label.text = "♥︎"
            return label
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
        let pageView = UIView()
        pageView.backgroundColor = UIColor.white.withAlphaComponent(0.9)
        pageView.layer.borderColor = UIColor.black.cgColor
        pageView.layer.borderWidth = 2.0
        pageView.translatesAutoresizingMaskIntoConstraints = false
        
        let favoriteButton = UIButton(type: .custom)
        favoriteButton.setTitleColor(.systemBlue, for: .normal)
        favoriteButton.setTitle("♡ \(number)", for: .normal)
        favoriteButton.setTitle("♥︎ \(number)", for: .selected)
        favoriteButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 35.0)
        favoriteButton.addTarget(self, action: #selector(pressedFavoriteButton(_:)), for: .touchUpInside)
        favoriteButton.translatesAutoresizingMaskIntoConstraints = false
        pageView.addSubview(favoriteButton)
        favoriteButton.centerViewInSuperview()
        
        favoriteButtons.append(favoriteButton)

        return pageView
    }
    
    // MARK: Actions
    @objc private func pressedFavoriteButton(_ sender: UIButton) {
        sender.isSelected.toggle()
        if let pageNumber = Int(sender.titleLabel?.text?.filter({ "0123456789".contains($0) }) ?? "") {
            scrollingPageControl.updateDot(at: pageNumber)
        }
    }
}

extension ScrollingPageControlExampleViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.isDragging {
            let page = Int((scrollView.contentOffset.x / scrollView.frame.width).rounded())
            if scrollingPageControl.currentPage != page { scrollingPageControl.currentPage = page}
        }
    }
}

private class TintableLabel: UILabel {
    
    override func tintColorDidChange() {
        super.tintColorDidChange()
        textColor = tintColor
    }
}
