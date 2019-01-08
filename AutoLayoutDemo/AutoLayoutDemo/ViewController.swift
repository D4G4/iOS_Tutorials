//
//  ViewController.swift
//  AutoLayoutDemo
//
//  Created by Daksh Gargas on 31/12/18.
//  Copyright © 2018 Daksh Gargas. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    @IBAction func buttonTapped(_ sender: UIButton){
        if sender.title(for: .normal) == "X" {
            sender.setTitle("A very long title for this button", for: .normal)
        } else {
            sender.setTitle("X", for: .normal)
        }
    }

}

