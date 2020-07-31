//
//  ScrollingPageControlSetupViewController.swift
//  UtiliKit-iOS
//
//  Created by Nathan Chiu on 5/6/20.
//  Copyright © 2020 Bottle Rocket Studios. All rights reserved.
//

import UIKit

class ScrollingPageControlSetupViewController: UIViewController {
    
    // MARK: Properties
    private let colors: [String: UIColor] =
        ["gray": .systemGray,
         "blue": .systemBlue,
         "green": .systemGreen,
         "red": .systemRed,
         "pink": .systemPink,
         "teal": .systemTeal,
         "orange": .systemOrange,
         "purple": .systemPurple,
         "yellow": .systemYellow]
    private lazy var colorKeys: [String] = { colors.keys.map { $0 } }()
    private var selectedPageIndicatorTintColorIndex = 0
    private var selectedCurrentPageIndicatorTintColorIndex = 1
    
    // MARK: Outlets
    @IBOutlet private var numberOfPagesCountLabel: UILabel!
    @IBOutlet private var numberOfPagesCountStepper: UIStepper!
    
    @IBOutlet private var currentPageIndexLabel: UILabel!
    @IBOutlet private var currentPageIndexStepper: UIStepper!
    
    @IBOutlet private var hidesForSinglePageSwitch: UISwitch!
    
    @IBOutlet private var pageIndicatorTintColorButton: UIButton!
    
    @IBOutlet private var currentPageIndicatorTintColorButton: UIButton!
    
    @IBOutlet private var mainDotCountLabel: UILabel!
    @IBOutlet private var mainDotCountStepper: UIStepper!
    
    @IBOutlet private var marginDotCountLabel: UILabel!
    @IBOutlet private var marginDotCountStepper: UIStepper!
    
    @IBOutlet private var dotSizeWidthLabel: UILabel!
    @IBOutlet private var dotSizeWidthStepper: UIStepper!
    
    @IBOutlet private var dotSizeHeightLabel: UILabel!
    @IBOutlet private var dotSizeHeightStepper: UIStepper!
    
    @IBOutlet private var dotSpacingLabel: UILabel!
    @IBOutlet private var dotSpacingStepper: UIStepper!
    
    @IBOutlet private var minimumDotScaleLabel: UILabel!
    @IBOutlet private var minimumDotScaleStepper: UIStepper!
    
    // MARK: Public
    // MARK: UIViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        pressedResetButton()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        if let destVC = segue.destination as? ScrollingPageControlExampleViewController {
            destVC.configure(with: .init(numberOfPages: Int(numberOfPagesCountStepper.value),
                                         currentPage: Int(currentPageIndexStepper.value),
                                         hidesForSinglePage: hidesForSinglePageSwitch.isOn,
                                         pageIndicatorTintColor: colors[colorKeys[selectedPageIndicatorTintColorIndex]] ?? UIColor.gray,
                                         currentPageIndicatorTintColor: colors[colorKeys[selectedCurrentPageIndicatorTintColorIndex]] ?? UIColor.blue,
                                         mainDotCount: Int(mainDotCountStepper.value),
                                         marginDotCount: Int(marginDotCountStepper.value),
                                         dotSize: CGSize(width: CGFloat(dotSizeWidthStepper.value),
                                                         height: CGFloat(dotSizeHeightStepper.value)),
                                         dotSpacing: CGFloat(dotSpacingStepper.value),
                                         minimumDotScale: CGFloat(minimumDotScaleStepper.value)))
        }
    }
    
    // MARK: Private
    // MARK: Actions
    @IBAction func changedNumberOfPagesStepper(_ sender: UIStepper) {
        numberOfPagesCountLabel.text = "\(Int(sender.value))"
        
        currentPageIndexStepper.maximumValue = sender.value - 1
        currentPageIndexLabel.text = "\(Int(currentPageIndexStepper.value))"
    }
    
    @IBAction func changedCurrentPageStepper(_ sender: UIStepper) {
        currentPageIndexLabel.text = "\(Int(sender.value))"
    }
    
    @IBAction func pressedPageIndicatorTintColorButton(_ sender: UIButton) {
        selectedPageIndicatorTintColorIndex += 1
        selectedPageIndicatorTintColorIndex %= colorKeys.count
        sender.setTitle(colorKeys[selectedPageIndicatorTintColorIndex], for: .normal)
        sender.setTitleColor(colors[colorKeys[selectedPageIndicatorTintColorIndex]] ?? UIColor.gray, for: .normal)
    }
    
    @IBAction func pressedCurrentPageIndicatorTintColorButton(_ sender: UIButton) {
        selectedCurrentPageIndicatorTintColorIndex += 1
        selectedCurrentPageIndicatorTintColorIndex %= colorKeys.count
        sender.setTitle(colorKeys[selectedCurrentPageIndicatorTintColorIndex], for: .normal)
        sender.setTitleColor(colors[colorKeys[selectedCurrentPageIndicatorTintColorIndex]] ?? UIColor.blue, for: .normal)
    }
    
    @IBAction func changedMainDotCountStepper(_ sender: UIStepper) {
        mainDotCountLabel.text = "\(Int(sender.value))"
    }
    
    @IBAction func changedMarginDotCountStepper(_ sender: UIStepper) {
        marginDotCountLabel.text = "\(Int(sender.value))"
    }
    
    @IBAction func changedDotSizeWidthStepper(_ sender: UIStepper) {
        dotSizeWidthLabel.text = "\(sender.value)"
    }
    
    @IBAction func changedDotSizeHeightStepper(_ sender: UIStepper) {
        dotSizeHeightLabel.text = "\(sender.value)"
    }
    
    @IBAction func changedDotSpacingStepper(_ sender: UIStepper) {
        dotSpacingLabel.text = "\(sender.value)"
    }
    
    @IBAction func changedMinimumDotScaleStepper(_ sender: UIStepper) {
        minimumDotScaleLabel.text = String(format: "%.2f", sender.value)
    }
    
    @IBAction func pressedResetButton() {
        numberOfPagesCountLabel.text = "10"
        numberOfPagesCountStepper.value = 10
        
        currentPageIndexLabel.text = "0"
        currentPageIndexStepper.value = 0
        currentPageIndexStepper.maximumValue = 9
        
        hidesForSinglePageSwitch.isOn = false
        
        pageIndicatorTintColorButton.setTitle("gray", for: .normal)
        selectedPageIndicatorTintColorIndex = colorKeys.firstIndex(of: "gray") ?? 0
        pageIndicatorTintColorButton.setTitleColor(colors[colorKeys[selectedPageIndicatorTintColorIndex]] ?? UIColor.gray, for: .normal)
        
        currentPageIndicatorTintColorButton.setTitle("blue", for: .normal)
        selectedCurrentPageIndicatorTintColorIndex = colorKeys.firstIndex(of: "blue") ?? 0
        currentPageIndicatorTintColorButton.setTitleColor(colors[colorKeys[selectedCurrentPageIndicatorTintColorIndex]] ?? UIColor.blue, for: .normal)
        
        mainDotCountLabel.text = "3"
        mainDotCountStepper.value = 3
        
        marginDotCountLabel.text = "2"
        marginDotCountStepper.value = 2
        
        dotSizeWidthLabel.text = "7.0"
        dotSizeWidthStepper.value = 7
        
        dotSizeHeightLabel.text = "7.0"
        dotSizeHeightStepper.value = 7
        
        dotSpacingLabel.text = "9.0"
        dotSpacingStepper.value = 9
        
        minimumDotScaleLabel.text = "0.40"
        minimumDotScaleStepper.value = 0.4
    }
}
