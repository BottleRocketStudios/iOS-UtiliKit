# General

## FileManager Extensions

There are several convenience methods provided as an extension on `FileManager`:

```swift
let documentsDirectory = FileManager.default.documentsDirectory
let cachesDirectory = FileManager.default.cachesDirectory
let appSupportDirectory = FileManager.default.applicationSupportDirectory
let sharedContainerURL = FileManager.default.sharedContainerURL(forSecurityApplicationGroupIdentifier: "com.app.group")
```

## UIView Extensions

There are several convenience methods provided as an extension on `UIView`, mostly for easily constraining subviews to their parent view:

```swift
let myView = UIView(frame: .zero)
view.addSubview(myView, constrainedToSuperview: true)

let anotherView = UIView(frame: .zero)
anotherView.translatesAutoresizingMaskIntoConstraints = false
view.addSubview(anotherView)

let insets = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
anotherView.constrainEdgesToSuperview(with: insets)
```
