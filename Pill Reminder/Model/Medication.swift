//
//  Medication.swift
//  Pill Reminder
//
//  Created by Vladimir Todorov on 14.10.21.
//

import UIKit

class Medication {
    
    let title: String
    let amount: String
    let date: Date
    let image: UIImage
    var isMarked = false
    
    init(title: String, amount: String, date: Date, image: UIImage) {
        self.title = title
        self.amount = amount
        self.date = date
        self.image = image
    }
}

