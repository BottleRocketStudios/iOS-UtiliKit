### Supplementary Views

Before a supplementary view can be rendered on the screen, it must first be dequeued. This can happen in a number of different ways. When manually conforming to `UICollectionViewDataSource`, this occurs in the `collectionView(_:viewForSupplementaryElementOfKind:at:)` function. If using a `UICollectionViewDiffableDataSource`, this occurs using the `supplementaryViewProvider`.

When implementing these methods, the `UICollectionView` will pass a `String` that represents the kind of element the collection view needs. This element kind if used to differentiate between multiple types of supplementary views, for example you might have both a section header and a section footer for a particular section.

Your collection view layout is what defines the element kind for your supplementary views. Both `UICollectionViewFlowLayout` and `UICollectionLayoutListConfiguration` use built in `String`s for headers (`UICollectionView.elementKindSectionHeader`) and footers (`UICollectionView.elementKindSectionFooter`). If you are building a custom `NSCollectionLayoutSection`, then you must define the element kind when creating either an `NSCollectionLayoutSupplementaryItem` or `NSCollectionLayoutBoundarySupplementaryItem`.

Then, when you register a class or Nib for a supplementary view, you must specify the element kind that you are creating the registration for (whether you are using `UICollectionView.SupplementaryRegistration` or the manual `register` family of methods). You *must* have at least one registration for each element kind that your layout uses.

When the collection view gets to the point where it needs to request a supplementary view for display, it will ask your data source to provide one for the given element kind it needs. For a collection view containing multiple types of supplementary views, each element kind will be requested separately. It is then your responsibility to look at the requested element kind and return a supplementary view for that element kind. It is entirely possible to have multiple `SupplementaryRegistration` or multiple re-use identifiers registered for a single element kind, but you must always ensure to match the requested element kind with the one that is returned.


### How UtiliKit Helps

UtiliKit aims to make this process as foolproof as possible. As always, there are 3 steps to correctly implementing the supplementary dequeue process- definition, registration, and dequeue. As an example, we'll walk through a case using a diffable data source and a compositional layout.

#### 1. Definition

This occurs in the layout. In our case, when we are defining our `NSCollectionLayoutSection`. For example, a badge supplementary item on each of our cells may be defined something like this, where `UtiliKit` provides a small convenience here by providing some type-safety over the `String` implementation of `UIKit`:

```swift
extension UICollectionView.ElementKind {
    static let badge = Self(rawValue: "badge-view")
}

func makeLayout() {
  let badgeItem = NSCollectionLayoutSupplementaryItem(layoutSize: .init(widthDimension: .absolute(20), heightDimension: .absolute(20)),
                                                      elementKind: .badge, containerAnchor: .init(edges: [.top, .leading]))

  let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                        heightDimension: .fractionalHeight(1))
  let item = NSCollectionLayoutItem(layoutSize: itemSize,
                                    supplementaryItems: [badgeItem])

  // rest of layout definition
}
```

#### 2. Registration

The next step is then registering the class(es) or nib(s) that will fulfill this element kind in the collection view. In this example, there is only one, that we register in `viewDidLoad`, ensuring we pass the same `UICollectionView.ElementKind` in to the registration.

```swift
collectionView.register(BadgeSupplementaryView.self, forSupplementaryViewOfKind: .badge)
```

#### 3. Dequeue

The final step occurs when the collection view first requests a supplementary view for this element kind. In our case, it will use our `supplementaryViewProvider`, which is defined below.

```swift
func supplementaryView(in collectionView: UICollectionView, for kind: String, indexPath: IndexPath) -> UICollectionReusableView? {
        let elementKind = UICollectionView.ElementKind(rawValue: kind)

        switch elementKind {
        case .badge:
            let badgeView: BadgeSupplementaryView = collectionView.dequeueReusableSupplementaryView(of: .badge, for: indexPath, configuredWith: String(Int.random(in: 0..<10)))
            return badgeView

        default: return nil
        }
    }
```

We check to see the `ElementKind` that is being requested by the `UICollectionView`, before dequeuing the appropriate view based on that kind. The re-use identifier is handled by `UtiliKit`, and so the only information required here is the `ElementKind`. In the case that we receive an `ElementKind` that we do not recognize, we will return nil from our provider. Keep in mind that regardless of what you return in this case (whether it's `nil` or `fatalError()` or even `UICollectionReusableView()`, UIKit will throw an `NSInternalInconsistencyException` if it doesn't satisfy the internal requirements for that supplementary view.

This will complete the process of implementing this supplementary view and is entirely repeatable - you can have many supplementary views for a single section (see the example project, which contains a header, footer and badge supplementary for a single section).


### Uncaught `NSInternalInconsistencyException`

A common problem that can happen when dealing with supplementary views is a crash on dequeue. Most often, the crash will be accompanied by this log:

> *** Terminating app due to uncaught exception 'NSInternalInconsistencyException', reason: 'the view returned from -collectionView:viewForSupplementaryElementOfKind:atIndexPath: does not match the element kind it is being used for. When asked for a view of element kind 'UICollectionElementKindSectionHeader' the data source dequeued a view registered for the element kind 'MyCollectionViewHeader'.'

What this message is telling you, is that the collection view asked it's data source for a supplementary view of element kind `UICollectionElementKindSectionHeader`, but was instead provided with a supplementary view of element kind `MyCollectionViewHeader`. This is an indication that the `supplementaryViewProvider` (or `collectionView(_:viewForSupplementaryElementOfKind:at:)`) is not considering the element kind when determining which supplementary view to return.
