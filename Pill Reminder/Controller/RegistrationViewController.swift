//
//  RegistrationViewController.swift
//  Pill Reminder
//
//  Created by Vladimir Todorov on 23.07.21.
//

import UIKit
import Firebase
import FirebaseFirestore

class RegistrationViewController: UIViewController {
    
    let database = Firestore.firestore()
    
    // MARK: - Properties
    
    var logoImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        iv.image = UIImage(named: "medicine")
        iv.tintColor = .white
        return iv
    }()
    
     let emailImage = UIImage(systemName: "envelope")
     let passwordImage = UIImage(systemName: "lock")
     let usernameImage = UIImage(systemName: "person")
    
    lazy var emailContainerView: UIView = {
        let view = UIView()
        return view.textContainerView(view: view, emailImage!, emailTextField)
    }()
    
    lazy var usernameContainerView: UIView = {
        let view = UIView()
        return view.textContainerView(view: view, usernameImage!, usernameTextField)
    }()
    
    lazy var passwordContainerView: UIView = {
        let view = UIView()
        return view.textContainerView(view: view, passwordImage!, passwordTextField)
    }()
    
    lazy var emailTextField: UITextField = {
        let tf = UITextField()
        return tf.textField(withPlaceholder: "Email", isSecureTextEntry: false)
    }()
    
    lazy var usernameTextField: UITextField = {
        let tf = UITextField()
        return tf.textField(withPlaceholder: "Username", isSecureTextEntry: false)
    }()
    
    lazy var passwordTextField: UITextField = {
        let tf = UITextField()
        return tf.textField(withPlaceholder: "Password", isSecureTextEntry: true)
    }()
    
    let signUpButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("SIGN UP", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        button.setTitleColor(UIColor.mainBlue(), for: .normal)
        button.backgroundColor = .white
        button.addTarget(self, action: #selector(handleSignUp), for: .touchUpInside)
        button.layer.cornerRadius = 5
        return button
    }()
    
    let alreadyHaveAccountButton: UIButton = {
        let button = UIButton(type: .system)
        let attributedTittle = NSMutableAttributedString(string: "Already have an account?  ", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16), NSAttributedString.Key.foregroundColor: UIColor.white])
        attributedTittle.append(NSAttributedString(string: "Sign In", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 16), NSAttributedString.Key.foregroundColor: UIColor.white]))
        button.setAttributedTitle(attributedTittle, for: .normal)
        button.addTarget(self, action: #selector(handleShowLogIn), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Init

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.emailTextField.delegate = self
        self.passwordTextField.delegate = self
        self.usernameTextField.delegate = self
        
        configureViewComponents()
    }
    
    // MARK: - Selectors
    
    @objc func handleSignUp() {
        guard let email = emailTextField.text, !email.isEmpty else { return }
        guard let password = passwordTextField.text, !password.isEmpty else { return }
        guard let username = usernameTextField.text, !username.isEmpty else { return }
        
        createUser(withEmail: email, password: password, username: username)
    }
    
    @objc func handleShowLogIn() {
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: - API
        
    func createUser(withEmail email: String, password: String, username: String) {
        Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
            if let error = error {
                print("Failed to sign up user with error: ", error.localizedDescription)
                return
            }
            
            let values = ["email": email, "username": username]
            
            self.database.collection("users").addDocument(data: values) { (error) in
                if let e = error {
                    print("There was an issue saving data to firestore, \(e)")
                } else {
                    print("Successfully saved data.")
                    guard let navController = UIApplication.shared.keyWindow?.rootViewController as? UINavigationController else { return }
                    guard let controller = navController.viewControllers[0] as? HomeViewController else { return }
                    controller.configureViewComponents()
                    
                    self.dismiss(animated: true, completion: nil)
                }
            }

            
//            Database.database().reference().child("users").child(uid).updateChildValues(values, withCompletionBlock: { error, ref in
//                if let error = error {
//                    print("Failed to update database values with error: ", error.localizedDescription)
//                    return
//                }
//                guard let navController = UIApplication.shared.keyWindow?.rootViewController as? UINavigationController else { return }
//                guard let controller = navController.viewControllers[0] as? HomeViewController else { return }
//                controller.configureViewComponents()
//
//                self.dismiss(animated: true, completion: nil)
//            })
        }
    }
    
    // MARK: - Helper Functions
    
    func configureViewComponents() {
        
        view.backgroundColor = UIColor.mainBlue()
        navigationController?.navigationBar.isHidden = true
        
        view.addSubview(logoImageView)
        logoImageView.anchor(top: view.topAnchor, left: nil, bottom: nil, right: nil, paddingTop: 60, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 150, height: 150)
        logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        view.addSubview(emailContainerView)
        emailContainerView.anchor(top: logoImageView.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 24, paddingLeft: 32, paddingBottom: 0, paddingRight: 32, width: 0, height: 50)
        
        view.addSubview(usernameContainerView)
        usernameContainerView.anchor(top: emailContainerView.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 16, paddingLeft: 32, paddingBottom: 0, paddingRight: 32, width: 0, height: 50)
        
        view.addSubview(passwordContainerView)
        passwordContainerView.anchor(top: usernameContainerView.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 16, paddingLeft: 32, paddingBottom: 0, paddingRight: 32, width: 0, height: 50)
        
        view.addSubview(signUpButton)
        signUpButton.anchor(top: passwordContainerView.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 24, paddingLeft: 32, paddingBottom: 0, paddingRight: 32, width: 0, height: 50)
        
        view.addSubview(alreadyHaveAccountButton)
        alreadyHaveAccountButton.anchor(top: nil, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 32, paddingBottom: 12, paddingRight: 32, width: 0, height: 50)
    }
}

extension RegistrationViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        handleSignUp()
        return true
    }
}
