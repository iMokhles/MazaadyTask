//
//  PersistenceManager.swift
//  MazaadyTask
//
//  Created by iMokhles on 17/01/2023.
//

import Foundation
struct PersistenceManager {
    static let defaults = UserDefaults.standard
    private init() {}
    
    static func saveItem(item: Any?, key: String?) {
        defaults.setValue(item, forKey: key!)
        defaults.synchronize()
    }
    
    static func getItem(key: String!) -> Any? {
        guard let item = defaults.object(forKey: key!) else { return nil }
        return item
    }
    
    static func saveOption(option: Options?, key: String?) {
        do {
            let encoder = JSONEncoder()
            let optionEnc = try encoder.encode(option)
            defaults.setValue(optionEnc, forKey: key!)
            defaults.synchronize()
        } catch let err {
            print(err)
        }
    }
    
    static func getOption(key: String!) -> Options? {
        guard let category = defaults.object(forKey: key!) as? Data else { return nil }
        do {
            let decoder = JSONDecoder()
            let optionDec = try decoder.decode(Options.self, from: category)
            return optionDec
        } catch _ {
            return (nil)
        }
    }
    
    static func saveMainCategory(category: Category?) {
        do {
            let encoder = JSONEncoder()
            let categoryEnc = try encoder.encode(category)
            defaults.setValue(categoryEnc, forKey: "mainCategory")
            defaults.synchronize()
        } catch let err {
            print(err)
        }
    }
    static func getMainCategory() -> Category? {
        guard let category = defaults.object(forKey: "mainCategory") as? Data else { return nil }
        do {
            let decoder = JSONDecoder()
            let categoryDec = try decoder.decode(Category.self, from: category)
            return categoryDec
        } catch _ {
            return (nil)
        }
    }
    
    static func saveSubCategory(category: Category?) {
        do {
            let encoder = JSONEncoder()
            let categoryEnc = try encoder.encode(category)
            defaults.setValue(categoryEnc, forKey: "subCategory")
            defaults.synchronize()
        } catch let err {
            print(err)
        }
    }
    static func getSubCategory() -> Category? {
        guard let category = defaults.object(forKey: "subCategory") as? Data else { return nil }
        do {
            let decoder = JSONDecoder()
            let categoryDec = try decoder.decode(Category.self, from: category)
            return categoryDec
        } catch _ {
            return (nil)
        }
    }
    
    static func saveAllCategories(categories: [Category?]?) {
        do {
            let encoder = JSONEncoder()
            let categoriesEnc = try encoder.encode(categories)
            defaults.setValue(categoriesEnc, forKey: "categories")
            defaults.synchronize()
        } catch let err {
            print(err)
        }
    }
    static func getAllCategories() -> [Category]? {
        guard let categories = defaults.object(forKey: "categories") as? Data else { return nil }
        do {
            let decoder = JSONDecoder()
            let categoriesDec = try decoder.decode([Category].self, from: categories)
            return categoriesDec
        } catch _ {
            return (nil)
        }
    }
    
}
