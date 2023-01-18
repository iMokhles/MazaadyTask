//
//  CategoryViewModel.swift
//  MazaadyTask
//
//  Created iMokhles on 16/01/2023.
//


import Foundation

protocol CategoryViewModelProtocol {
    func fetchData()
    func didReceiveUISelect(object: [Category]?)
}

class CategoryViewModel {
    var view : CategoryViewProtocol!
    var object: Category? = nil
    
    func fetchData() {
        let categories = PersistenceManager.getAllCategories();
        if (categories != nil && categories!.count > 0) {
            self.view.viewWillPresent(data: categories)
        } else {
            CategoriesService.getCategories { res in
                let cats = try! res.get().data?.categories
                PersistenceManager.saveAllCategories(categories: cats)
                self.view.viewWillPresent(data: cats)
            }
        }
        
    }
    
    func fetchSubCategoriesData(subCategories: [Category]?) {
        self.view.viewWillPresent(data: subCategories!)
    }
    
    func didReceiveUISelect(object: Category?) {
        debugPrint("Did receive UI object", object!.children)
    }
}
