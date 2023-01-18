//
//  StaticView.swift
//  MazaadyTask
//
//  Created by iMokhles on 18/01/2023.
//

import Foundation
import UIKit

class StaticView: UIViewController {
    
    @IBOutlet weak var betCollectionView: UICollectionView!
    
    @IBOutlet weak var productCollectionView: UICollectionView!

    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setCollection()
    }
    
    func setCollection() {
        betCollectionView.delegate = self
        betCollectionView.dataSource = self
        betCollectionView.register(BetCollectionViewCell.self, forCellWithReuseIdentifier: "BetCollectionViewCell")
        
        productCollectionView.delegate = self
        productCollectionView.dataSource = self
        productCollectionView.register(ProductCollectionViewCell.self, forCellWithReuseIdentifier: "ProductCollectionViewCell")
        
    }
    @IBAction func backBtnTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}

extension StaticView: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch collectionView {
            
        case betCollectionView:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BetCollectionViewCell", for: indexPath) as! BetCollectionViewCell
            
            return cell
            
        case productCollectionView:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductCollectionViewCell", for: indexPath) as! ProductCollectionViewCell
            
            return cell
            
        default:
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        switch collectionView {
            
        case betCollectionView:
            return CGSize(width: betCollectionView.frame.width, height: 45)
        case productCollectionView:
            return CGSize(width: 172, height: 222)
        default:
            return CGSize()
        }
    }
    
}
