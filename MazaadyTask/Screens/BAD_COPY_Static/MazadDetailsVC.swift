//
//  MazadDetailsVC.swift
//  MazaadyTask
//
//  Created by iMokhles on 18/01/2023.
//

import UIKit

class MazadDetailsVC: UIViewController {

    //MARK: - outlet
    @IBOutlet weak var otherProductcollectionView: UICollectionView!
    @IBOutlet weak var usersTableView: UITableView!
    @IBOutlet weak var sliderImageCollectionView: UICollectionView!
    @IBOutlet weak var heigthTableView: NSLayoutConstraint!
    
    //MARK: - variable
    var countUsers = 4
    
    //MARK: - view did load
    override func viewDidLoad() {
        super.viewDidLoad()


        usersTableView.register(UINib(nibName: "BiddersCell", bundle: nil), forCellReuseIdentifier: "BiddersCell")
        otherProductcollectionView.register(UINib(nibName: "ProductCell", bundle: nil), forCellWithReuseIdentifier: "ProductCell")
        heigthTableView.constant = CGFloat(70*countUsers)
    }
    

    @IBAction func backBTN(_ sender: Any) {
        self.dismiss(animated: true)
    }
    

}

//MARK: - collection View
extension MazadDetailsVC: UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        var num = 0
        if collectionView == sliderImageCollectionView{
            num = 3
        }else if collectionView == otherProductcollectionView{
            num = 5
        }
        return num
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == sliderImageCollectionView{

            let cell  = self.sliderImageCollectionView.dequeueReusableCell(withReuseIdentifier: "SliderCell", for: indexPath) as! SliderCell
            
            return cell
        }else{
            let cell  = self.otherProductcollectionView.dequeueReusableCell(withReuseIdentifier: "ProductCell", for: indexPath) as! ProductCell
            
            return cell
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: 290)
    }
    
}

//MARK: - table View

extension MazadDetailsVC:UITableViewDelegate , UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countUsers
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.usersTableView.dequeueReusableCell(withIdentifier: "BiddersCell", for: indexPath) as! BiddersCell
        
        return cell
    }
    
    
}
