//
//  DropdownView.swift
//  MazaadyTask
//
//  Created by iMokhles on 17/01/2023.
//

import Foundation
import UIKit
import SnapKit

class DropdownView: UIView {
    
    var didTap: () -> Void = {}
    
    lazy var tapGesture: UITapGestureRecognizer = {
        let tap = UITapGestureRecognizer()
        tap.numberOfTapsRequired = 1
        tap.addTarget(self, action: #selector(tapped))
        return tap
    }()
    
    lazy var contentView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 8;
        view.clipsToBounds = true;
        view.layer.borderWidth = 1;
        view.layer.borderColor = UIColor.lightGray.cgColor
        return view
    }()
    
    lazy var titleView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    lazy var titleLabel: UILabel = {
        let view = UILabel()
        view.text = "Category"
        view.backgroundColor = .white
        view.textAlignment = .center
        view.adjustsFontSizeToFitWidth = true
        view.textColor = .darkGray
        view.font = .boldSystemFont(ofSize: 14)
        view.sizeToFit()
        return view
    }()
    
    lazy var arrowImageView: UIView = {
        let arrowView = UIImageView(frame: .init(x: 0, y: 0, width: 24, height: 8))
        arrowView.contentMode = .center
        arrowView.tintColor = .red
        arrowView.image = UIImage(named: "s_arrow_down");
        
        let emptyView = UIView(frame: CGRect(x: 0, y: 0, width: 24, height: 8))
        emptyView.backgroundColor = .clear
        emptyView.addSubview(arrowView)
        
        return emptyView
    }()
    
    lazy var textField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "تحديد"
        textField.rightView = arrowImageView
        textField.rightViewMode = .always
        return textField
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
        
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension DropdownView {
    private func setupUI() {
        backgroundColor = UIColor.clear
        addGestureRecognizer(tapGesture)
        setupContentView()
        setupTextField()
        setupTitleView()
        setupTitleLabel()
    }
    
    private func setupContentView() {
        addSubview(contentView)
        contentView.snp.makeConstraints { (maker) in
            maker.edges.equalToSuperview()
        }
    }
    
    private func setupTextField() {
        contentView.addSubview(textField)
        textField.snp.makeConstraints { (maker) in
            maker.center.equalToSuperview()
            maker.height.equalToSuperview()
            maker.width.equalToSuperview().offset(-25)
        }
    }
    
    private func setupTitleView() {
        addSubview(titleView)
        titleView.snp.makeConstraints { (maker) in
            maker.top.equalTo(-15)
            maker.right.equalTo(-15)
            maker.height.equalTo(30)
        }
        bringSubviewToFront(titleView)
    }
    
    private func setupTitleLabel() {
        titleView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (maker) in
            maker.height.equalToSuperview()
            maker.left.equalToSuperview().inset(10)
            maker.right.equalToSuperview().inset(10)
        }
    }
    
}

extension DropdownView {
    @objc func tapped(sender: UITapGestureRecognizer) {
        didTap()
    }
}
