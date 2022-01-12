//
//  InfoViewController.swift
//  Pill Reminder
//
//  Created by Vladimir Todorov on 11.01.22.
//

import UIKit

private let reuseIdentifier = "InfoCell"

protocol InfoViewDelegate {
    func takeMedication()
    func deleteMedication()
}

class InfoViewController: UIViewController {
    
    var delegate: InfoViewDelegate?
    
    var medicationTitle: String?
    var medicationDosage: String?
    var medicationDate: Date?
    
    
    // MARK: - Properties
    
    var tableView: UITableView!
    
    // MARK: - Init

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    

    // MARK: - Helper Functions
    
    func configureUI() {
        tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 60
        
        tableView.register(InfoCell.self, forCellReuseIdentifier: reuseIdentifier)
        view.addSubview(tableView)
        tableView.frame = view.frame
        
    }
    
    func handleTakeMedication() {
        delegate?.takeMedication()
        self.dismiss(animated: true)
    }
    
    func handleDeleteMedication() {
        delegate?.deleteMedication()
        self.dismiss(animated: true)
    }
}

extension InfoViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return InfoSection.allCases.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let section = InfoSection(rawValue: section) else { return 0 }
        
        switch section {
        case .Options: return MedicationOptions.allCases.count
        case .Info: return InfoOptions.allCases.count
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let section = InfoSection(rawValue: section) else { return ""}
        
        switch section {
        case .Options: return section.description
        case .Info: return section.description
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! InfoCell
        
        guard let section = InfoSection(rawValue: indexPath.section) else { return UITableViewCell() }
        
        switch section {
        case .Options:
            let options = MedicationOptions(rawValue: indexPath.row)
           
            if options?.description == "Take medication" {
                cell.textLabel?.text = options?.description
                cell.textLabel?.textColor = .systemGreen
                cell.imageView?.image = UIImage(systemName: "checkmark.circle")
                cell.imageView?.tintColor = .systemGreen
            } else if options?.description == "Edit" {
                cell.textLabel?.text = options?.description
                cell.textLabel?.textColor = .systemGray
                cell.imageView?.image = UIImage(systemName: "arrow.clockwise")
                cell.imageView?.tintColor = .systemGray
            } else {
                cell.textLabel?.text = options?.description
                cell.textLabel?.textColor = .systemRed
                cell.imageView?.image = UIImage(systemName: "xmark.circle")
                cell.imageView?.tintColor = .systemRed
            }
            
        case .Info:
            let info = InfoOptions(rawValue: indexPath.row)
            cell.selectionStyle = .none
            
            if info?.description == "Title:" {
                cell.textLabel?.text = info?.description
                cell.rightLabel.text = medicationTitle

            } else if info?.description == "Dosage:" {
                cell.textLabel?.text = info?.description
                cell.rightLabel.text = medicationDosage
              
            }else if info?.description == "Date:" {
                cell.textLabel?.text = info?.description
                let date = medicationDate
                let formatter = DateFormatter()
                formatter.dateFormat = "MMM d,yyyy"
                cell.rightLabel.text = formatter.string(from: date!)
                
            } else {
                cell.textLabel?.text = info?.description
                let time = medicationDate
                let formatter = DateFormatter()
                formatter.dateFormat = "HH:mm"
                cell.rightLabel.text = formatter.string(from: time!)
            }
            
        }

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let section = InfoSection(rawValue: indexPath.section) else { return }
        
        switch section {
        case .Options:
            let option = MedicationOptions(rawValue: indexPath.row)
            if option?.description == "Take medication" {
                handleTakeMedication()
            }
            if option?.description == "Delete" {
                handleDeleteMedication()
            }
            tableView.deselectRow(at: indexPath, animated: true)
        case .Info:
            print("u")
        }
    }
}

