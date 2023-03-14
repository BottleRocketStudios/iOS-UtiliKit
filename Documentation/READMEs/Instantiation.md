# Instantiation

## Reusable Views

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

## View Controllers

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
