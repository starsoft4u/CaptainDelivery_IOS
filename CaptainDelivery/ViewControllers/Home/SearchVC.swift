//
//  SearchVC.swift
//  CaptainDelivery
//
//  Created by Eliot Gravett on 2018/12/12.
//  Copyright © 2018 Eliot Gravett. All rights reserved.
//

import UIKit
import SwiftyAttributes
import DZNEmptyDataSet

class SearchVC: CommonVC {
    @IBOutlet weak var searchContainer: UIView!
    @IBOutlet weak var tableView: UITableView!

    var searchController: UISearchController!
    var searchText: String = ""

    var products: [Product] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        setupSearchBar()
        setup(tableView, cellClass: [ProductCell.self], pullToRefresh: false)
    }

    fileprivate func setupSearchBar() {
        definesPresentationContext = false
        searchController = UISearchController(searchResultsController: nil)
        searchController.dimsBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        searchController.searchBar.placeholder = "Search"

        searchContainer.addSubview(searchController.searchBar)

        let textFieldInsideSearchBar = searchController.searchBar.value(forKey: "searchField") as? UITextField
        textFieldInsideSearchBar?.textColor = .black
        textFieldInsideSearchBar?.tintColor = .black
        textFieldInsideSearchBar?.font = Constants.Font.Helvetica.regular.withSize(15)

        let textFieldInsideSearchBarLabel = textFieldInsideSearchBar!.value(forKey: "placeholderLabel") as? UILabel
        textFieldInsideSearchBarLabel?.textColor = .lightGray
        textFieldInsideSearchBarLabel?.font = Constants.Font.Helvetica.regular.withSize(15)
    }

    fileprivate func search() { }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension SearchVC: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ProductCell.identifier, for: indexPath) as? ProductCell else { fatalError() }

//        let product = products[indexPath.row]
        // Configure cell

        return cell
    }
}

extension SearchVC: UISearchBarDelegate, UISearchResultsUpdating {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let searchText = searchBar.text, !searchText.isEmpty {
            self.searchText = searchText
            self.search()
        }
    }

    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text {
            self.searchText = searchText
            self.search()
        }
    }
}

extension SearchVC: DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        return "No matching result"
            .withFont(Constants.Font.Helvetica.regular.withSize(15))
            .withTextColor(.lightGray)
    }
}
