//
//  AddItemView.swift
//  MazaadyTask
//
//  Created by iMokhles on 18/01/2023.
//

import Foundation
import UIKit
import FloatingPanel
import Toast

class AddItemView: UIViewController, FloatingPanelControllerDelegate {
    
    var ui = AddItemUI()
    
    var fpcCategories: FloatingPanelController!
    var fpcOptions: FloatingPanelController!
    
    let yearsArray: [Int] = (1900...2023).map { Int($0) }

    let mainCats = [
        OptionsData(id: 5000, name: "التصنيف", description: "تصنيف العنصر", slug: "main_option", parent: nil, list: false, type: nil, value: nil, otherValue: nil),
        OptionsData(id: 5001, name: "التصنيف الفرعي", description: "تصنيف العنصر الفرعي", slug: "main_option_2", parent: nil, list: false, type: nil, value: nil, otherValue: nil)
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .white
        setupPanel()
        setupPanelOptions()
        
        ui.fieldsArray = mainCats
        DispatchQueue.main.async { [weak self] in
            self!.ui.tableView.reloadData()
        }
    }
    
    override func loadView() {
        ui.delegate = self
//        ui.didTapGo = {
//            let storyboard = UIStoryboard(name: "StaticViewBoard", bundle: Bundle.main)
//            let sta: StaticView = storyboard.instantiateViewController(withIdentifier: "StaticView") as! StaticView
//            self.navigationController?.pushViewController(sta, animated: true)
//        }
        view = ui
    }
    
    func setupPanel() {
        fpcCategories = FloatingPanelController()
        fpcCategories.delegate = self // Optional
        let contentVC = CategoryView()
        contentVC.ui.didTapClose = { [weak self] in
            self!.hideCategoriesView()
            contentVC.ui.filtered = nil
            DispatchQueue.main.async {
                contentVC.ui.tableView.reloadData()
            }
        }
        contentVC.didSelectCategory = { [weak self] category, isMainCategories in
            if (isMainCategories) {
                PersistenceManager.saveMainCategory(category: category);
                PersistenceManager.saveSubCategory(category: nil)
                DispatchQueue.main.async {
                    self!.ui.tableView.reloadData()
                }
                self!.hideCategoriesView()
            } else {
                
                self!.ui.fieldsArray = self!.mainCats
                PersistenceManager.saveSubCategory(category: category);
                DispatchQueue.main.async {
                    self!.ui.tableView.reloadData()
                }
                self!.hideCategoriesView()
                CategoriesService.getCategoryOptions(category: category!) { res in
                    let options = try! res.get().data
                    self!.ui.fieldsArray?.append(contentsOf: options!)
                    DispatchQueue.main.async { [weak self] in
                        self!.ui.tableView.reloadData()
                    }
                }
            }
        }
        
        fpcCategories.surfaceView.appearance.cornerRadius = 25
        fpcCategories.set(contentViewController: contentVC)
        fpcCategories.track(scrollView: contentVC.ui.tableView)
        self.addChild(fpcCategories)
        
    }
    
    func setupPanelOptions() {
        fpcOptions = FloatingPanelController()
        fpcOptions.delegate = self // Optional
        let contentVC = OptionsView()
        contentVC.ui.didTapClose = { [weak self] in
            self!.hideCategoriesView()
            self!.hideOptionsView()
            contentVC.ui.filtered = nil
            DispatchQueue.main.async {
                contentVC.ui.tableView.reloadData()
            }
        }
        
        fpcOptions.surfaceView.appearance.cornerRadius = 25
        fpcOptions.set(contentViewController: contentVC)
        fpcOptions.track(scrollView: contentVC.ui.tableView)
        self.addChild(fpcOptions)
    }
    
    func showCategoriesView() {
        hideOptionsView()
        view.addSubview(fpcCategories.view)
        fpcCategories.view.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func hideCategoriesView() {
        fpcCategories.willMove(toParent: nil)
        fpcCategories.hide(animated: true) { [weak self] in
            self!.fpcCategories.view.removeFromSuperview()
            self!.fpcCategories.removeFromParent()
        }
    }
    
    func showOptionsView() {
        hideCategoriesView()
        view.addSubview(fpcOptions.view)
        fpcOptions.view.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func hideOptionsView() {
        fpcOptions.willMove(toParent: nil)
        fpcOptions.hide(animated: true) { [weak self] in
            self!.fpcOptions.view.removeFromSuperview()
            self!.fpcOptions.removeFromParent()
        }
    }
    
    func floatingPanel(_ fpc: FloatingPanelController, layoutFor newCollection: UITraitCollection) -> FloatingPanelLayout {
        return FloatingPanelStocksLayout()
    }
    
    func showYearsPicker(key: String?, completion: @escaping (String) -> Void) {
        let savedYear = (PersistenceManager.getItem(key: key) as? String ?? "2023")
        let savedIndex = yearsArray.firstIndex(of: Int(savedYear)!)
        
        let alert = UIAlertController(style: .actionSheet, title: "Year Picker", message: "Select Year")
        let pickerViewValues: [[String]] = [yearsArray.map { Int($0).description }]
        let pickerViewSelectedValue: PickerViewViewController.Index = (column: 0, row: savedIndex!)
        var selectedItem = yearsArray[pickerViewSelectedValue.row]
        alert.addPickerView(values: pickerViewValues, initialSelection: pickerViewSelectedValue) { [weak self] vc, picker, index, values in
            selectedItem = self!.yearsArray[index.row]
        }
        alert.addAction(title: "Done", style: .cancel, handler: { action in
            completion(String(selectedItem))
        })
        alert.show()
    }
    
    func showCountriesPicker(key: String?, completion: @escaping (String) -> Void) {
        let savedCountry = (PersistenceManager.getItem(key: key) as? String ?? "")
        
        let alert = UIAlertController(style: .actionSheet, title: "Country Picker", message: "Select Country")
        alert.addLocalePicker(type: .country, prevValue: LocaleInfo(country: savedCountry, code: "", phoneCode: "")) { info in
            completion(info!.country)
        }
        alert.show()
    }
}

extension AddItemView : AddItemUIDelegate {
    
    func uiDidSelect(object: OptionsData, indexPath: IndexPath) {
        if (object.id == 5000) {
            // Main Category
            didTapMainCategory()
        } else if (object.id == 5001) {
            // Sub Category
            didTapSubCategory()
        } else if (object.type == "country") {
            showCountriesPicker(key: object.slug) { country in
                PersistenceManager.saveItem(item: country, key: object.slug)
                DispatchQueue.main.async { [weak self] in
                    self!.ui.tableView.reloadData()
                }
            }
        } else if (object.type == "date") {
            showYearsPicker(key: object.slug) { year in
                PersistenceManager.saveItem(item: year, key: object.slug)
                DispatchQueue.main.async { [weak self] in
                    self!.ui.tableView.reloadData()
                }
            }
        } else {
            didTapAnOption(optionDat: object, indexPath: indexPath)
        }
    }
    
    func didTapAnOption(optionDat: OptionsData, indexPath: IndexPath) {
        let optionsVC = fpcOptions.contentViewController as! OptionsView;
        
        var optionData = optionDat;
        let otherOption = Options(id: 5000, name: "أخر", slug: "other_slug", parent: 0, child: false)
        let unlimitedOption = Options(id: 5001, name: "غير محدد", slug: "unknown_slug", parent: 0, child: false)
        
        if !(optionData.options?.contains(where: { $0.id == otherOption.id }))! {
            optionData.options?.insert(otherOption, at: 0)
        }
        
        if !(optionData.options?.contains(where: { $0.id == unlimitedOption.id }))! {
            optionData.options?.insert(unlimitedOption, at: 1)
        }
        
        optionsVC.didSelectOption = { [weak self] option1 in
            PersistenceManager.saveOption(option: option1, key: optionData.slug)
            if (option1?.slug == "other_slug") {
                self!.toggleTextCellAfterIndex(curIndex: indexPath.section, parentOption: optionData)
                return
            }
            self!.removeOtherFieldData(curIndex: indexPath.section, parentOption: optionData)
            DispatchQueue.main.async { [weak self] in
                self!.ui.tableView.reloadData()
            }
            self!.hideOptionsView()
        }
        optionsVC.ui.titleLabel.text = optionData.name
        optionsVC.ui.parentData = optionData
        optionsVC.ui.objects = optionData.options
        DispatchQueue.main.async {
            optionsVC.ui.tableView.reloadData()
        }
        showOptionsView()
        fpcOptions.show(animated: true) { [weak self] in
            self!.fpcOptions.didMove(toParent: self)
        }
    }
    
    func toggleTextCellAfterIndex(curIndex: Int, parentOption: OptionsData) {
        let optionData = OptionsData(id: 5005, name: "هنا", description: "تحديد يدوي", slug: "manually_\(parentOption.slug ?? "")", parent: nil, list: false, type: "manually", value: "", otherValue: nil)
        
        if !(ui.fieldsArray?.contains(where: { $0.slug == optionData.slug }))! {
            ui.fieldsArray?.insert(optionData, at: curIndex+1)
        }

        DispatchQueue.main.async { [weak self] in
            self!.ui.tableView.reloadData()
        }
        hideOptionsView()
    }
    
    func removeOtherFieldData(curIndex: Int, parentOption: OptionsData) {
        let optionData = OptionsData(id: 5005, name: "هنا", description: "تحديد يدوي", slug: "manually_\(parentOption.slug ?? "")", parent: nil, list: false, type: "manually", value: "", otherValue: nil)
        if (ui.fieldsArray?.contains(where: { $0.id == optionData.id }))! {
            ui.fieldsArray?.remove(at: curIndex+1)
        }
        DispatchQueue.main.async { [weak self] in
            self!.ui.tableView.reloadData()
        }
        hideOptionsView()
    }
    
    func didTapMainCategory() {
        let categoriesVC = fpcCategories.contentViewController as! CategoryView;
        
        categoriesVC.ui.isMainCategories = true
        categoriesVC.ui.titleLabel.text = "التصنيف"
        categoriesVC.ui.loader.startAnimating()
        categoriesVC.viewModel.fetchData()
        DispatchQueue.main.async {
            categoriesVC.ui.tableView.reloadData()
        }
        showCategoriesView()
        fpcCategories.show(animated: true) { [weak self] in
            self!.fpcCategories.didMove(toParent: self)
        }
    }
    
    func didTapSubCategory() {
        let categoriesVC = fpcCategories.contentViewController as! CategoryView;
        
        let mainCategorySelected = PersistenceManager.getMainCategory();
        if ((mainCategorySelected == nil)) {
            view.hideAllToasts()
            view.makeToast("برجاء إختيار تصنيف")
        } else {
            categoriesVC.ui.objects = nil
            DispatchQueue.main.async {
                categoriesVC.ui.tableView.reloadData()
            }
            categoriesVC.ui.isMainCategories = false
            categoriesVC.ui.loader.startAnimating()
            categoriesVC.viewModel.fetchSubCategoriesData(subCategories: mainCategorySelected?.children)
            DispatchQueue.main.async {
                categoriesVC.ui.tableView.reloadData()
            }
            categoriesVC.ui.titleLabel.text = "التصنيف الفرعي"
            
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0) { [weak self] in
                self!.showCategoriesView()
                self!.fpcCategories.show(animated: true) { [weak self] in
                    self!.fpcCategories.didMove(toParent: self)
                }
            }
        }
    }
}
