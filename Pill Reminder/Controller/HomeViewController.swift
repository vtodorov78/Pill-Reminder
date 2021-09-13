//
//  HomeViewController.swift
//  Pill Reminder
//
//  Created by Vladimir Todorov on 24.07.21.
//

import UIKit
import Firebase
import UserNotifications
                
class HomeViewController: UITableViewController {
    
    // MARK: - Properties
    
    var medications = [Medication]()
    
    var isChecked = false
    
    let signOutImage = UIImage(systemName: "arrow.left")

    
    // MARK: - Init
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(MedicationCell.self, forCellReuseIdentifier: MedicationCell.reuseIdentifier)
        authenticateUserAndConfigureView()
    }
    
    // MARK: - Selectors
    
    @objc func addMedicationButtonPressed() {
        // show addVC
        let addVC = AddViewController()
        addVC.title = "New Medication"
        addVC.completion = { title, amount, date, image in
            DispatchQueue.main.async {
                self.navigationController?.popToRootViewController(animated: true)
                let new = Medication(title: title, amount: amount, date: date, indentifier: "id_\(title)", image: image)
                self.medications.append(new)
                self.tableView.reloadData()
                
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
        }
        navigationController?.pushViewController(addVC, animated: true)
        
        
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound], completionHandler: { success, error in
            if success {
                // schedule test
                self.scheduleTest()
            } else if error != nil {
                print("Error occured")
            }
        })
         
    }
    
    
    @objc func putCheckmark(sender: UIButton) {
        if sender.isSelected{
            sender.isSelected = false
        } else {
            sender.isSelected = true
        }
        tableView.reloadData()
    }
    
    @objc func handleSignOut() {
        let alertController = UIAlertController(title: nil, message: "Are you sure you want to sign out?", preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction(title: "Sign Out", style: .destructive, handler: { (_) in
            self.signOut()
        }))
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alertController, animated: true)
    }
    
    // MARK: - API
    
    func loadUserData() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        Database.database().reference().child("users").child(uid).child("username").observeSingleEvent(of: .value) { (snapshot) in
        }
    }
    
    func signOut() {
        do {
            try Auth.auth().signOut()
            let navController = UINavigationController(rootViewController: LoginViewController())
            navController.navigationBar.barStyle = .black
            navController.modalPresentationStyle = .fullScreen
            self.present(navController, animated: true)
        } catch let error {
            print("Failed to sign our with error ", error.localizedDescription)
        }
    }
    
    func authenticateUserAndConfigureView() {
        
        if Auth.auth().currentUser == nil {
            DispatchQueue.main.async {
                let navController = UINavigationController(rootViewController: LoginViewController())
                navController.navigationBar.barStyle = .black
                navController.modalPresentationStyle = .fullScreen
                self.present(navController, animated: true)
            }
        } else {
            configureViewComponents()
            loadUserData()
        }
    }
    
    // MARK: - Helper Functions
    
    func scheduleTest() {
        let content = UNMutableNotificationContent()
        content.title = "Hello World!"
        content.sound = .default
        content.body = "My Long Body."
        
        let targetDate = Date().addingTimeInterval(10)
        let trigger = UNCalendarNotificationTrigger(dateMatching: Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: targetDate), repeats: false)
        let request = UNNotificationRequest(identifier: "some long id", content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: { error in
            if error != nil {
                print("Something went wron!")
            }
        })
    }
    
    func configureViewComponents() {
        
        view.backgroundColor = .white
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: signOutImage, style: .plain, target: self, action: #selector(handleSignOut))
        navigationController?.navigationBar.tintColor = .white
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addMedicationButtonPressed))
        navigationController?.navigationBar.barTintColor = .mainBlue()
        navigationItem.title = "My Medications"
        
        tableView.register(MedicationCell.self, forCellReuseIdentifier: MedicationCell.reuseIdentifier)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .white
    }
    
}

// MARK: - UITableViewDelegate/Datasource

extension HomeViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return medications.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MedicationCell.reuseIdentifier, for: indexPath) as! MedicationCell
        cell.layer.masksToBounds = true
        cell.layer.borderWidth = 0.5
        cell.layer.borderColor = UIColor.lightGray.cgColor
        cell.layer.cornerRadius = 5
        cell.checkmarkButton.addTarget(self, action: #selector(putCheckmark), for: .touchUpInside)
        cell.titleLabel.text = medications[indexPath.row].title
        cell.amountLabel.text = medications[indexPath.row].amount
        cell.medicationImageView.image = medications[indexPath.row].image
        let date = medications[indexPath.row].date
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, h:mm a"
        cell.timeLabel.text = formatter.string(from: date)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return view.frame.height/12
    }
    
    
}




