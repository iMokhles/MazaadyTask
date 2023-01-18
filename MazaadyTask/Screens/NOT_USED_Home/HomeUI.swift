//
//  HomeUI.swift
//  MazaadyTask
//
//  Created by iMokhles on 16/01/2023.
//

import Foundation
import UIKit
import SnapKit

class HomeUI : UIView {
    
    var didTapMainCategory: () -> Void = {}
    var didTapSubcategory: () -> Void = {}

    lazy var scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.contentInsetAdjustmentBehavior = .never
        return scroll
    }()
    
    lazy var mainCategoryView: DropdownView = {
        let dropdown = DropdownView()
        dropdown.tag = 1001
        dropdown.titleLabel.text = "التصنيف"
        dropdown.textField.placeholder = "تحديد التصنيف"
        dropdown.textField.isEnabled = false
        dropdown.textField.text = PersistenceManager.getMainCategory()?.name
        dropdown.titleView.isHidden = (PersistenceManager.getMainCategory() == nil)
        dropdown.didTap = { [weak self] in
            print("Tapped Category")
            self!.didTapMainCategory()
        }
        return dropdown
    }()
    
    lazy var subCategoryView: DropdownView = {
        let dropdown = DropdownView()
        dropdown.tag = 1002
        dropdown.titleLabel.text = "التصنيف الفرعي"
        dropdown.textField.placeholder = "تحديد التصنيف الفرعي"
        dropdown.textField.isEnabled = false
        dropdown.textField.text = PersistenceManager.getSubCategory()?.name
        dropdown.titleView.isHidden = (PersistenceManager.getSubCategory() == nil)
        dropdown.didTap = { [weak self] in
            print("Tapped Subcategory")
            self!.didTapSubcategory()
        }
        return dropdown
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
        
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension HomeUI {
    private func setupUI() {
        backgroundColor = UIColor.white
        setupScrollView()
        setupDropdownView()
        setupConstraints()
    }
    
    private func setupDropdownView() {
        scrollView.addSubview(mainCategoryView)
        scrollView.addSubview(subCategoryView)
    }
    
    private func setupScrollView() {
        addSubview(scrollView)
    }
    
    private func setupConstraints() {
        scrollView.snp.makeConstraints { (maker) in
            maker.top.equalTo(10)
            maker.bottom.equalTo(-10)
            maker.left.equalTo(10)
            maker.right.equalTo(-10)
        }
        
        mainCategoryView.snp.makeConstraints { maker in
            maker.top.equalTo(44)
            maker.width.equalToSuperview().offset(-20)
            maker.height.equalTo(55)
            maker.centerX.equalToSuperview()
        }
        
        subCategoryView.snp.makeConstraints { maker in
            maker.top.equalTo(mainCategoryView.snp.bottom).offset(20)
            maker.width.equalToSuperview().offset(-20)
            maker.height.equalTo(55)
            maker.centerX.equalToSuperview()
        }
    }
}
