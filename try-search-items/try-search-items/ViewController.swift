//
//  ViewController.swift
//  try-search-items
//
//  Created by Wataru Maeda on 2018-12-08.
//  Copyright © 2018 com.watarumaeda. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    fileprivate var all = [String]()
    fileprivate var selected = [String]()
    fileprivate var recommends = [String]()
    fileprivate var recommendsAll = [String]()
    fileprivate var remains = [String]()
    fileprivate var isSearching = false
    
    let cellId = "cellId"
    
    fileprivate lazy var searchbar: UISearchBar = {
        let search = UISearchBar()
        search.delegate = self
        search.showsScopeBar = true
        search.placeholder = "Search items"
        return search
    }()
    
    fileprivate lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.register(TableViewCell.self, forCellReuseIdentifier: cellId)
        tableView.dataSource = self
        tableView.delegate = self
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        edgesForExtendedLayout = []
        title = "Search Items"
        setupData()
        setupSearchBar()
        setupTable()
    }
}

// MARK : - Data management

extension ViewController {
    
    func setupData() {
        all = [ "a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n" ]
        recommendsAll = [ "k", "l", "m", "n" ]
        recommends = recommendsAll
        recommends.forEach { item in
            remains = all.filter({ $0 != item })
        }
    }
    
    func updateSelectedItem(item: String, indexPath: IndexPath) {
        
        if selected.count > 0 && indexPath.section == 0 {
            
            // back to the array where originaly belonged to
            recommendsAll.contains(item)
                ? recommends.append(item)
                : remains.append(item)
            
            // update item
            selected = selected.filter({ $0 != item })
            
        } else {
            selected.append(item)
            selected = Array(Set(selected)) // remove duplicate
            
            // update items
            selected.forEach { item in
                recommends = recommends.filter({ $0 != item })
                remains = remains.filter({ $0 != item })
            }
        }
        
        // update table
        tableView.reloadData()
    }
}

// MARK : - UISearchBarDelegate

extension ViewController: UISearchBarDelegate {
    
    func setupSearchBar() {
        view.addSubview(searchbar)
        searchbar.anchor(view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        isSearching = false
        searchBar.showsCancelButton = false
        view.endEditing(true)
        searchBar.text = ""
        tableView.reloadData()
    }
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        isSearching = true
        searchBar.showsCancelButton = true
        tableView.reloadData()
        return true
    }
}


// MARK: - UITableViewDelegate, UITableViewDataSource

extension ViewController: UITableViewDelegate, UITableViewDataSource {

    func setupTable() {
        view.addSubview(tableView)
        tableView.anchor(searchbar.bottomAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearching { return selected.count > 0 ? remains.count : all.count }
        if selected.count == 0 { return section == 0 ? recommends.count : remains.count }
        return section == 0 ? selected.count : remains.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return isSearching ? 1 : 2
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if isSearching { return "All items" }
        if selected.count == 0 { return section == 0 ? "Recommends" : "All items" }
        return section == 0 ? "Selected Items" :  "All items"
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellId) as? TableViewCell else {
            return UITableViewCell()
        }
        if isSearching {
            cell.label.text = selected.count > 0
                ? remains[indexPath.row]
                : all[indexPath.row]
            cell.imgView.isHidden = true
        } else if (selected.count == 0) {
            cell.label.text = indexPath.section == 0
                ? recommends[indexPath.row]
                : remains[indexPath.row]
            cell.imgView.isHidden = true
        } else {
            cell.label.text = indexPath.section == 0
                ? selected[indexPath.row]
                : remains[indexPath.row]
            cell.imgView.isHidden = indexPath.section != 0
        }
        cell.addSelectedHandler { item in
            print("selected item is \(item)")
            self.updateSelectedItem(item: item, indexPath: indexPath)
        }
        return cell
    }
}

// MARK: - TableViewCell

class TableViewCell: UITableViewCell {
    
    lazy var label: UILabel = {
        let label = UILabel()
        return label
    }()
    
    lazy var imgView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "check")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private var callback: (String) -> Void = {_ in }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initSubviews() {
        addSubview(label)
        addSubview(imgView)
        
        label.anchor(topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: 0, leftConstant: 16, bottomConstant: 0, rightConstant: 50, widthConstant: 0, heightConstant: 0)
        
        imgView.anchor(topAnchor, left: label.rightAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: 5, leftConstant: 0, bottomConstant: 5, rightConstant: 16, widthConstant: 50, heightConstant: 0)
    }
    
    func addSelectedHandler(callback: @escaping (String) -> Void = {_ in }) {
        self.callback = callback
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if selected { callback(label.text ?? "") }
    }
}