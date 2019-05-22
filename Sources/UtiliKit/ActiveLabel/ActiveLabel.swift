//
//  ActiveLabel.swift
//  UtiliKit
//
//  Copyright © 2019 Bottle Rocket Studios. All rights reserved.
//

import UIKit

/// Used to show loading progress in a UILabel through an animated gradient.
///
/// Setting text to `nil` will cause the loading indicator to show, non-`nil` will remove the loading indicators.
/// Use `lastLineTrailingInset` and `lastLineLength` to control how the last line is displayed. If only 1 line then
/// it is considered the last line. `lastLineTrailingInset` takes precendence over `lastLineLength`.
@IBDesignable
class ActiveLabel: UILabel {
    static let loadingGray: UIColor = UIColor(red: 233.0/255.0, green: 231.0/255.0, blue: 237.0/255.0, alpha: 1.0)
    
    /// Struct used to represent how an `ActiveLabel` should be displayed. Should be passed into the `ActiveLabel` convenience initializer.
    struct ActiveLabelConfiguration {
        var estimatedNumberOfLines: UInt
        var finalLineTrailingInset: CGFloat
        var finalLineLength: CGFloat
        var loadingViewColor: UIColor
        var loadingLineHeight: CGFloat
        var loadingLineVerticalSpacing: CGFloat
        var loadingAnimationDuration: Double
        var loadingAnimationDelay: Double
        
        /// Default configuration to be used with the `ActiveLabel` convenience initializer.
        ///
        /// Default values are:
        /// - estimatedNumberOfLines = 1
        /// - finalLineTrailingInset = 0
        /// - finalLineLength = 0
        /// - loadingViewColor = (233,231,237)
        /// - loadingLineHeight = 8
        /// - loadingLineVerticalSpacing = 14
        /// - loadingAnimationDuration = 2.4
        /// - loadingAnimationDelay = 0.4
        static var `default`: ActiveLabelConfiguration {
            return ActiveLabelConfiguration(estimatedNumberOfLines: 1,
                                            finalLineTrailingInset: 0,
                                            finalLineLength: 0,
                                            loadingViewColor: ActiveLabel.loadingGray,
                                            loadingLineHeight: 8,
                                            loadingLineVerticalSpacing: 14,
                                            loadingAnimationDuration: 2.4,
                                            loadingAnimationDelay: 0.4)
        }
    }
    
    /// Used to represent an `ActiveLabel`s state.
    enum State: Equatable {
        case loading
        case text(String)
        
        static func ==(lhs: State, rhs: State) -> Bool {
            switch (lhs, rhs) {
            case (.loading, .loading):
                return true
            case (let .text(leftString), let .text(rightString)):
                return leftString == rightString
            case (.loading, .text),
                 (.text, .loading):
                return false
            }
        }
    }
    
    /// The number of activity lines to display. Default is 1.
    @IBInspectable public var estimatedNumberOfLines: UInt = 1
    /// Trailing Inset for the last activity line. Default is 0.
    @IBInspectable public var finalLineTrailingInset: CGFloat = 0
    /// Line Length in points for the last activity line. If `finalLineTralingInset` is set to greater than 0 this value is not used. Default is 0.
    @IBInspectable public var finalLineLength: CGFloat = 0
    /// This color is the darkest area of the line seen during activity animation. Default is (233,231,237) Gray.
    @IBInspectable public var loadingViewColor: UIColor = ActiveLabel.loadingGray
    /// The height of each activity line. Default is 8.
    @IBInspectable public var loadingLineHeight: CGFloat = 8
    /// Vertical spacing between each activity line when 2 or more lines are displayed. Default is 14.
    @IBInspectable public var loadingLineVerticalSpacing: CGFloat = 14
    /// The duration of the gradient animation applied to the activity lines. Default is 2.4.
    @IBInspectable public var loadingAnimationDuration: Double = 2.4
    /// The delay that is applied before each animation begins. Default is 0.4.
    @IBInspectable public var loadingAnimationDelay: Double = 0.4
    /// Shows the loading views in the Storyboard by default since text of a label can't be nil in a Storybaord. Default is true.
    @IBInspectable private var showLoadingViewsInStoryboard: Bool = true
    
    /// Used to make sure the gradient is centered during snapshot testing
    var isSnapshotTesting: Bool = false
    
    /// Used for Animation KeyPath
    private static let locationKeyPath = "locations"
    
    /// When true the gradient will show centered so that it can be adjusted easily in IB
    private var isDisplayingInStoryboard: Bool = false
    /// Public read-only representation of the labels state. Either `loading` or `text(String)`.
    private(set) var state: State = .text("") {
        didSet {
            guard oldValue != state else { return }
            
            switch state {
            case .loading:
                text = nil
                if !isHidden {
                    showLoadingViews()
                }
            case .text:
                loadingViews.forEach({ $0.removeFromSuperview() })
                loadingViews.removeAll()
            }
        }
    }
    private var loadingViews: [UIView] = []
    private var maskOffset: CGFloat {
        // The offset is enough to make sure that the gradient doesn't originally show on screen.
        return bounds.width * 0.4
    }
    
    /**
     When text is set to `nil` the loading views will display. When text is non-`nil` the loading views will be hidden.
     */
    override var text: String? {
        didSet {
            textDidUpdate()
        }
    }
    
    override var isHidden: Bool {
        didSet {
            if isHidden {
                hideLoadingViews()
            } else if !isHidden && state == .loading {
                showLoadingViews()
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        commonInit()
    }
    
    convenience init(frame: CGRect, configuration: ActiveLabel.ActiveLabelConfiguration) {
        self.init(frame: frame)
        
        self.estimatedNumberOfLines = configuration.estimatedNumberOfLines
        self.finalLineTrailingInset = configuration.finalLineTrailingInset
        self.finalLineLength = configuration.finalLineTrailingInset
        self.loadingViewColor = configuration.loadingViewColor
        self.loadingLineHeight = configuration.loadingLineHeight
        self.loadingLineVerticalSpacing = configuration.loadingLineVerticalSpacing
        self.loadingAnimationDuration = configuration.loadingAnimationDuration
        self.loadingAnimationDelay = configuration.loadingAnimationDelay
        
        configurationChanged()
    }
    
    private func commonInit() {
        textDidUpdate()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        loadingViews.forEach { [weak self] (view) in
            guard let self = self else { return }
            if let maskLayer = view.layer.mask {
                maskLayer.bounds = CGRect(x: 0, y: 0, width: self.bounds.width + (maskOffset * 2), height: self.bounds.height)
                maskLayer.frame = CGRect(x: -maskOffset, y: 0, width: self.bounds.width + (maskOffset * 2), height: self.bounds.height)
            }
        }
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        
        isDisplayingInStoryboard = true
        state = showLoadingViewsInStoryboard ? .loading : .text("")
    }
    
    /**
     You must call this function to reset the loading views after you have changed a configuration value.
     */
    func configurationChanged() {
        loadingViews.forEach { $0.removeFromSuperview() }
        loadingViews.removeAll()
        
        if state == .loading {
            showLoadingViews()
        }
    }
}

private extension ActiveLabel {
    func textDidUpdate() {
        state = text == nil ? .loading : .text(text ?? "")
    }
    
    // MARK: - Loading View Functions
    func showLoadingViews() {
        if loadingViews.isEmpty {
            configureLoadingViews()
        }
        loadingViews.forEach({ $0.isHidden = false })
    }
    
    func hideLoadingViews() {
        loadingViews.forEach({ $0.isHidden = true })
    }
    
    func configureLoadingViews() {
        for index in 0..<Int(estimatedNumberOfLines) {
            let view = UIView()
            view.translatesAutoresizingMaskIntoConstraints = false
            view.backgroundColor = loadingViewColor
            
            let maskLayer = createLayerMask()
            maskLayer.add(maskAnimation(), forKey: "maskAnimation")
            view.layer.mask = maskLayer
            loadingViews.append(view)
            
            addSubview(view)
            setupConstraints(for: view, at: index)
        }
        
        loadingViews.forEach({ $0.isHidden = isHidden })
    }
    
    func setupConstraints(for view: UIView, at index: Int) {
        NSLayoutConstraint.activate([view.leadingAnchor.constraint(equalTo: leadingAnchor),
                                     view.heightAnchor.constraint(greaterThanOrEqualToConstant: loadingLineHeight)])
        
        if index == 0 {
            // Constrain the first view to the top of the label.
            view.topAnchor.constraint(equalTo: topAnchor).isActive = true
        } else {
            // If not the first view constrain the top to the above views bottom with the loadingLineVerticalSpacing.
            let aboveView = loadingViews[index - 1]
            view.topAnchor.constraint(equalTo: aboveView.bottomAnchor, constant: loadingLineVerticalSpacing).isActive = true
        }
        
        if index + 1 == estimatedNumberOfLines {
            // If this is the last view then constraint it's bottom to the label
            view.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
            
            // Handle the last line width/trailing constraint based on finalLineTrailingInset, finalLineLength, or none in that order.
            if finalLineTrailingInset != 0 {
                view.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -finalLineTrailingInset).isActive = true
            } else if finalLineLength != 0 {
                view.widthAnchor.constraint(equalToConstant: finalLineLength).isActive = true
            } else {
                view.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
            }
        } else {
            // Only set up the trailing constraint since next view will constrain to this bottomAnchor.
            view.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        }
    }
    
    // MARK: - CA Helpers
    func createLayerMask() -> CALayer {
        let maskLayer = CAGradientLayer()
        maskLayer.anchorPoint = .zero
        maskLayer.startPoint = CGPoint(x: 0, y: 1)
        maskLayer.endPoint = CGPoint(x: 1, y: 1)
        
        let lightColor = UIColor(white: 1, alpha: 0.5)
        let darkColor = UIColor(white: 1, alpha: 1)
        
        maskLayer.colors = [lightColor.cgColor, darkColor.cgColor, lightColor.cgColor]
        // If we are viewing in InterfaceBuilder we want to shift the gradient to the center so that it can be seen at design time otherwise set it to the far left.
        if (showLoadingViewsInStoryboard && isDisplayingInStoryboard) || isSnapshotTesting {
            maskLayer.locations = [NSNumber(value: 0.4), NSNumber(value: 0.5), NSNumber(value: 0.6)]
        } else {
            maskLayer.locations = [NSNumber(value: 0.0), NSNumber(value: 0.1), NSNumber(value: 0.2)]
        }
        maskLayer.bounds = CGRect(x: 0, y: 0, width: frame.width + (maskOffset * 2), height: frame.height)
        maskLayer.frame = CGRect(x: -maskOffset, y: 0, width: frame.width + (maskOffset * 2), height: frame.height)
        
        return maskLayer
    }
    
    func maskAnimation() -> CAAnimationGroup {
        let animationValues = [[NSNumber(value: 0.0), NSNumber(value: 0.1), NSNumber(value: 0.2)],
                               [NSNumber(value: 0.1), NSNumber(value: 0.3), NSNumber(value: 0.5)],
                               [NSNumber(value: 0.6), NSNumber(value: 0.8), NSNumber(value: 1.0)],
                               [NSNumber(value: 0.8), NSNumber(value: 0.9), NSNumber(value: 1.0)]]
        let animationPartDuration = loadingAnimationDuration / Double((animationValues.count - 1))
        
        var beginTime = loadingAnimationDelay
        var animations: [CABasicAnimation] = []
        
        for index in 0..<(animationValues.count - 1) {
            let animation = CABasicAnimation(keyPath: ActiveLabel.locationKeyPath)
            animation.fromValue = animationValues[index]
            animation.toValue = animationValues[index + 1]
            animation.beginTime = beginTime
            animation.duration = animationPartDuration
            animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
            animations.append(animation)
            
            beginTime = animation.beginTime + animation.duration
        }
        
        let group = CAAnimationGroup()
        group.isRemovedOnCompletion = false
        group.animations = animations
        group.duration = loadingAnimationDelay + loadingAnimationDuration
        group.repeatCount = Float.infinity
        group.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        
        return group
    }
}
