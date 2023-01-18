//
//  CategoryUI.swift
//  MazaadyTask
//
//  Created iMokhles on 16/01/2023.
//

import UIKit
import SnapKit
import NVActivityIndicatorView

protocol CategoryUIDelegate {
    func uiDidSelect(objects: Category?, isMainCategories: Bool)
}

class CategoryUI : UIView {
    var delegate: CategoryUIDelegate!
    
    var isMainCategories: Bool = true

    var objects : [Category]?
    var filtered : [Category]?
    var cellIdentifier = "CategoryCellId"
    
    var didTapClose: () -> Void = {}

    lazy var loader: NVActivityIndicatorView = {
        let loader = NVActivityIndicatorView(frame: .zero, type: .ballScale, color: .red, padding: 0)
        loader.translatesAutoresizingMaskIntoConstraints = false
        return loader
    }()
    
    lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.text = "Main Category"
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        return titleLabel
    }()
    
    lazy var closeButton: UIButton = {
        let button = UIButton(type: .close)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isEnabled = true
        button.addTarget(self, action: #selector(closeTapped), for: .touchUpInside)

        return button
    }()
    
    lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.delegate = self
        searchBar.placeholder = "بحث"
        searchBar.searchBarStyle = .minimal
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        return searchBar
    }()
    lazy var tableView : UITableView = {
        let tbl = UITableView()
        tbl.delegate = self
        tbl.dataSource = self
        tbl.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        tbl.translatesAutoresizingMaskIntoConstraints = false
        tbl.layoutMargins = .init(top: 0.0, left: 20, bottom: 0.0, right: 20)
        tbl.separatorInset = tbl.layoutMargins
        return tbl
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUIElements()
        setupConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
    }
}

extension CategoryUI {

    private func setupUIElements() {
        // arrange subviews
        backgroundColor = .white
        addSubview(loader)
        addSubview(closeButton)
        addSubview(titleLabel)
        addSubview(searchBar)
        addSubview(tableView)
    }
    
    private func setupConstraints() {
        // add constraints to subviews
        loader.snp.makeConstraints { maker in
            maker.center.equalToSuperview()
            maker.height.equalTo(40)
            maker.width.equalTo(40)
        }
        closeButton.snp.makeConstraints { maker in
            maker.top.equalTo(25)
            maker.left.equalToSuperview().inset(20)
        }
        
        titleLabel.snp.makeConstraints { maker in
            maker.top.equalTo(30)
            maker.centerX.equalToSuperview()
        }
        
        searchBar.snp.makeConstraints { maker in
            maker.top.equalTo(titleLabel.snp.bottom).offset(20)
            maker.left.equalToSuperview().inset(10)
            maker.right.equalToSuperview().inset(10)
        }
        
        tableView.snp.makeConstraints { maker in
            maker.top.equalTo(searchBar.snp.bottom)
            maker.left.equalToSuperview()
            maker.right.equalToSuperview()
            maker.bottom.equalToSuperview().inset(20)
        }
    }
    
    @objc func closeTapped(sender: UIButton) {
        didTapClose()
    }
    
}

extension CategoryUI: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if filtered != nil {
            return self.filtered?.count ?? 0
        }
        return self.objects?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        if (self.objects != nil) {
            var category = self.objects![indexPath.row];
            if filtered != nil {
                category = self.filtered![indexPath.row];
            }
            cell.textLabel?.text = category.name
            
            let mainCat = PersistenceManager.getMainCategory();
            let subCat = PersistenceManager.getSubCategory();

            if (isMainCategories) {
                cell.accessoryType = (mainCat != nil && mainCat?.id == category.id) ? .checkmark : .none
            } else {
                cell.accessoryType = (subCat != nil && subCat?.id == category.id) ? .checkmark : .none
            }
        }
        

        return cell
    }
}

extension CategoryUI: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true);
        if filtered != nil {
            delegate?.uiDidSelect(objects: self.filtered![indexPath.row], isMainCategories: isMainCategories)
        } else {
            delegate?.uiDidSelect(objects: self.objects![indexPath.row], isMainCategories: isMainCategories)
        }
    }
}

extension CategoryUI: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print("searchText: ", searchText)
        if searchText.isEmpty {
            filtered = nil
            DispatchQueue.main.async { [weak self] in
                self!.tableView.reloadData()
            }
        } else {
            filtered = objects?.filter({($0.name?.contains(searchText))!})
            DispatchQueue.main.async { [weak self] in
                self!.tableView.reloadData()
            }
        }
    }
}


