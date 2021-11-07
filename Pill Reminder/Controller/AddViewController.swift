//
//  AddViewController.swift
//  Pill Reminder
//
//  Created by Vladimir Todorov on 9.09.21.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

class AddViewController: UIViewController {
    
    // MARK: - Propeties
    
    let textFieldPadding = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
    var isSelected = false
    var isTheSelectedImage: UIImageView!

    
    let titleField: UITextField = {
        let textField = UITextField()
        textField.attributedPlaceholder = NSAttributedString(string: "Enter Title...", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        textField.textColor = .black
        textField.layer.cornerRadius = 10
        textField.backgroundColor = .white
        textField.setLeftPaddingPoints(10)
        return textField
    }()
    
    let amountField: UITextField = {
        let textField = UITextField()
        textField.attributedPlaceholder = NSAttributedString(string: "Enter Dosage...", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        textField.textColor = .black
        textField.layer.cornerRadius = 10
        textField.backgroundColor = .white
        textField.setLeftPaddingPoints(10)
        return textField
    }()
    
    let datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.setValue(UIColor.black, forKey: "textColor")
        return datePicker
    }()
    
    
    public var completion: ((String, String, Date) -> Void)?
    
    // MARK: - Init
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewComponents()
        
    }
    
    
    // MARK: - Selectors
    
  @objc func didTapSaveButton() {
     
      
        if let titleText = titleField.text, !titleText.isEmpty,
           let amountText = amountField.text, !amountText.isEmpty {
            let targetDate = datePicker.date
        
            completion?(titleText, amountText, targetDate)
            
            let homeVC = HomeViewController()
            
       
            homeVC.saveData(title: titleText, amount: amountText, date: targetDate)
            
            
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound], completionHandler: { success, error in
                if success {
                    // schedule notification
                    self.scheduleNotification(title: titleText, amount: amountText, date: targetDate)
                } else if error != nil {
                    print("Error occured")
                }
            })
        }
    }

    
   

    
    // MARK: - Helper Functions
    
    func scheduleNotification(title: String, amount: String, date: Date) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.sound = .default
        content.body = amount
        
        let targetDate = date
        let trigger = UNCalendarNotificationTrigger(dateMatching: Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: targetDate), repeats: false)
        let request = UNNotificationRequest(identifier: "some long id", content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: { error in
            if error != nil {
                print("Something went wron!")
            }
        })
    }
    
    
    func configureViewComponents() {
        view.backgroundColor = .lightGray
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(didTapSaveButton))
        navigationController?.navigationBar.tintColor = .white
        
        view.addSubview(titleField)
        titleField.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 20, paddingLeft: 10, paddingBottom: 0, paddingRight: 10, width: view.frame.width, height: 52)
        
        view.addSubview(amountField)
        amountField.anchor(top: titleField.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 20, paddingLeft: 10, paddingBottom: 0, paddingRight: 10, width: view.frame.width, height: 52)
        
       view.addSubview(datePicker)
        datePicker.anchor(top: amountField.bottomAnchor, left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, paddingTop: 10, paddingLeft: 10, paddingBottom: 0, paddingRight: 10, width: view.frame.width, height: view.frame.height/3)
    }
}

extension UITextField {
    func setLeftPaddingPoints(_ amount:CGFloat){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    func setRightPaddingPoints(_ amount:CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.rightView = paddingView
        self.rightViewMode = .always
    }
}
