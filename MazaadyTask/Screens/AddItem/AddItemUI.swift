//
//  AddItemUI.swift
//  MazaadyTask
//
//  Created by iMokhles on 18/01/2023.
//

import Foundation
import UIKit
import SnapKit

protocol AddItemUIDelegate {
    func uiDidSelect(object: OptionsData, indexPath: IndexPath)
}

class AddItemUI : UIView {
    var delegate: AddItemUIDelegate!
    
    var fieldsArray : [OptionsData]?
    var cellIdentifier = "OptionsDataCellId"
    
    var didTapGo: () -> Void = {}

    lazy var goButton: UIButton = {
        let button = UIButton(type: .roundedRect)
        button.setTitle("Go Static", for: .normal)
        button.addTarget(self, action: #selector(goTapped), for: .touchUpInside)
        return button
    }()
    lazy var tableView : UITableView = {
        let tbl = UITableView()
        tbl.delegate = self
        tbl.dataSource = self
        tbl.register(DropdownViewCell.self, forCellReuseIdentifier: cellIdentifier)
        tbl.translatesAutoresizingMaskIntoConstraints = false
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

extension AddItemUI {

    private func setupUIElements() {
        backgroundColor = .white
        addSubview(tableView)
        addSubview(goButton)
    }
    
    private func setupConstraints() {
        tableView.snp.makeConstraints { maker in
            maker.edges.equalToSuperview().inset(30)
        }
        
        goButton.snp.makeConstraints { maker in
            maker.top.equalTo(tableView.snp.bottom)
            maker.bottom.equalTo(-20)
            maker.centerX.equalToSuperview()
        }
    }
    
    @objc func goTapped(sender: UIButton) {
        didTapGo()
    }
}
     
extension AddItemUI: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.fieldsArray?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as! DropdownViewCell
        cell.selectionStyle = .none
        let fieldOptions = self.fieldsArray![indexPath.section];
        cell.didTap = { [weak self] in
            if (fieldOptions.type != "manually") {
                self!.delegate?.uiDidSelect(object: fieldOptions, indexPath: indexPath)
            }
        }
        cell.setupData(optionObject: fieldOptions)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }
}

extension AddItemUI: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true);
//        let optionD = self.fieldsArray![indexPath.section]
//        print("optionD: ", optionD)
//        if (optionD.type != "manually") {
//            delegate?.uiDidSelect(object: optionD, indexPath: indexPath)
//        }
    }
}

