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
    
    let signOutImage = UIImage(systemName: "arrow.left")

    
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
    
    var welcomeLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 28)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.alpha = 0
        return label
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
        addVC.completion = { title, amount, date, image in
            DispatchQueue.main.async {
                self.navigationController?.popToRootViewController(animated: true)
                let newMedication = Medication(title: title, amount: amount, date: date, image: image)

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
    
    func loadUserData() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        Database.database().reference().child("users").child(uid).child("username").observeSingleEvent(of: .value) { (snapshot) in
            guard let username = snapshot.value as? String else { return }
            self.welcomeLabel.text = "Welcome, \(username)"
           
            if self.welcomeLabel.alpha == 0 {
                UIView.animate(withDuration: 1.5, delay: 0.2, options: .curveEaseOut, animations: {
                    self.welcomeLabel.alpha = 1
                }) { (Bool) -> Void in
                    UIView.animate(withDuration: 1.5, delay: 0.2, options: .curveEaseOut, animations: {
                        self.welcomeLabel.alpha = 0
                    })
                }
            }
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
        appearance.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]
        navigationController?.navigationBar.standardAppearance = appearance;
        navigationController?.navigationBar.scrollEdgeAppearance = navigationController?.navigationBar.standardAppearance
        
        tableView.register(MedicationCell.self, forCellReuseIdentifier: MedicationCell.reuseIdentifier)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .white
        
        view.addSubview(welcomeLabel)
        welcomeLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        welcomeLabel.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor).isActive = true
        
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
            tableView.beginUpdates()
//            let medication = medications.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.endUpdates()
        }
    }
}




