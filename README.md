UtiliKit
============
[![CI Status](http://img.shields.io/travis/BottleRocketStudios/iOS-UtiliKit.svg?style=flat)](https://travis-ci.org/BottleRocketStudios/iOS-UtiliKit)
[![Version](https://img.shields.io/cocoapods/v/UtiliKit.svg?style=flat)](http://cocoapods.org/pods/UtiliKit)
[![License](https://img.shields.io/cocoapods/l/UtiliKit.svg?style=flat)](http://cocoapods.org/pods/UtiliKit)
[![Platform](https://img.shields.io/cocoapods/p/UtiliKit.svg?style=flat)](http://cocoapods.org/pods/UtiliKit)
[![codecov](https://codecov.io/gh/BottleRocketStudios/iOS-UtiliKit/branch/master/graph/badge.svg)](https://codecov.io/gh/BottleRocketStudios/iOS-UtiliKit)
[![codebeat badge](https://codebeat.co/badges/e47aed79-20ee-4054-b8cd-2bdaceab52dd)](https://codebeat.co/projects/github-com-bottlerocketstudios-ios-utilikit-master)

### Purpose
This library provides several useful and often common additions for iOS applications. These extensions, protocols, and structs are designed to simplify boilerplate code as well as remove common "Stringly-typed" use cases.

### Key Concepts
This library is divided into 5 parts.
* Instantiation - This subspec changes "Stringly-typed" view instantiation, view controller instantiation, and reusable view dequeuing into type-safe function calls.
* General - This subspec includes extensions for both FileManager and UIView. These simplify getting common URLs and programmatically adding views down to simple variables and function calls.
* Version - This subspec simplifies the display of version and build numbers.
* TimelessDate - This subspec is an abstraction away from Date and Calendar. It is primarily designed to be used for simple scheduling and day comparisons in which the time is less important that the actual day.
* Container - This subspec provides a simple ContainerViewController without any built-in navigation construct.

### Usage
#### Reusable Views
Registering and dequeuing cells, collection view supplementary views, table view headers and footers, and annotations is as simple as calling register on their presenting view, and dequeuing them in the collectionView(_:, cellForItemAt:) -> UICollectionViewCell, or equivalent, function.

``` swift
class ViewController: UIViewController {
    @IBOutlet var collectionView: UICollectionView!
    let dataA: [Int] = [0, 1, 2]
    let dataB: [Int] = [0, 1, 2]
    let dataC: [Int] = [0, 1, 2]
    var data: [[Int]] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.register(ProgrammaticCell.self)
        collectionView.registerHeaderFooter(ProgrammaticHeaderFooterView.self)
        collectionView.delegate = self
        collectionView.dataSource = self
    }
}

// MARK: - UICollectionViewDataSource
extension ViewController: UICollectionViewDataSource {

    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data[section].count
    }

    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return data.count
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // Dequeue a "ProgrammaticCell" from the collection view using only the cell type
        let cell: ProgrammaticCell = collectionView.dequeueReusableCell(for: indexPath)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {

        // You need only provide the desired type and SupplementaryElementKind to receive a typed UICollectionReusableView
        switch kind {
        case UICollectionElementKindSectionHeader:
            let header: ProgrammaticHeaderFooterView = collectionView.dequeueReusableSupplementaryView(of: .sectionHeader, for: indexPath)
            return header
        default:
            let footer: ProgrammaticHeaderFooterView = collectionView.dequeueReusableSupplementaryView(of: .sectionFooter, for: indexPath)
            footer.kind = .sectionFooter
            return footer
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension ViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 100)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 50)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 25)
    }
}
```

#### View Controllers
In order to instantiate a view controller from a storyboard you simply need to create a Storyboard.Identifier for the storyboard and define the return type.
A simple implementation might look like this:

``` swift
extension UIStoryboard.Identifier {

    static let myStoryboard = UIStoryboard.Identifier(name: "MyStoryboard")
}

class ViewController: UIViewController {

    func presentMyViewController() {
        let vc: MyViewController = UIStoryboard(identifier: .myStoryboard).instantiateViewController()
        present(vc, animated: true)
    }
}
```

#### Version Numbers
Getting version numbers into user facing strings only requires a function call. *Note this function throws an error if the provided version config contains an invalid key.
A simple implementation might look like this:

``` swift
func printVersions() {
    do {
        let customVersionString = try Bundle.main.versionString(for: MyVersionConfig(), isShortVersion: false)
        let verboseVersionString = try Bundle.main.verboseVersionString()
        let versionString = try Bundle.main.versionString()

        print(customVersionString)
        print(verboseVersionString)
        print(versionString)
    } catch {
        print(error)
    }
}
```

#### Timeless Dates
A Timeless Date is a simple abstraction the removes the time from a Date and uses Calendar for calculations. This is especially useful for calendar and travel use cases as seeing how many days away something is often is more important that the number of hours between them / 24.

``` swift
func numberOfDaysBetween(start: TimelessDate, finish: TimelessDate) -> DateInterval {
    return start.dateIntervalSince(finish)
}

func isOneWeekFrom(checkout: TimelessDate) -> Bool {
    return checkout.dateIntervalSince(TimelessDate()) <= 7
}
```

This struct also removes the imprecise calculations of adding days, hours, minutes, and seconds to a date and replaces them with Calendar calculations.

``` swift
func addOneHourTo(date: Date) -> Date {
    return date.adding(hours: 1)
}
```

#### ContainerViewController
A solution for managing multiple child view controllers, the ContainerViewController manages the lifecycle of the child controllers. This allows you to focus on the navigational structure of your views as well as the transitions between them.

``` swift
containerViewController.managedChildren = [Child(identifier: "A", viewController: controllerA), Child(identifier: "B", viewController: controllerB)]

containerViewController.willMove(toParent: self)

addChild(containerViewController)
containerView.addSubview(containerViewController.view)
containerViewController.view.frame = containerView.bounds

containerViewController.didMove(toParent: self)
```

At this point, transitioning between the children of the container is incredibly simple.

``` swift
let child = ...
containerViewController.transitionToController(for: child)
```

The container also has several delegate callback which can help customize it's behavior. Among them, is a function which returns a UIViewControllerAnimatedTransitioning object.

``` swift
func containerViewController(_ container: ContainerViewController, animationControllerForTransitionFrom source: UIViewController, to destination: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    if useCustomAnimator, let sourceIndex = container.index(ofChild: source), let destinationIndex = container.index(ofChild: destination) {
        return WipeTransitionAnimator(withStartIndex: sourceIndex, endIndex: destinationIndex)
    }

    return nil
}
```

### Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

### Requirements

Requires iOS 9.0 +, Swift 4.0

### Installation - CocoaPods

[CocoaPods]: http://cocoapods.org

Add the following to your [Podfile](http://guides.cocoapods.org/using/the-podfile.html):

```ruby
pod 'UtiliKit'
```

You will also need to make sure you're opting into using frameworks:

```ruby
use_frameworks!
```

Then run `pod install` with CocoaPods 0.36 or newer.

### Contributing

See the [CONTRIBUTING] document. Thank you, [contributors]!

[CONTRIBUTING]: CONTRIBUTING.md
[contributors]: https://github.com/BottleRocketStudios/iOS-UtiliKit/graphs/contributors
