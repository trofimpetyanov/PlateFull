//
//  SearchCollectionViewController.swift
//  PlateFull
//
//  Created by Trofim Petyanov on 24.07.2022.
//

import UIKit

class SearchCollectionViewController: UICollectionViewController {
    typealias DataSourceType = UICollectionViewDiffableDataSource<ViewModel.Section, ViewModel.Item>
    
    // MARK: – View Model
    enum ViewModel {
        enum Section: Hashable {
            case restaurants
        }
        
        typealias Item = Restaurant
    }
    
    //MARK: – Properties
    var dataSource: DataSourceType!
    
    var restaurants = DataManager.shared.restaurants
    var filteredRestaurants = DataManager.shared.restaurants
    
    let searchController = UISearchController()
    
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
        
        navigationItem.searchController = searchController
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchResultsUpdater = self
        navigationItem.hidesSearchBarWhenScrolling = true
    }
    
    //MARK: – Updates
    private func updateSnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<ViewModel.Section, ViewModel.Item>()
        
        snapshot.appendSections([.restaurants])
        snapshot.appendItems(filteredRestaurants, toSection: .restaurants)
        
        dataSource.apply(snapshot)
    }
    
    // MARK: – Data Source
    private func createDataSource() -> DataSourceType {
        let dataSource = DataSourceType(collectionView: collectionView) { collectionView, indexPath, itemIdentifier in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SmallCollectionViewCell.cellId, for: indexPath) as? SmallCollectionViewCell else { return UICollectionViewCell() }
            
            cell.configureCell(with: itemIdentifier)
            
            return cell
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
            
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(230))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 2)
            group.interItemSpacing = .fixed(spacing)
           
            let section = NSCollectionLayoutSection(group: group)
            section.contentInsets = NSDirectionalEdgeInsets(top: spacing, leading: padding, bottom: padding, trailing: padding)
            section.interGroupSpacing = spacing
            
            return section
        }
        
        return layout
    }
}

extension SearchCollectionViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        if let searchString = searchController.searchBar.text, !searchString.isEmpty {
            filteredRestaurants = restaurants.filter { $0.name.localizedCaseInsensitiveContains(searchString)}
        } else {
            filteredRestaurants = restaurants
        }
        
        updateSnapshot()
    }
}
