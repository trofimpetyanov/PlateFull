//
//  FiltersCollectionViewController.swift
//  PlateFull
//
//  Created by Trofim Petyanov on 24.07.2022.
//

import UIKit

class FiltersCollectionViewController: UICollectionViewController {
    typealias DataSourceType = UICollectionViewDiffableDataSource<ViewModel.Section, ViewModel.Item>
    
    // MARK: – View Model
    enum ViewModel {
        enum Section: Hashable {
            case dietaryRestrictions
            case prices
            case cuisines
        }
        
        enum Item: Hashable {
            case dietaryRestriction(_ dietaryRestriction: DietaryRestrictionOptions)
            case price(_ price: Price)
            case cuisine(_ cuisine: Cuisine)
            
            static func == (lhs: FiltersCollectionViewController.ViewModel.Item, rhs: FiltersCollectionViewController.ViewModel.Item) -> Bool {
                switch (lhs, rhs) {
                case (.dietaryRestriction(let lhsDietaryRestriction), .dietaryRestriction(let rhsDietaryRestriction)):
                    return lhsDietaryRestriction.rawValue.name == rhsDietaryRestriction.rawValue.name
                case (.price(let lhsPrice), .price(let rhsPrice)):
                    return lhsPrice == rhsPrice
                case (.cuisine(let lhsCuisine), .cuisine(let rhsCuisine)):
                    return lhsCuisine == rhsCuisine
                default:
                    return false
                }
            }
            
            func hash(into hasher: inout Hasher) {
                switch self {
                case .dietaryRestriction(let dietaryRestriction):
                    hasher.combine(dietaryRestriction)
                case .price(let price):
                    hasher.combine(price)
                case .cuisine(let cuisine):
                    hasher.combine(cuisine)
                }
            }
        }
    }
    
    enum SupplementaryViewKind {
        static let sectionHeader = "sectionHeader"
    }
    
    // MARK: – Properties
    var dataSource: DataSourceType!
    
    var filters: Filters {
        var dietaryRestrictions: [DietaryRestrictionOptions] = []
        var prices: [Price] = []
        var cuisines: [Cuisine] = []
        
        guard let selectedIndexPaths = collectionView.indexPathsForSelectedItems else {
            return Filters(dietaryRestrictions: [], prices: [], cuisines: [])
        }
        
        for selectedIndexPath in selectedIndexPaths {
            guard let itemIdentifier = dataSource.itemIdentifier(for: selectedIndexPath) else { continue }
            
            switch itemIdentifier {
            case .dietaryRestriction(let dietaryRestriction):
                dietaryRestrictions.append(dietaryRestriction)
            case .price(let price):
                prices.append(price)
            case .cuisine(let cuisine):
                cuisines.append(cuisine)
            }
        }
        
        return Filters(dietaryRestrictions: dietaryRestrictions, prices: prices, cuisines: cuisines)
    }
    
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
        
        collectionView.allowsMultipleSelection = true
        
        collectionView.register(SecondarySectionHeaderCollectionReusableView.self, forSupplementaryViewOfKind: SupplementaryViewKind.sectionHeader, withReuseIdentifier: SecondarySectionHeaderCollectionReusableView.reuseIdentifier)
    }
    
    //MARK: – Updates
    private func updateSnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<ViewModel.Section, ViewModel.Item>()
        
        let dietaryRestrictions = DietaryRestrictionOptions.allCases.map { ViewModel.Item.dietaryRestriction($0) }
        let prices = Price.allCases.map { ViewModel.Item.price($0) }
        let cuisines = Cuisine.allCases.map { ViewModel.Item.cuisine($0) }
        
        snapshot.appendSections([.dietaryRestrictions, .cuisines, .prices])
        snapshot.appendItems(dietaryRestrictions, toSection: .dietaryRestrictions)
        snapshot.appendItems(prices, toSection: .prices)
        snapshot.appendItems(cuisines, toSection: .cuisines)
        
        dataSource.apply(snapshot)
    }
    
    //MARK: – Actions
    @IBAction func cancelButtonTapped(_ sender: Any) {
        dismiss(animated: true)
    }
    
    // MARK: – Data Source
    private func createDataSource() -> DataSourceType {
        let dataSource = DataSourceType(collectionView: collectionView) { collectionView, indexPath, itemIdentifier in
            let section = self.dataSource.snapshot().sectionIdentifiers[indexPath.section]
            
            switch (section, itemIdentifier) {
            case (.dietaryRestrictions, .dietaryRestriction(let dietaryRestriction)):
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FilterCollectionViewCell.cellID, for: indexPath) as? FilterCollectionViewCell else { return UICollectionViewCell() }
                
                cell.configureCell(with: dietaryRestriction.rawValue)
                
                return cell
            case (.prices, .price(let price)):
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FilterCollectionViewCell.cellID, for: indexPath) as? FilterCollectionViewCell else { return UICollectionViewCell() }
                
                cell.configureCell(with: price)
                
                return cell
            case (.cuisines, .cuisine(let cuisine)):
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FilterCollectionViewCell.cellID, for: indexPath) as? FilterCollectionViewCell else { return UICollectionViewCell() }
                
                cell.configureCell(with: cuisine)
                
                return cell
            default:
                return nil
            }
        }
        
        dataSource.supplementaryViewProvider = { collectionView, kind, indexPath -> UICollectionReusableView? in
            switch kind {
            case SupplementaryViewKind.sectionHeader:
                guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SecondarySectionHeaderCollectionReusableView.reuseIdentifier, for: indexPath) as? SecondarySectionHeaderCollectionReusableView else { return nil }
                
                let section = self.dataSource.snapshot().sectionIdentifiers[indexPath.section]
                let sectionName: String
                
                switch section {
                case .dietaryRestrictions:
                    sectionName = "Dietary Restrictions"
                case .prices:
                    sectionName = "Price"
                case .cuisines:
                    sectionName = "Cuisine"
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
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .fractionalHeight(1))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(40))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 2)
            group.interItemSpacing = .fixed(spacing)
            
            let headerItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(44))
            let headerItem = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerItemSize, elementKind: SupplementaryViewKind.sectionHeader, alignment: .top)
            
            let section = NSCollectionLayoutSection(group: group)
            section.contentInsets = NSDirectionalEdgeInsets(top: spacing, leading: padding, bottom: padding, trailing: padding)
            section.interGroupSpacing = spacing
            
            section.boundarySupplementaryItems = [headerItem]
            
            return section
        }
        
        return layout
    }
}
