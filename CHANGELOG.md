## Master

##### Enhancements

* Improve support for registering supplementary and decoration views with UICollectionView.
[Will McGinty](https://github.com/willmcginty)
[#110](https://github.com/BottleRocketStudios/iOS-UtiliKit/pull/110)

* Re-organize the way Swift Packages are managed. Instead of importing `UtiliKit` as a package, each target (or Cocoapods subspec) is imported separately. The full list of libraries is: `GeneralUtilities`, `Instantiation`, `TimelessDate`, `Versioning`, `ContainerViewController`, `ActiveLabel`, `Obfuscation`. `UtiliKit` remains as a possible library which will import all the above targets at once.
[Will McGinty](https://github.com/willmcginty)
[#104](https://github.com/BottleRocketStudios/iOS-UtiliKit/pull/104)

##### Bug Fixes

* None

## 1.7.0 (2020-08-17)

##### Enhancements

* Make it possible to override functions in container, which aid in `ManagedChild` management.
[Will McGinty](https://github.com/willmcginty)
[#87](https://github.com/BottleRocketStudios/iOS-UtiliKit/pull/87)

* Add `postTransitionBehavior` to `ContainerViewController`, automating some common child management scenarios
[Dimitar Milinski](https://github.com/dmilinski)
[#88](https://github.com/BottleRocketStudios/iOS-UtiliKit/pull/88)

* Switch `removeAllNonVisibleChildren` to `public`
[Dimitar Milinski](https://github.com/dmilinski)
[#90](https://github.com/BottleRocketStudios/iOS-UtiliKit/pull/90)

* Add `ScrollingPageControl`
[Nathan Chiu](https://github.com/BR-Nathan-Chiu)
[#95](https://github.com/BottleRocketStudios/iOS-UtiliKit/pull/95)

##### Bug Fixes

* None


## 1.6.1 (2019-10-04)

##### Enhancements

* None

##### Bug Fixes

* Fix an issue where the completion handler does not get called when transitioning.
[Will McGinty](https://github.com/willmcginty)
[#76](https://github.com/BottleRocketStudios/iOS-UtiliKit/pull/76)

* Fix an issue where the transition was mistakenly marked as a failure.
[Will McGinty](https://github.com/willmcginty)
[#77](https://github.com/BottleRocketStudios/iOS-UtiliKit/pull/77)

* Fix a transitionting issue where appearance callbacks were unbalanced in iOS 13.
[Will McGinty](https://github.com/willmcginty)
[#79](https://github.com/BottleRocketStudios/iOS-UtiliKit/pull/79)

* Fix an issue where ContainerViewController was not removing source or destination views from the view hierarchy after transitioning
[Dimitar Milinski](https://github.com/dmilinski)
[#81](https://github.com/BottleRocketStudios/iOS-UtiliKit/pull/81)

## 1.6.0 (2019-08-29)

##### Enhancements

* Added Swift Package Manager support.
[Brian Miller](https://github.com/jobsismyhomeboy)
[#64](https://github.com/BottleRocketStudios/iOS-UtiliKit/issues/64)

* Add interactive transitioning and transition coordination to `ContainerViewController`. This change has bumped the deployment target to iOS 10.0+
[Will McGinty](https://github.com/willmcginty)
[#63](https://github.com/BottleRocketStudios/iOS-UtiliKit/pull/63)

* Added the `Obfuscation` subspec, which includes the `ObfuscatedKey` structure for keys/passwords to ensure that
they don't appear in plaintext within the source or binary of your app.
[Russell Mirabelli](https://github.com/rmirabelli)
[#67](https://github.com/BottleRocketStudios/iOS-UtiliKit/pull/67)

* Updated initial/named view controller example so that the buttons are horizontally centered in the stack view.
[Tyler Milner](https://github.com/tylermilner)
[#65](https://github.com/BottleRocketStudios/iOS-UtiliKit/pull/65)

* Conform URL to ExpressibleByStringLiteral (e.g. `let url: URL = "www.apple.com"`)
[Will McGinty](https://github.com/willmcginty)
[#66](https://github.com/BottleRocketStudios/iOS-UtiliKit/pull/66)

* Added Carthage support.
[Ryan Gant](https://github.com/ganttastic)
[#68](https://github.com/BottleRocketStudios/iOS-UtiliKit/pull/68)

* Updated `README` to include the "ActiveLabel" subspec listed at the top and added code examples for the "General" subspec.
[Tyler Milner](https://github.com/tylermilner)
[#71](https://github.com/BottleRocketStudios/iOS-UtiliKit/pull/71)

##### Bug Fixes

* None


## 1.5.0 (2019-07-11)

##### Enhancements

* Add `ActiveLabel` class to help show activity on a label.
[Brian Miller](https://github.com/JobsIsMyHomeboy)
[#55](https://github.com/BottleRocketStudios/iOS-UtiliKit/pull/55)

* Add support for `Configurable` types when dequeuing reusable views.
[Will McGinty](https://github.com/willmcginty)
[#53](https://github.com/BottleRocketStudios/iOS-UtiliKit/pull/58)

##### Bug Fixes

* Fix a bug where completion wasn't always called when transitioning.
[Will McGinty](https://github.com/willmcginty)
[#57](https://github.com/BottleRocketStudios/iOS-UtiliKit/pull/57)


## 1.4.0 (2019-04-30)

##### Enhancements

* Migrate to Swift 5.0.
[Earl Gaspard](https://github.com/earlgaspard)
[#53](https://github.com/BottleRocketStudios/iOS-UtiliKit/pull/53)

##### Bug Fixes

* Fix an issue where right and bottom insets were being inverted in constraints.
[Will McGinty](https://github.com/willmcginty)
[#46](https://github.com/BottleRocketStudios/iOS-UtiliKit/pull/50)


## 1.3.5 (2019-01-02)

##### Enhancements

* None.

##### Bug Fixes

* Handle another case of transitioning pre-load.
[Will McGinty](https://github.com/willmcginty)
[#46](https://github.com/BottleRocketStudios/iOS-UtiliKit/pull/46)


## 1.3.4 (2018-12-19)

##### Enhancements

* Make interface of `UICollectionView.SupplementaryElementKind` public.
[Will McGinty](https://github.com/willmcginty)
[#42](https://github.com/BottleRocketStudios/iOS-UtiliKit/pull/42)

* Add init?(kind:) initializer to `UICollectionView.SupplementaryElementKind`.
[Will McGinty](https://github.com/willmcginty)
[#41](https://github.com/BottleRocketStudios/iOS-UtiliKit/pull/41)

##### Bug Fixes

* Allow calls to `transitionToController` before the view loads to have an effect at load time
[Will McGinty](https://github.com/willmcginty)
[#43](https://github.com/BottleRocketStudios/iOS-UtiliKit/pull/43)


## 1.3.3 (2018-10-25)

##### Enhancements

* Add indexOfChild(preceding:) function.
[Will McGinty](https://github.com/willmcginty)
[#36](https://github.com/BottleRocketStudios/iOS-UtiliKit/pull/36)

##### Bug Fixes

* None.


## 1.3.2 (2018-09-19)

##### Enhancements

* Updated project for Xcode 10.
  [Tyler Milner](https://github.com/tylermilner)
  [#35](https://github.com/BottleRocketStudios/iOS-UtiliKit/pull/35)

* Updated Travis-CI image to Xcode 9.4.
  [Tyler Milner](https://github.com/tylermilner)
  [#33](https://github.com/BottleRocketStudios/iOS-UtiliKit/pull/33)

##### Bug Fixes

* None.


## 1.3.1 (2018-08-17)

##### Enhancements

* Add out-of-box support for Swift 4.2.
  [Tyler Milner](https://github.com/tylermilner)
  [#30](https://github.com/BottleRocketStudios/iOS-UtiliKit/pull/30)

* Abstract Child into ManagedChild protocol to be adopted by custom child types.
  [Cuong Leo Ngo](https://github.com/ngocholo)
  [#29](https://github.com/BottleRocketStudios/iOS-UtiliKit/pull/29)

* Add some small but useful features to the container.
  [Will McGinty](https://github.com/wmcginty)
  [#28](https://github.com/BottleRocketStudios/iOS-UtiliKit/pull/28)

##### Bug Fixes

* None.


## 1.3.0 (2018-07-18)

##### Enhancements

* Add some API to effectively search through the children of the container (for example, when wanting to move to the 'next' child).
  [Will McGinty](https://github.com/wmcginty)
  [#25](https://github.com/BottleRocketStudios/iOS-UtiliKit/pull/25)

##### Bug Fixes

* None.


## 1.2.3 (2018-06-28)

##### Enhancements

* Double-bump podspec version number.
  [Russell Mirabelli](https://github.com/rmirabelli)
  [#24](https://github.com/BottleRocketStudios/iOS-UtiliKit/pull/24)

##### Bug Fixes

* None.


## 1.2.2 (2018-06-28)

##### Enhancements

* None.

##### Bug Fixes

* Fix namespace collision with "children", renamed from "childviewcontrollers" in Xcode 10.
  [Russell Mirabelli](https://github.com/rmirabelli)
  [#22](https://github.com/BottleRocketStudios/iOS-UtiliKit/issues/22)
  [#23](https://github.com/BottleRocketStudios/iOS-UtiliKit/pull/23)


## 1.2.1 (2018-05-08)

##### Enhancements

* Add Configurable protocol (and UIStoryboard extension).
  [Will McGinty](https://github.com/wmcginty)
  [#18](https://github.com/BottleRocketStudios/iOS-UtiliKit/pull/18)

* Update CLA URL.
  [Will McGinty](https://github.com/wmcginty)
  [#16](https://github.com/BottleRocketStudios/iOS-UtiliKit/issues/16)
  [#17](https://github.com/BottleRocketStudios/iOS-UtiliKit/pull/17)

##### Bug Fixes

* None.


## 1.2.0 (2018-04-02)

##### Enhancements

* Reorganized project structure.
  [Wilson Turner](https://github.com/WSTurner)
  [#11](https://github.com/BottleRocketStudios/iOS-UtiliKit/pull/11)
  [#12](https://github.com/BottleRocketStudios/iOS-UtiliKit/pull/12)

* Slight naming tweaks to be more in line with standard library.
  [Will McGinty](https://github.com/wmcginty)
  [#9](https://github.com/BottleRocketStudios/iOS-UtiliKit/pull/9)

##### Bug Fixes

* Fixed some Obj-C interoperability issues.
  [Will McGinty](https://github.com/wmcginty)
  [#14](https://github.com/BottleRocketStudios/iOS-UtiliKit/pull/14)


## 1.1.0 (2018-02-14)

##### Enhancements

* Add codecov and codebeat.
  [Amanda Chappell](https://github.com/achappell)
  [#3](https://github.com/BottleRocketStudios/iOS-UtiliKit/issues/3)
  [#5](https://github.com/BottleRocketStudios/iOS-UtiliKit/pull/5)

* Add a ContainerViewController subspec.
  [Will McGinty](https://github.com/wmcginty)
  [#2](https://github.com/BottleRocketStudios/iOS-UtiliKit/pull/2)

##### Bug Fixes

* None.


## 1.0.0 (2017-12-28)

##### Initial Release

This is our initial release of UtiliKit. Enjoy!
