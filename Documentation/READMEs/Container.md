# Container

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

The container also has several delegate callbacks which can help customize its behavior. Among them, is a function which returns a UIViewControllerAnimatedTransitioning object.

``` swift
func containerViewController(_ container: ContainerViewController, animationControllerForTransitionFrom source: UIViewController, to destination: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    if useCustomAnimator, let sourceIndex = container.index(ofChild: source), let destinationIndex = container.index(ofChild: destination) {
        return WipeTransitionAnimator(withStartIndex: sourceIndex, endIndex: destinationIndex)
    }

    return nil
}
```
