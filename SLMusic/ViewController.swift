//
//  ViewController.swift
//  SLMusic
//
//  Created by Björn Åhström on 2019-04-29.
//  Copyright © 2019 Björn Åhström. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var label: UILabel!

    @IBOutlet weak var textField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        label.text = "Välkommen! Tryck på knappen"
        
    }

    @IBAction func button(_ sender: UIButton) {
        label.text = textField.text
    }
    
}

