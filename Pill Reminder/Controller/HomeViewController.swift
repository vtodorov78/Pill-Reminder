//
//  HomeViewController.swift
//  Pill Reminder
//
//  Created by Vladimir Todorov on 24.07.21.
//

import UIKit
import Firebase
import UserNotifications
import NotificationBannerSwift

class HomeViewController: UITableViewController {
    
    // MARK: - Properties
    
    var medications = [Medication]()
    
    let signOutImage = UIImage(systemName: "arrow.left")
    
    let database = Firestore.firestore()
    
    
    let emptyLabel: UILabel = {
        let label = UILabel()
        label.text = "Add your first medication."
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 16)
        label.textAlignment = .center
        return label
    }()
    
    lazy var emptyView: UIView = {
        let view = UIView()
        view.addSubview(emptyLabel)
        emptyLabel.center(inView: view)
        return view
    }()
    
    
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
        addVC.completion = { title, amount, date in
            DispatchQueue.main.async {
                self.navigationController?.popToRootViewController(animated: true)
                
                let newMedication = Medication(title: title, amount: amount, date: date)
                newMedication.currentUser = Auth.auth().currentUser?.uid
                self.medications.append(newMedication)
                
                self.tableView.reloadData()
            }
        }
        navigationController?.pushViewController(addVC, animated: true)
    }
    
    
    @objc func putCheckmark(sender: UIButton) {
        
        let indexPath = IndexPath(row: sender.tag, section: 0)
        let cell = tableView.cellForRow(at: indexPath) as! MedicationCell
        
        if sender.isSelected {
            sender.isSelected = false
            cell.medication.isMarked = false
        } else {
            sender.isSelected = true
            cell.medication.isMarked = true
        }
        
        // delete taken medication
        let medication = medications[indexPath.row]
        guard let documentID = medication.uid else { return }
        deleteData(id: documentID)
        pushSuccessNotificationBanner()
        medications.remove(at: sender.tag)
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
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
    
    func saveData(title: String, amount: String, date: Date) {
        guard let user = Auth.auth().currentUser?.uid else { return }
        database.collection("medications").addDocument(data: [
            "title": title,
            "amount": amount,
            "date": date,
            "user": user
            
        ]) { (error) in
            if let e = error {
                print("There was an issue saving data to firestore, \(e)")
            } else {
                print("Successfully saved data.")
            }
        }
    }
    
    func readData() {
        guard let user = Auth.auth().currentUser?.uid else { return }
        database.collection("medications").whereField("user", isEqualTo: user).order(by: "date").addSnapshotListener { querySnapshot, error in
            self.medications = []
            
            if let e = error {
                print("There was an issue retrieving data from Firestore. \(e)")
            } else {
                if let snapshotDocuments = querySnapshot?.documents {
                    
                    for doc in snapshotDocuments {
                        let data = doc.data()
                        let title = data["title"] as? String ?? ""
                        let amount = data["amount"] as? String ?? ""
                        let date = (data["date"] as? Timestamp)?.dateValue() ?? Date()
                        let id = doc.documentID
                        let medication = Medication(title: title, amount: amount, date: date)
                        medication.uid = id
                        self.medications.append(medication)
                    }
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
            }
        }
    }
    
    func deleteData(id: String) {
        database.collection("medications").document(id).delete()
    }
    
    func signOut() {
        do {
            try Auth.auth().signOut()
            let navController = UINavigationController(rootViewController: LoginViewController())
            navController.navigationBar.barStyle = .black
            navController.modalPresentationStyle = .fullScreen
            self.dismiss(animated: true)
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
            readData()
        }
    }
    
    // MARK: - Helper Functions
    
    func removeMedicationRow(sender: UIButton) {
        medications.remove(at: sender.tag)
        self.tableView.reloadData()
        
    }
    
    func pushSuccessNotificationBanner() {
        let banner = NotificationBanner(title: "Medication is taken.", subtitle: nil, leftView: nil, rightView: nil, style: .success, colors: nil)
        banner.dismissOnTap = true
        banner.dismissOnSwipeUp = true
        banner.titleLabel?.textAlignment = .center
        banner.show()
    }
    
    func pushWarningNotificationBanner() {
        let banner = NotificationBanner(title: "Medication is removed.", subtitle: nil, leftView: nil, rightView: nil, style: .danger, colors: nil)
        banner.dismissOnTap = true
        banner.dismissOnSwipeUp = true
        banner.titleLabel?.textAlignment = .center
        banner.show()
    }
    
    func configureViewComponents() {
        
        tableView.tableFooterView = UIView()
        
        view.backgroundColor = .white
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: signOutImage, style: .plain, target: self, action: #selector(handleSignOut))
        navigationController?.navigationBar.tintColor = .white
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addMedicationButtonPressed))
        navigationItem.title = "My Medications"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .mainBlue()
        appearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]
        appearance.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]
        navigationController?.navigationBar.standardAppearance = appearance;
        navigationController?.navigationBar.scrollEdgeAppearance = navigationController?.navigationBar.standardAppearance
        
        tableView.register(MedicationCell.self, forCellReuseIdentifier: MedicationCell.reuseIdentifier)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .white
        
        view.addSubview(emptyView)
        emptyView.center(inView: view)
    }
    
}

// MARK: - UITableViewDelegate/Datasource

extension HomeViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if medications.count == 0 {
            emptyView.isHidden = false
        } else {
            emptyView.isHidden = true
        }
        return medications.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MedicationCell.reuseIdentifier, for: indexPath) as! MedicationCell
        cell.layer.masksToBounds = true
        cell.layer.borderWidth = 0.5
        cell.layer.borderColor = UIColor.lightGray.cgColor
        cell.layer.cornerRadius = 5
        cell.checkmarkButton.addTarget(self, action: #selector(putCheckmark), for: .touchUpInside)
        cell.checkmarkButton.tag = indexPath.row
        let medication = medications[indexPath.row]
        cell.medication = medication
        cell.configureCell(with: medication)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // delete document
            let medication = medications[indexPath.row]
            guard let documentID = medication.uid else { return }
            deleteData(id: documentID)
            
            tableView.beginUpdates()
            medications.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.endUpdates()
            pushWarningNotificationBanner()
        }
    }
}




