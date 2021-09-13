//
//  MedicineCell.swift
//  Pill Reminder
//
//  Created by Vladimir Todorov on 29.08.21.
//

import UIKit

class MedicationCell: UITableViewCell {
    
    static let reuseIdentifier = "MedicationCell"
    
    // MARK: - Properties
    
    let medicationImageView: UIImageView = {
        let imgView = UIImageView()
        imgView.image = UIImage(named: "pill")
        imgView.contentMode = .scaleAspectFit
        return imgView
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 14)
        return label
    }()
    
    let timeLabel: UILabel = {
        let label = UILabel()
        label.textColor = .mainBlue()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    let amountLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    let checkmarkButton: UIButton = {
        let button = UIButton()
        let checkmarkImage = UIImage(named: "tick")
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.lightGray.cgColor
        button.setBackgroundImage(checkmarkImage, for: .selected)
        return button
    }()
    
    lazy var stack1: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [timeLabel, titleLabel, amountLabel])
        return stack
    }()
    
    
    // MARK: - Init
   
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureViewComponents()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Helper Functions
    
    
    func configureCell(with medication: Medication) {
        
    }
    
    
    func configureViewComponents() {
        
        self.clipsToBounds = true
        contentView.backgroundColor = .white
        
        addSubview(medicationImageView)
        medicationImageView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: nil, paddingTop: 0, paddingLeft: 5, paddingBottom: 0, paddingRight: 0, width: self.frame.width/4, height: self.frame.height)
        
       addSubview(stack1)
        stack1.axis = .vertical
        stack1.distribution = .equalSpacing
        stack1.anchor(top: topAnchor, left: medicationImageView.rightAnchor, bottom: bottomAnchor, right: nil, paddingTop: 5, paddingLeft: 10, paddingBottom: 5, paddingRight: 0, width: 0, height: self.frame.height)
        
        addSubview(checkmarkButton)
        checkmarkButton.anchor(top: topAnchor, left: nil, bottom: bottomAnchor, right: rightAnchor, paddingTop: 15, paddingLeft: 15, paddingBottom: 15, paddingRight: 15, width: self.frame.width/8, height: 0)
        checkmarkButton.backgroundColor = .white
    }
    
    
    
}
