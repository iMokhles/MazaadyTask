//
//  HomeView.swift
//  MazaadyTask
//
//  Created by iMokhles on 16/01/2023.
//

import UIKit
import FloatingPanel
import SnapKit
import Toast

class HomeView: UIViewController, FloatingPanelControllerDelegate {

    private var ui = HomeUI()
    
    let yearsArray: [Int] = (1900...2023).map { Int($0) }
    
    var fpc: FloatingPanelController!
    var fpcOptions: FloatingPanelController!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .white
        setupPanel()
        setupPanelOptions()
        let contentVC = fpc.contentViewController as! CategoryView;

        ui.didTapMainCategory = { [weak self] in
            contentVC.ui.isMainCategories = true
            contentVC.ui.titleLabel.text = "التصنيف"
            contentVC.ui.loader.startAnimating()
            contentVC.viewModel.fetchData()
            DispatchQueue.main.async {
                contentVC.ui.tableView.reloadData()
            }
            self!.showCategoriesView()
            self!.fpc.show(animated: true) {
                self!.fpc.didMove(toParent: self)
            }
        }
        ui.didTapSubcategory = { [weak self] in
            let mainCategorySelected = PersistenceManager.getMainCategory();
            if ((mainCategorySelected == nil)) {
                self!.view.hideAllToasts()
                self!.view.makeToast("Please select main category")
            } else {
                contentVC.ui.isMainCategories = false
                contentVC.ui.loader.startAnimating()
                contentVC.ui.objects = nil
                contentVC.viewModel.fetchSubCategoriesData(subCategories: mainCategorySelected?.children)
                DispatchQueue.main.async {
                    contentVC.ui.tableView.reloadData()
                }
                contentVC.ui.titleLabel.text = "التصنيف الفرعي"
                self!.showCategoriesView()
                self!.fpc.show(animated: true) {
                    self!.fpc.didMove(toParent: self)
                }
            }
        }
    }
    
    override func loadView() {
        view = ui
    }
    
    func setupPanel() {
        fpc = FloatingPanelController()
        fpc.delegate = self // Optional
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
                self!.ui.mainCategoryView.textField.text = PersistenceManager.getMainCategory()?.name
                self!.ui.mainCategoryView.titleView.isHidden = (PersistenceManager.getSubCategory() == nil)
                PersistenceManager.saveSubCategory(category: nil)
                self!.ui.subCategoryView.textField.text = PersistenceManager.getSubCategory()?.name
                self!.ui.subCategoryView.titleView.isHidden = (PersistenceManager.getSubCategory() == nil)
                self!.hideCategoriesView()
            } else {
                PersistenceManager.saveSubCategory(category: category)
                self!.ui.subCategoryView.textField.text = PersistenceManager.getSubCategory()?.name
                self!.ui.subCategoryView.titleView.isHidden = (PersistenceManager.getSubCategory() == nil)
                self!.hideCategoriesView()
                CategoriesService.getCategoryOptions(category: category!) { res in
                    let options = try! res.get().data
                    DispatchQueue.main.async { [weak self] in
                        self!.setupOptionsViews(options: options!)
                    }
                }
            }
        }
        fpc.surfaceView.appearance.cornerRadius = 25
        fpc.set(contentViewController: contentVC)
        fpc.track(scrollView: contentVC.ui.tableView)
        self.addChild(fpc)
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
        view.addSubview(fpc.view)
        fpc.view.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func hideCategoriesView() {
        fpc.willMove(toParent: nil)
        fpc.hide(animated: true) { [weak self] in
            self!.fpc.view.removeFromSuperview()
            self!.fpc.removeFromParent()
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
    
    func setupOptionsViews(options: [OptionsData]?) {
        let subViews = ui.scrollView.subviews
        for subview in subViews {
            if subview.tag != 1001 &&  subview.tag != 1002  {
                subview.removeFromSuperview()
            }
        }
        
        var yPosition = 194;
        
        for i in 0..<options!.count {
            var optionData = options![i]
//        for (index, optionData) in options! {
            let dropdown = DropdownView()
            dropdown.textField.placeholder = "تحديد \(optionData.name ?? "")"
            dropdown.titleLabel.text = optionData.name
            dropdown.textField.isEnabled = optionData.type == nil && optionData.options?.count == 0
            // Todo:: Clean Code ^_^
            if (optionData.type == "date" || optionData.type == "country") {
                dropdown.textField.text = (PersistenceManager.getItem(key: optionData.slug) as! String)
            } else {
                dropdown.textField.text = PersistenceManager.getOption(key: optionData.slug)?.name
            }
            if (optionData.type == "date" || optionData.type == "country") {
                dropdown.titleView.isHidden = PersistenceManager.getItem(key: optionData.slug) == nil
            } else {
                dropdown.titleView.isHidden = PersistenceManager.getOption(key: optionData.slug) == nil
            }
            
            dropdown.didTap = { [weak self] in
                
                let otherOption = Options(id: 5000, name: "أخر", slug: "other_slug", parent: 0, child: false)
                let unlimitedOption = Options(id: 5001, name: "غير محدد", slug: "unlimited_slug", parent: 0, child: false)
                
                if !(optionData.options?.contains(where: { $0.id == otherOption.id }))! {
                    optionData.options?.insert(otherOption, at: 0)
                }
                
                if !(optionData.options?.contains(where: { $0.id == unlimitedOption.id }))! {
                    optionData.options?.insert(unlimitedOption, at: 1)
                }

                if (optionData.type == "date") {
                    
                    self!.showYearsPicker(key: optionData.slug) { year in
                        PersistenceManager.saveItem(item: year, key: optionData.slug)
                        dropdown.textField.text = (PersistenceManager.getItem(key: optionData.slug) as! String)
                        dropdown.titleView.isHidden = PersistenceManager.getItem(key: optionData.slug) == nil
                    }
                    return
                }
                
                if (optionData.type == "country") {
                    
                    self!.showCountriesPicker(key: optionData.slug) { country in
                        PersistenceManager.saveItem(item: country, key: optionData.slug)
                        dropdown.textField.text = (PersistenceManager.getItem(key: optionData.slug) as! String)
                        dropdown.titleView.isHidden = PersistenceManager.getItem(key: optionData.slug) == nil
                    }
                    return
                }
                let contentVC = self!.fpcOptions.contentViewController as! OptionsView;
                contentVC.didSelectOption = { option in
                    PersistenceManager.saveOption(option: option, key: optionData.slug)
                    dropdown.textField.text = PersistenceManager.getOption(key: optionData.slug)?.name
                    dropdown.titleView.isHidden = PersistenceManager.getOption(key: optionData.slug) == nil
                    self!.hideOptionsView()
                    self!.toggleOtherDropdown(option: option, optionIndex: i)
                }
                contentVC.ui.titleLabel.text = optionData.name
                contentVC.ui.objects = optionData.options
                DispatchQueue.main.async {
                    contentVC.ui.tableView.reloadData()
                }
                self!.showOptionsView()
                self!.fpcOptions.show(animated: true) {
                    self!.fpcOptions.didMove(toParent: self)
                }
            }
            ui.scrollView.addSubview(dropdown)
            dropdown.snp.makeConstraints { maker in
                maker.top.equalTo(yPosition)
                maker.width.equalToSuperview().offset(-20)
                maker.height.equalTo(55)
                maker.centerX.equalToSuperview()
            }
            yPosition += 55 + 20
        }
        
        ui.scrollView.contentSize = CGSize(width: 0, height: yPosition)
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
    
    func toggleOtherDropdown(option: Options?, optionIndex: Int?) {
        print("optionIndex: ", optionIndex)
        if (option?.id == 5000) {
            let dropdown = DropdownView()
            dropdown.textField.placeholder = "حدد هنا"
            dropdown.titleView.isHidden = true
            dropdown.textField.isEnabled = true
            dropdown.textField.leftView = nil
            dropdown.textField.rightView = nil

            var yPosition = 75*ui.scrollView.subviews.count
            let itemOption = ui.scrollView.subviews.item(at: (optionIndex!)+2)
            let itemOptionToUpdate = ui.scrollView.subviews.item(at: ((optionIndex!)+2)+1)
            ui.scrollView.addSubview(dropdown)
            dropdown.snp.makeConstraints { maker in
                maker.top.equalTo(yPosition)
                maker.width.equalToSuperview().offset(-20)
                maker.height.equalTo(55)
                maker.centerX.equalToSuperview()
            }
            yPosition += 75
            itemOptionToUpdate?.snp.updateConstraints({ maker in
                maker.top.equalTo(yPosition)
            })
            ui.scrollView.contentSize = CGSize(width: 0, height: yPosition)
        }
    }
    func floatingPanel(_ fpc: FloatingPanelController, layoutFor newCollection: UITraitCollection) -> FloatingPanelLayout {
        return FloatingPanelStocksLayout()
    }
}

