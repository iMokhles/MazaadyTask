//
//  DropdownViewCell.swift
//  MazaadyTask
//
//  Created by iMokhles on 18/01/2023.
//

import Foundation
import UIKit
import SnapKit

class DropdownViewCell: UITableViewCell {
    
    var didTap: () -> Void = {}
    
    lazy var mainCategoryView: DropdownView = {
        let dropdown = DropdownView()
        dropdown.textField.isEnabled = false
        return dropdown
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier);
        setupUIElements()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupData(optionObject: OptionsData) {
                
        mainCategoryView.tag = optionObject.id!
        mainCategoryView.titleLabel.text = optionObject.name
        mainCategoryView.textField.placeholder = "تحديد \(optionObject.name ?? "")"
        
        if (optionObject.type == "country" || optionObject.type == "date") {
            mainCategoryView.textField.text = PersistenceManager.getItem(key: optionObject.slug) as? String
            mainCategoryView.titleView.isHidden = (PersistenceManager.getItem(key: optionObject.slug) == nil)
        } else if (optionObject.slug == "main_option") {
            mainCategoryView.textField.text = PersistenceManager.getMainCategory()?.name
            mainCategoryView.titleView.isHidden = (PersistenceManager.getMainCategory() == nil)
        } else if (optionObject.slug == "main_option_2") {
            mainCategoryView.textField.text = PersistenceManager.getSubCategory()?.name
            mainCategoryView.titleView.isHidden = (PersistenceManager.getSubCategory() == nil)
        } else if (optionObject.type == "manually") {
            mainCategoryView.textField.text = ""
            mainCategoryView.titleView.isHidden = true
            mainCategoryView.textField.rightView = nil
            mainCategoryView.textField.isEnabled = true
        }  else {
            mainCategoryView.textField.text = PersistenceManager.getOption(key: optionObject.slug)?.name
            mainCategoryView.titleView.isHidden = (PersistenceManager.getOption(key: optionObject.slug) == nil)
        }
    }
}

extension DropdownViewCell {

    private func setupUIElements() {
        contentView.addSubview(mainCategoryView)
    }
    
    private func setupConstraints() {
        mainCategoryView.didTap = { [weak self] in
            self!.didTap()
        }
        mainCategoryView.snp.makeConstraints { maker in
            maker.edges.equalToSuperview()
        }
    }
}
