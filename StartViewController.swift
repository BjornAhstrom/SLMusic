//
//  StartViewController.swift
//  SLMusic
//
//  Created by joakim lundberg on 2019-04-29.
//  Copyright © 2019 Björn Åhström. All rights reserved.
//

import UIKit

class StartViewController: UIViewController {
    
    @IBOutlet weak var fromStation: UITextField!
    @IBOutlet weak var toStation: UITextField!
    @IBOutlet weak var timePicker: UIDatePicker!
    @IBOutlet weak var search: UIButton!
    
    

    override func viewDidLoad() {
        let urlString = URL(string: "https://api.resrobot.se/v2/departureBoard.json?key=9ee1eedf-83c1-4b59-9b1c-826935605b24&id=740000001&date=2019-04-30&time=12:10&passlist=0")
        if let url = urlString {
            let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    print(error)
                } else {
                    if let usableData = data {
                        print(usableData) //JSONSerialization
                    }
                }
            }
            task.resume()
        }
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
