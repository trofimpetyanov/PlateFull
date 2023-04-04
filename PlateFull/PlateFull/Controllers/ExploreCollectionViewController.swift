//
//  ExploreCollectionViewController.swift
//  PlateFull
//
//  Created by Trofim Petyanov on 24.07.2022.
//

import UIKit

class ExploreCollectionViewController: UICollectionViewController {
    typealias DataSourceType = UICollectionViewDiffableDataSource<ViewModel.Section, ViewModel.Item>
    
    // MARK: – View Model
    enum ViewModel {
        enum Section: Hashable {
            case newlyAdded
            case mostPopular
            case localsChoice
        }
        
        typealias Item = Restaurant
    }
    
    enum SupplementaryViewKind {
        static let sectionHeader = "sectionHeader"
    }
    
    // MARK: – Properties
    var dataSource: DataSourceType!
    var restaurants = DataManager.shared.restaurants
    
    // MARK: – Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        updateSnapshot()
    }
    
    //MARK: – Helpers
    private func setup() {
        dataSource = createDataSource()
        collectionView.dataSource = dataSource
        collectionView.collectionViewLayout = createLayout()
        
        collectionView.register(SectionHeaderCollectionReusableView.self, forSupplementaryViewOfKind: SupplementaryViewKind.sectionHeader, withReuseIdentifier: SectionHeaderCollectionReusableView.reuseIdentifier)
    }
    
    //MARK: – Updates
    private func updateSnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<ViewModel.Section, ViewModel.Item>()
        
        let newlyAdded = restaurants.filter { $0.isLastAdded }
        let mostPopular = restaurants.filter { $0.isPopular }
        let localsChoice = restaurants.filter { $0.isCitizensPick }
        
        snapshot.appendSections([.newlyAdded, .mostPopular, .localsChoice])
        snapshot.appendItems(newlyAdded, toSection: .newlyAdded)
        snapshot.appendItems(mostPopular, toSection: .mostPopular)
        snapshot.appendItems(localsChoice, toSection: .localsChoice)
        
        dataSource.applySnapshotUsingReloadData(snapshot)
    }
    
    // MARK: – Data Source
    private func createDataSource() -> DataSourceType {
        let dataSource = DataSourceType(collectionView: collectionView) { collectionView, indexPath, itemIdentifier in
            let section = self.dataSource.snapshot().sectionIdentifiers[indexPath.section]
            
            switch section {
            case .newlyAdded:
                guard let cell = collectionView.dequeueReusableCell(
					withReuseIdentifier: WideCollectionViewCell.cellId,
					for: indexPath
				) as? WideCollectionViewCell else { return UICollectionViewCell() }
                
                cell.configureCell(with: itemIdentifier)
                
                return cell
            case .localsChoice, .mostPopular:
                guard let cell = collectionView.dequeueReusableCell(
					withReuseIdentifier: SmallCollectionViewCell.cellId,
					for: indexPath
				) as? SmallCollectionViewCell else { return UICollectionViewCell() }
                
                cell.configureCell(with: itemIdentifier)
                
                return cell
            }
        }
        
        dataSource.supplementaryViewProvider = { collectionView, kind, indexPath -> UICollectionReusableView? in
            switch kind {
            case SupplementaryViewKind.sectionHeader:
                guard let headerView = collectionView.dequeueReusableSupplementaryView(
					ofKind: kind,
					withReuseIdentifier: SectionHeaderCollectionReusableView.reuseIdentifier,
					for: indexPath
				) as? SectionHeaderCollectionReusableView else { return nil }
                
                let section = self.dataSource.snapshot().sectionIdentifiers[indexPath.section]
                let sectionName: String
                
                switch section {
                case .newlyAdded:
					sectionName = NSLocalizedString("Newly Added", comment: "")
                case .mostPopular:
					sectionName = NSLocalizedString("Most Popular", comment: "")
                case .localsChoice:
					sectionName = NSLocalizedString("Locals Choice", comment: "")
                }
                
                headerView.setTitle(sectionName)
                
                return headerView
            default:
                return nil
            }
        }
        
        return dataSource
    }
    
    // MARK: – Layout
    private func createLayout() -> UICollectionViewCompositionalLayout {
        let spacing: CGFloat = 8
        let padding: CGFloat = 16
        
        let layout = UICollectionViewCompositionalLayout { sectionIndex, layoutEnvironment in
            switch self.dataSource.snapshot().sectionIdentifiers[sectionIndex] {
            case .newlyAdded:
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.92), heightDimension: .absolute(230))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 1)
                group.interItemSpacing = .fixed(spacing)
                
                let headerItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(44))
                let headerItem = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerItemSize, elementKind: SupplementaryViewKind.sectionHeader, alignment: .top)
                
                let section = NSCollectionLayoutSection(group: group)
                section.contentInsets = NSDirectionalEdgeInsets(top: spacing, leading: padding, bottom: padding, trailing: padding)
                section.interGroupSpacing = spacing
                section.orthogonalScrollingBehavior = .groupPaging
                
                section.boundarySupplementaryItems = [headerItem]
                
                return section
            default:
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                
                let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(300), heightDimension: .absolute(230))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 2)
                group.interItemSpacing = .fixed(spacing)
                
                let headerItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(44))
                let headerItem = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerItemSize, elementKind: SupplementaryViewKind.sectionHeader, alignment: .top)
                
                let section = NSCollectionLayoutSection(group: group)
                section.contentInsets = NSDirectionalEdgeInsets(top: spacing, leading: padding, bottom: padding, trailing: padding)
                section.interGroupSpacing = spacing
                section.orthogonalScrollingBehavior = .continuous
                
                section.boundarySupplementaryItems = [headerItem]
                
                return section
            }
        }
        
        return layout
    }
    
    //MARK: – Delegate
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showDetailRestaurant", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let detailRestaurantViewController = segue.destination as? DetailRestaurantViewController, let selectedIndexPath = collectionView.indexPathsForSelectedItems?.first, let restaurant = dataSource.itemIdentifier(for: selectedIndexPath) else { return }
        
        detailRestaurantViewController.restaurant = restaurant
    }
}

