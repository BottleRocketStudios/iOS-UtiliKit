//
//  ScrollingPageControl.swift
//  UtiliKit-iOS
//
//  Created by Nathan Chiu on 7/3/19.
//  Copyright © 2019 Bottle Rocket Studios. All rights reserved.
//

import UIKit

// MARK: -
@available(iOS, deprecated: 14.0, message: "Functionality is available with UIKit UIPageControls starting with iOS 14")
@IBDesignable
class ScrollingPageControl: UIView {
    
    // MARK: Properties
    
    // MARK: Modeled Off UIPageControl
    
    /// The total number of pages represented, Default is `0`
    @IBInspectable var numberOfPages: Int {
        set { _numberOfPages = max(0, newValue) } // prevent a negative number of pages
        get { return _numberOfPages }
    }
    
    private var _numberOfPages: Int = 0 {
        didSet {
            currentPage = _currentPage // keep the current page in range
            refreshDotLayout()
        }
    }
    
    /// The index of the currently selected page. Default is `0`. Value pinned to `0..numberOfPages-1`
    @IBInspectable var currentPage: Int {
        set {
            _currentPage = max(0, min(newValue, numberOfPages - 1)) // clamp the newValue between 0 and numberOfPages
        }
        get { return _currentPage }
    }
    
    private var _currentPage: Int = 0 {
        didSet {
            UIView.animate(withDuration: 0.3, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0.0, options: .beginFromCurrentState, animations: {
                self.updateOffsetIfNeeded()
                self.layoutIfNeeded()
                self.updateDotColors()
                self.didSetCurrentPage?(self._currentPage)
            })
        }
    }
    
    /// Hide the the indicator if there is only one page. Default is `false`.
    @IBInspectable var hidesForSinglePage: Bool = false {
        didSet { evaluateSelfHiding() }
    }
    
    /// Tint color used to represent pages other than the `currentPage`
    @IBInspectable var pageIndicatorTintColor: UIColor? = .systemGray {
        didSet { updateDotColors() }
    }
    
    /// Tint color used to represent the `currentPage`
    @IBInspectable var currentPageIndicatorTintColor: UIColor? = .systemBlue {
        didSet {
            tintColor = currentPageIndicatorTintColor
            updateDotColors()
        }
    }
    
    // MARK: Visual Customization
    /// The number of dots between the margins that will not scale. This cannot be set to a value less than 1.
    @IBInspectable var mainDotCount: Int {
        set { _mainDotCount = max(1, newValue) }
        get { return _mainDotCount }
    }
    
    private var _mainDotCount = 3 {
        didSet { refreshDotLayout() }
    }
    
    /// The number of dots on each side that will scale if `numberOfPages` is greater than `maxVisibleDots`. This cannot be set to a value less than 0.
    @IBInspectable var marginDotCount: Int {
        set { _marginDotCount = max(0, newValue) }
        get { return _marginDotCount }
    }
    
    private var _marginDotCount = 2 {
        didSet { refreshDotLayout() }
    }
    
    /// The maximum number of dots that are visible at once- includes the number of dots each margin and the main area can contain. Dependant on the `mainDotCount` and `marginDotCount` variables
    var maxVisibleDots: Int { return max(1, marginDotCount + mainDotCount + marginDotCount) }
    
    /// The size of each dot view when it's index is in the main area of the control
    var dotSize: CGSize {
        set {
            _dotWidth = newValue.width
            _dotHeight = newValue.height
            refreshDotLayout()
        }
        get { return CGSize(width: _dotWidth, height: _dotHeight) }
    }
    
    @available(*, message: "This only exists since dotSize can't be IBInspectable as a CGSize. Use dotSize.width instead")
    @IBInspectable private var _dotWidth: CGFloat = 7.0
    
    @available(*, message: "This only exists since dotSize can't be IBInspectable as a CGSize. Use dotSize.width instead")
    @IBInspectable private var _dotHeight: CGFloat = 7.0
    
    /// The amount of space between each page dot view
    @IBInspectable var dotSpacing: CGFloat = 9.0 {
        didSet {
            stackView.spacing = dotSpacing
            refreshDotLayout()
        }
    }
    
    /// The scale factor for the dots in the outtermost position before scrolling out of frame. Used when `numberOfPages` is greater than `maxVisibleDots`, else the dots do not scale.
    @IBInspectable var minimumDotScale: CGFloat = 0.4 {
        didSet {
            guard minimumDotScale >= 0.0 else {
                minimumDotScale = 0.0
                return
            }
            guard minimumDotScale <= 1.0 else {
                minimumDotScale = 1.0
                return
            }
            
            // Rescale margin dots if needed
            if let pageOffset = pageOffset { self.pageOffset = pageOffset }
        }
    }
    
    /// Customization point to change the view used per dot. Returning `nil` will default to dots at the specified `dotSize`. Not setting this block, or setting it to `nil`, will default to all dots at the specified `dotSize`.
    var customPageDotAtIndex: ((_ index: Int) -> UIView?)? {
        didSet {
            resetDots()
        }
    }
    
    /// A block used to respond to changes to `currentPage`- either setting that value programatically, or through control interation
    var didSetCurrentPage: ((_ index: Int) -> Void)?
    
    // MARK: Private
    private var stackView = UIStackView(arrangedSubviews: [])
    private var dotContainerViews: [UIView] { return stackView.arrangedSubviews }
    
    private lazy var stackViewWidthConstraint: NSLayoutConstraint = {
        let constraint = stackView.widthAnchor.constraint(equalToConstant: dotRowSize.width)
        constraint.isActive = true
        return constraint
    }()
    
    private lazy var stackViewHeightConstraint: NSLayoutConstraint = {
        let constraint = stackView.heightAnchor.constraint(equalToConstant: dotRowSize.height)
        constraint.isActive = true
        return constraint
    }()
    
    private var stackViewOffsetConstraint: NSLayoutConstraint!
    
    private var dotRowSize: CGSize {
        return CGSize(width: (CGFloat(numberOfPages) * dotSize.width) + (CGFloat(numberOfPages - 1) * dotSpacing), height: dotSize.height)
    }
    
    private var dotsWillOverflow: Bool { return numberOfPages > maxVisibleDots }
    
    private var pageOffset: Int? = nil {
        didSet {
            let needsToScroll = numberOfPages > maxVisibleDots
            if !needsToScroll && pageOffset != 0 {
                self.pageOffset = 0
                return
            }
            
            guard let pageOffset = pageOffset else { return }
            
            // Shift internal stack view
            stackViewOffsetConstraint.constant = CGFloat(pageOffset) * (dotSize.width + dotSpacing)
            
            // Un-scale dots in the middle
            let mainDotRange = (0..<mainDotCount).map { $0 + marginDotCount + pageOffset }
            mainDotRange.forEach {
                guard 0 <= $0 && $0 < dotContainerViews.count else { return }
                dotContainerViews[$0].transform = .identity
            }
            
            // Scale dots in the margins
            if let firstMainDotIndex = mainDotRange.first, let lastMainDotIndex = mainDotRange.last {
                (0..<marginDotCount).forEach {
                    let scaleFactor = minimumDotScale + (1.0 - minimumDotScale) * (CGFloat($0 + 1) / CGFloat(marginDotCount + 1))
                    func scaleDot(at index: Int) {
                        guard index >= 0 && index < dotContainerViews.count else { return }
                        dotContainerViews[index].transform = needsToScroll ? CGAffineTransform(scaleX: scaleFactor, y: scaleFactor) : .identity
                    }
                    let marginOffset = marginDotCount - $0
                    scaleDot(at: firstMainDotIndex - marginOffset)
                    scaleDot(at: lastMainDotIndex + marginOffset)
                }
            }
        }
    }
    
    // MARK: Public
    /// Call to update the appearance of the dot at the specified `index`. Uses `customPageDotAtIndex` to get the new view for `index`.
    func updateDot(at index: Int) {
        dotContainerViews[index].subviews.first?.removeFromSuperview()
        let dotView = customPageDotAtIndex?(index) ?? PageDotView(frame: CGRect(origin: .zero, size: dotSize))
        dotView.translatesAutoresizingMaskIntoConstraints = false
        dotContainerViews[index].addSubview(dotView)
        dotView.centerViewInSuperview()
    }
    
    /// Call to update the appearance of the dot at the specified `indices`. Uses `customPageDotAtIndex` to get the new view for each index in `indices`.
    func updateDots(at indices: [Int]) {
        indices.forEach { updateDot(at: $0) }
    }
    
    // MARK: Initalizers
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initalSubviewSetup()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initalSubviewSetup()
    }
    
    convenience init() {
        self.init(frame: .zero)
    }
    
    // MARK: UIView
    override var intrinsicContentSize: CGSize {
        let visibleDots = CGFloat(min(numberOfPages, maxVisibleDots))
        guard visibleDots > 0 else { return .zero }
        let minimumControlHeight: CGFloat = 37.0
        return CGSize(width: (visibleDots * dotSize.width) + ((visibleDots - 1.0) * dotSpacing), height: max(minimumControlHeight, dotSize.height))
    }
    
    override func tintColorDidChange() {
        super.tintColorDidChange()
        currentPageIndicatorTintColor = tintColor
    }
    
    override func accessibilityDecrement() {
        currentPage -= 1
    }
    
    override func accessibilityIncrement() {
        currentPage += 1
    }
    
    override var accessibilityLabel: String? {
        set { _ = newValue }
        get {
            return numberOfPages == 0 ? NSLocalizedString("no pages", comment: "ScrollingPageControl - empty state accessibility label") : String.localizedStringWithFormat(NSLocalizedString("page %d of %d", comment: "ScrollingPageControl - current page accessibility label"), currentPage + 1, numberOfPages)
        }
    }
    
    override var accessibilityValue: String? {
        set { _ = newValue }
        get {
            return numberOfPages == 0 ? "" : "\(currentPage + 1)"
        }
    }
    
    override var isAccessibilityElement: Bool {
        set { _ = newValue }
        get { return true }
    }
    
    override var accessibilityTraits: UIAccessibilityTraits {
        set { _ = newValue }
        get {
            return [.adjustable, .updatesFrequently]
        }
    }
    
    // MARK: Private
    
    private func initalSubviewSetup() {
        clipsToBounds = true
        
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.spacing = dotSpacing
        stackView.setContentCompressionResistancePriority(.required, for: .horizontal)
        stackView.setContentCompressionResistancePriority(.required, for: .vertical)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stackView)
        stackViewOffsetConstraint = leadingAnchor.constraint(equalTo: stackView.leadingAnchor)
        stackViewOffsetConstraint.isActive = true
        centerYAnchor.constraint(equalTo: stackView.centerYAnchor).isActive = true
        
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapAction(_:))))
    }
    
    @objc private func tapAction(_ gestureRecognizer: UITapGestureRecognizer) {
        if gestureRecognizer.location(in: self).x > bounds.midX {
            accessibilityIncrement()
        } else {
            accessibilityDecrement()
        }
    }
    
    private func resetDots() {
        while !stackView.arrangedSubviews.isEmpty {
            guard let nextView = stackView.arrangedSubviews.last else { break }
            stackView.removeArrangedSubview(nextView)
            nextView.removeFromSuperview()
            
        }
        
        guard numberOfPages > 0 else { return }
        for index in 0..<numberOfPages {
            let dotView = customPageDotAtIndex?(index) ?? PageDotView(frame: CGRect(origin: .zero, size: dotSize))
            dotView.translatesAutoresizingMaskIntoConstraints = false
            let containerView = UIView(frame: CGRect(origin: .zero, size: dotSize))
            containerView.translatesAutoresizingMaskIntoConstraints = false
            containerView.addSubview(dotView)
            dotView.centerViewInSuperview()
            containerView.tintColor = index == currentPage ? currentPageIndicatorTintColor : pageIndicatorTintColor
            stackView.addArrangedSubview(containerView)
        }
        
        pageOffset = nil
    }
    
    private func updateDotColors() {
        guard !dotContainerViews.isEmpty else { return }
        (0..<dotContainerViews.count).forEach {
            dotContainerViews[$0].tintColor = $0 == currentPage ? currentPageIndicatorTintColor : pageIndicatorTintColor
        }
    }
    
    private func evaluateSelfHiding() {
        isHidden = hidesForSinglePage ? (numberOfPages <= 1) : isHidden
    }
    
    private func updateOffsetIfNeeded() {
        if pageOffset == nil { pageOffset = 0 }
        if numberOfPages <= maxVisibleDots {
            self.pageOffset = 0
            return
        }
        while currentPage - pageOffset! < marginDotCount { pageOffset! -= 1 }
        while currentPage - pageOffset! >= marginDotCount + mainDotCount { pageOffset! += 1 }
    }
    
    private func refreshDotLayout() {
        stackViewWidthConstraint.constant = dotRowSize.width
        stackViewHeightConstraint.constant = dotRowSize.height
        evaluateSelfHiding()
        resetDots()
        updateOffsetIfNeeded()
        invalidateIntrinsicContentSize()
    }
    
    override class func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
    }
}

private extension ScrollingPageControl {
    
    /// The default class used by `ScrollingPageControl` to represent pages.
    class PageDotView: UIView {
        
        // MARK: Properties
        private var contentSize: CGSize
        
        // MARK: Initializers
        override init(frame: CGRect) {
            contentSize = frame.size
            super.init(frame: frame)
            translatesAutoresizingMaskIntoConstraints = false
        }
        
        required init?(coder aDecoder: NSCoder) {
            contentSize = .zero
            super.init(coder: aDecoder)
            assertionFailure("Should never be instantiated from Interface Builder")
        }
        
        // MARK: UIView
        override var backgroundColor: UIColor? {
            set { _ = newValue }
            get { return super.backgroundColor }
        }
        
        override var frame: CGRect {
            didSet {
                updateCornerRadiusIfNeeded()
            }
        }
        
        override var intrinsicContentSize: CGSize { return contentSize }
        
        override var isAccessibilityElement: Bool {
            set { _ = newValue }
            get { return false }
        }
        
        override func tintColorDidChange() {
            super.tintColorDidChange()
            super.backgroundColor = tintColor
        }
        
        // MARK: Private
        private func updateCornerRadiusIfNeeded() {
            let cornerRadius = min(contentSize.width, contentSize.height) / 2.0
            if layer.cornerRadius != cornerRadius {
                layer.cornerRadius = cornerRadius
            }
        }
    }
}
