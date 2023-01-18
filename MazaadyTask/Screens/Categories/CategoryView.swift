//
//  CategoryView.swift
//  MazaadyTask
//
//  Created iMokhles on 16/01/2023.
//


import UIKit

protocol CategoryViewProtocol {
    func viewWillPresent(data: [Category]?)
}

class CategoryView: UIViewController, CategoryViewProtocol {
    
    var didSelectCategory: (_ category: Category?, _ isMainCategories: Bool) -> Void = {category,isMainCategories  in }

    var ui = CategoryUI()
    var viewModel : CategoryViewModel! = CategoryViewModel() {
        willSet {
            newValue.view = self
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func loadView() {
        viewModel = CategoryViewModel()
        ui.delegate = self
        view = ui
    }
    
    func viewWillPresent(data: [Category]?) {
        ui.objects = data
        DispatchQueue.main.async { [weak self] in
            self!.ui.tableView.reloadData()
            self!.ui.loader.stopAnimating()
        }
    }
}

extension CategoryView : CategoryUIDelegate {
    func uiDidSelect(objects object: Category?, isMainCategories: Bool) {
        didSelectCategory(object, isMainCategories)
//        viewModel.didReceiveUISelect(object: object!)
    }
}
