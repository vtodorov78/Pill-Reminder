//
//  InfoSection.swift
//  Pill Reminder
//
//  Created by Vladimir Todorov on 11.01.22.
//

import Foundation


enum InfoSection: Int, CaseIterable, CustomStringConvertible {
    
    case Options
    case Info
    
    var description: String {
        switch self {
        case .Options: return "OPTIONS"
        case .Info: return "INFO"
        }
    }
}


enum MedicationOptions: Int, CaseIterable, CustomStringConvertible {
    case take
    case edit
    case delete
    
    var description: String {
        switch self {
        case .take: return "Take medication"
        case .edit: return "Edit"
        case .delete: return "Delete"
        }
    }
}

enum InfoOptions: Int, CaseIterable, CustomStringConvertible{
    case title
    case dosage
    case date
    case time
    
    
    var description: String {
        switch self {
        case .title: return "Title:"
        case .dosage: return "Dosage:"
        case .date: return "Date:"
        case .time: return "Time:"
        }
    }
    
}
