//
//  SearchViewController.swift
//  HTProject_Swift
//
//  Created by Hem1ngT4i on 2020/7/3.
//  Copyright © 2020 Hem1ngT4i. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {

    var serachVC = UISearchController(searchResultsController: SearchResultViewController(style: .plain))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
//        self.navigationController?.navigationBar.isTranslucent = false
        self.definesPresentationContext = true
        self.serachVC.dimsBackgroundDuringPresentation = false
        self.navigationItem.searchController = self.serachVC
    }
}

class SearchResultViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
    }
}
