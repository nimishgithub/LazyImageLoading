//
//  SearchViewController.swift
//  FlickrImageSearch
//
//  Created by Nimish Sharma on 22/08/20.
//  Copyright © 2020 Nimish Sharma. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {
    
    //    MARK: Outlets
    @IBOutlet var collectionView: UICollectionView!
    
    //    MARK: Properties
    private let viewModel = SearchViewModel()
    
    private let searchController = UISearchController(searchResultsController: nil)
    
    //    MARK: Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSearchController()
        setupCollectionView()
        viewModel.didLoadNewResults = {
            self.collectionView.reloadData()
        }
    }
    
    //    MARK: Private Methods
    private func setupSearchController() {
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Images"
        navigationItem.searchController = searchController
        definesPresentationContext = true
        searchController.searchBar.delegate = self
    }
    
    private func setupCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.registerCell(with: ImageCell.self)
        collectionView?.backgroundColor = .clear
        collectionView?.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
    
    private func filterContentForSearchText(_ searchText: String) {
        viewModel.reset()
        viewModel.searchString = searchText
        viewModel.fetchImageResults(searchText)
    }
    
}

//    MARK: CollectionView DataSource
extension SearchViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return viewModel.searchResults.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueCell(with: ImageCell.self, indexPath: indexPath)
        return cell
    }
}

//    MARK: CollectionView Delegate
extension SearchViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let lastRowIndex = collectionView.numberOfItems(inSection: 0) - 1
        if indexPath.row == lastRowIndex && (viewModel.currentPage != 0){
            viewModel.loadNextBatch()
        }
        let photo = viewModel.searchResults[indexPath.item]
        (cell as! ImageCell).populateData(photo)
        ImageDownloadManager.shared.downloadImage(photo, indexPath: indexPath) { (image, url, indexPath, error) in
            if let aIndexPath = indexPath {
                DispatchQueue.main.async {
                    if let cell = collectionView.cellForItem(at: aIndexPath) {
                        (cell as! ImageCell).titleIV.image = image
                    }
                }
            }
        }
    }
    
}

// MARK: CollectionView Delegate FlowLayout
extension SearchViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let insets = collectionView.contentInset
        let paddingSpace = insets.left * 3
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / 2
        return CGSize(width: widthPerItem * 0.92, height: widthPerItem)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return collectionView.contentInset
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return collectionView.contentInset.left
    }

}

//    MARK: UISearchbar Delegate
extension SearchViewController: UISearchBarDelegate {
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        guard let searchText = searchBar.text, !searchText.isEmpty else {
            return
        }
        filterContentForSearchText(searchText)
    }
}
