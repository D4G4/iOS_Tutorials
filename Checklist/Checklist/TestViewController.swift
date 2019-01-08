//
//  ChecklistViewController.swift
//  Checklist
//
//  Created by Daksh Gargas on 07/01/19.
//  Copyright © 2019 d4Enterprises. All rights reserved.
//

import UIKit

class TestViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
}


extension TestViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1000
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChecklistItem", for: indexPath)

        if let label = cell.viewWithTag(1000) as? UILabel {
            if (indexPath.row) % 5 == 0 {
                label.text = "Take a Jog"
            } else if (indexPath.row) % 5 == 1 {
                label.text = "Watch a movie"
            } else if (indexPath.row) % 5 == 2 {
                label.text = "Code an app"
            } else if (indexPath.row) % 5 == 3 {
                label.text = "Walk the dog"
            } else if (indexPath.row) % 5 == 4 {
                label.text = "Study design patterns"
            }
        }

        return cell
    }
}

//Allow us to interact with table
extension TestViewController: UITableViewDelegate {

}

