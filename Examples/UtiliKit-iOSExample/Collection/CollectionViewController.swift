//
//  CollectionViewController.swift
//  UtiliKit
//
//  Copyright © 2017 Bottle Rocket Studios. All rights reserved.
//

import UIKit
import UtiliKit

class CollectionViewController: UIViewController, UICollectionViewDelegate {

    // MARK: - Subtypes
    enum Section: Int, Hashable {
        case horizontalRow
        case grid
    }

    struct Item: Hashable {
        let index: Int
    }

    // MARK: - Properties
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: makeLayout())
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        return collectionView
    }()

    private lazy var diffableDataSource: UICollectionViewDiffableDataSource<Section, Item> = {
        let dataSource = UICollectionViewDiffableDataSource<Section, Item>(collectionView: collectionView, cellProvider: cell)
        dataSource.supplementaryViewProvider = supplementaryView
        return dataSource
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Register cells
        collectionView.register(ProgrammaticCell.self)
        collectionView.registerNib(for: NibDrivenCell.self)

        // Register supplementary views
        collectionView.register(BadgeSupplementaryView.self, forSupplementaryViewOfKind: .badge)
        collectionView.register(ProgrammaticHeaderFooterView.self, forSupplementaryViewOfKind: .sectionHeader)
        collectionView.registerNib(forSupplementaryView: NibDrivenHeaderFooterView.self, of: .sectionFooter)

        // Register decoration views with the layout
        collectionView.collectionViewLayout.register(BlueDecorationView.self)
        collectionView.collectionViewLayout.register(YellowDecorationView.self)

        // Configure the collectionView and apply a snapshot
        view.addSubview(collectionView)

        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        snapshot.appendSections([.horizontalRow, .grid])
        snapshot.appendItems((0..<15).map { Item(index: $0) }, toSection: .horizontalRow)
        snapshot.appendItems((15..<30).map { Item(index: $0) }, toSection: .grid)
        diffableDataSource.apply(snapshot, animatingDifferences: false)
    }
}

// MARK: - Content Providers
extension CollectionViewController {

    func cell(in collectionView: UICollectionView, for indexPath: IndexPath, item: Item) -> UICollectionViewCell? {
        if item.index % 2 == 0 {
            let cell: ProgrammaticCell = collectionView.dequeueReusableCell(for: indexPath, configuredWith: .init(backgroundColor: .green))
            return cell
        } else {
            let cell: NibDrivenCell = collectionView.dequeueReusableCell(for: indexPath, configuredWith: .init(backgroundColor: .purple))
            return cell
        }
    }

    func supplementaryView(in collectionView: UICollectionView, for kind: String, indexPath: IndexPath) -> UICollectionReusableView? {
        let elementKind = UICollectionView.ElementKind(rawValue: kind)

        switch elementKind {
        case .badge:
            let badgeView: BadgeSupplementaryView = collectionView.dequeueReusableSupplementaryView(of: .badge,
                                                                                                    for: indexPath, configuredWith: String(Int.random(in: 0..<10)))
            return badgeView

        case .sectionHeader:
            let headerView: ProgrammaticHeaderFooterView = collectionView.dequeueReusableSupplementaryView(of: .sectionHeader,
                                                                                                           for: indexPath, configuredWith: .init(title: "header"))
            return headerView

        case .sectionFooter:
            let footerView: NibDrivenHeaderFooterView = collectionView.dequeueReusableSupplementaryView(of: .sectionFooter,
                                                                                                        for: indexPath, configuredWith: .init(title: "footer"))
            return footerView

        default: return nil
        }
    }
}

// MARK: - Layout Providers
extension CollectionViewController {

    func makeLayout() -> UICollectionViewLayout {
        return UICollectionViewCompositionalLayout { sectionIndex, layoutEnvironment in
            guard let section = Section(rawValue: sectionIndex) else { return nil }

            switch section {
            case .horizontalRow: return self.makeHorizontalRow(in: layoutEnvironment)
            case .grid: return self.makeGridLayout(in: layoutEnvironment)
            }
        }
    }

    // Horizontal Row of 3
    func makeHorizontalRow(in environment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection {

        let badgeItem = NSCollectionLayoutSupplementaryItem(layoutSize: .init(widthDimension: .absolute(20), heightDimension: .absolute(20)),
                                                            elementKind: .badge, containerAnchor: .init(edges: [.top, .leading], fractionalOffset: .init(x: -0.5, y: -0.5)))
        badgeItem.zIndex = .max

        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                              heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize,
                                          supplementaryItems: [badgeItem])

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                               heightDimension: .absolute(100))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 3)
        group.interItemSpacing = .fixed(10)

        let section = NSCollectionLayoutSection(group: group)
        section.decorationItems = [.background(forDecorationView: BlueDecorationView.self)]
        section.boundarySupplementaryItems = [
            .init(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(44)), elementKind: .sectionHeader, alignment: .top),
            .init(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(44)), elementKind: .sectionFooter, alignment: .bottom)
        ]
        section.interGroupSpacing = 5
        section.contentInsets = .init(top: 10, leading: 10, bottom: 10, trailing: 10)

        return section
    }

    // 1-2-1 Grid
    func makeGridLayout(in environment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                              heightDimension: .fractionalWidth(0.30))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let middleItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                    heightDimension: .fractionalHeight(1))
        let middleItem = NSCollectionLayoutItem(layoutSize: middleItemSize)

        let middleGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                     heightDimension: .fractionalWidth(0.5))
        let middleGroup = NSCollectionLayoutGroup.horizontal(layoutSize: middleGroupSize, subitem: middleItem, count: 2)
        middleGroup.interItemSpacing = NSCollectionLayoutSpacing.fixed(10)

        let finalGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                    heightDimension: .estimated(400))
        let finalGroup = NSCollectionLayoutGroup.vertical(layoutSize: finalGroupSize, subitems: [item, middleGroup, item])
        finalGroup.interItemSpacing = .fixed(10)

        let section = NSCollectionLayoutSection(group: finalGroup)
        section.decorationItems = [.background(forDecorationView: YellowDecorationView.self)]
        section.interGroupSpacing = 40
        section.contentInsets = .init(top: 10, leading: 10, bottom: 10, trailing: 10)

        return section
    }
}
