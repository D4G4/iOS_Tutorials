//
//  ChecklistItem.swift
//  Checklist
//
//  Created by Daksh Gargas on 07/01/19.
//  Copyright © 2019 d4Enterprises. All rights reserved.
//

import Foundation

class ChecklistItem: NSObject {
    
    @objc var text = ""
    var isChecked = false

    init(text: String = "", isChecked: Bool = false) {
        self.text = text
        self.isChecked = isChecked
    }
    
    func toggleChecked() {
        isChecked = !isChecked
    }
}
