//
//  OptionsView.swift
//  MazaadyTask
//
//  Created iMokhles on 17/01/2023.
//  

import UIKit

protocol OptionsViewProtocol {
    func viewWillPresent(data: [Options]?)
}

class OptionsView: UIViewController, OptionsViewProtocol {
    
    var didSelectOption: (_ option: Options?) -> Void = {option  in }

    var ui = OptionsUI()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func loadView() {
        ui.delegate = self
        view = ui
    }
    
    func viewWillPresent(data: [Options]?) {
        ui.objects = data
    }
}

extension OptionsView : OptionsUIDelegate {
    func uiDidSelect(object: Options) {
        didSelectOption(object)
    }
}
