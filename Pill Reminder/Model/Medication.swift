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
    var isMarked = false
    var currentUser: String?
    var uid: String?
    
    init(title: String, amount: String, date: Date) {
        self.title = title
        self.amount = amount
        self.date = date
    }
}

