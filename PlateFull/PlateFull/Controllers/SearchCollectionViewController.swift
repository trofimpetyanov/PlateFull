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
    
    //MARK: – Actions
    @IBAction func filtersButtonTapped(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "showFilters", sender: nil)
    }
    
    @IBAction func reloadButtonTapped(_ sender: UIBarButtonItem) {
        filteredRestaurants = restaurants
        updateSnapshot()
    }
    
    @IBSegueAction func showMap(_ coder: NSCoder, sender: Any?) -> MapViewViewController? {
        return MapViewViewController(coder: coder, restaurants: filteredRestaurants)
    }
    
    //MARK: – Data Source
    private func createDataSource() -> DataSourceType {
        let dataSource = DataSourceType(collectionView: collectionView) { collectionView, indexPath, itemIdentifier in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SmallCollectionViewCell.cellId, for: indexPath) as? SmallCollectionViewCell else { return UICollectionViewCell() }
            
            cell.configureCell(with: itemIdentifier)
            
            return cell
        }
        
        return dataSource
    }
    
    //MARK: – Layout
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
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showDetailRestaurant", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let detailRestaurantViewController = segue.destination as? DetailRestaurantViewController, let selectedIndexPath = collectionView.indexPathsForSelectedItems?.first, let restaurant = dataSource.itemIdentifier(for: selectedIndexPath) else { return }
        
        detailRestaurantViewController.restaurant = restaurant
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
    
    @IBAction func unwindFromFiltersCollectionViewController(segue: UIStoryboardSegue) {
        if segue.identifier == "applyUnwind", let filtersCollectionViewController = segue.source as? FiltersCollectionViewController {
        
        let filters = filtersCollectionViewController.filters
        filteredRestaurants = restaurants
        
        if !filters.dietaryRestrictions.isEmpty {
            filteredRestaurants = filteredRestaurants.filter { restaurant in
                var isCandidate = true
                
                for dietaryRestriction in filters.dietaryRestrictions {
                    if !restaurant.dietaryRestrictions.contains(dietaryRestriction) {
                        isCandidate = false
                    }
                }
                
                return isCandidate
            }
        }
        
        if !filters.prices.isEmpty {
            filteredRestaurants = filteredRestaurants.filter { filters.prices.contains($0.price) }
        }
        
        if !filters.cuisines.isEmpty {
            filteredRestaurants = filteredRestaurants.filter { filters.cuisines.contains($0.cuisine) }
        }
        
        updateSnapshot()
        } else if segue.identifier == "clearUnwind" {
            filteredRestaurants = restaurants
            updateSnapshot()
        }
    }
}
