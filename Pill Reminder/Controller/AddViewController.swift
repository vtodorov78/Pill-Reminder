//
//  AddViewController.swift
//  Pill Reminder
//
//  Created by Vladimir Todorov on 9.09.21.
//

import UIKit

class AddViewController: UIViewController {
    
    // MARK: - Propeties
    
    let textFieldPadding = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
    var isSelected = false
    var isTheSelectedImage: UIImageView!

    
    let titleField: UITextField = {
        let textField = UITextField()
        textField.attributedPlaceholder = NSAttributedString(string: "Enter Title...", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        textField.textColor = .black
        textField.layer.cornerRadius = 5
        textField.backgroundColor = .white
        textField.setLeftPaddingPoints(10)
        return textField
    }()
    
    let amountField: UITextField = {
        let textField = UITextField()
        textField.attributedPlaceholder = NSAttributedString(string: "Enter Dosage...", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        textField.textColor = .black
        textField.layer.cornerRadius = 5
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
    
    let imageView1: UIImageView = {
        let iv = UIImageView(image: UIImage(named: "pill"))
        iv.clipsToBounds = true
        iv.contentMode = .scaleAspectFit
        iv.layer.cornerRadius = 5
        return iv
    }()
    
    let imageView2: UIImageView = {
        let iv = UIImageView(image: UIImage(named: "pill2png"))
        iv.clipsToBounds = true
        iv.contentMode = .scaleAspectFit
        iv.layer.cornerRadius = 5
        return iv
    }()
    
    let imageView3: UIImageView = {
        let iv = UIImageView(image: UIImage(named: "powder"))
        iv.clipsToBounds = true
        iv.contentMode = .scaleAspectFit
        iv.layer.cornerRadius = 5
        return iv
    }()
    
    let imageView4: UIImageView = {
        let iv = UIImageView(image: UIImage(named: "syrup"))
        iv.clipsToBounds = true
        iv.contentMode = .scaleAspectFit
        iv.layer.cornerRadius = 5
        return iv
    }()
    
    let imageView5: UIImageView = {
        let iv = UIImageView(image: UIImage(named: "injection"))
        iv.clipsToBounds = true
        iv.contentMode = .scaleAspectFit
        iv.layer.cornerRadius = 5
        return iv
    }()
    
    let containerView: UIView = {
        let cv = UIView()
        cv.backgroundColor = .systemBlue
        return cv
    }()
    
    public var completion: ((String, String, Date, UIImage) -> Void)?
    
    // MARK: - Init
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewComponents()
        
    }
    
    
    // MARK: - Selectors
    
  @objc func didTapSaveButton() {
        if let titleText = titleField.text, !titleText.isEmpty,
           let amountText = amountField.text, !amountText.isEmpty,
           let selectedImage = isTheSelectedImage.image {
            let targetDate = datePicker.date
        
            completion?(titleText, amountText, targetDate, selectedImage)
        }
    }
    
    @objc func selectImage(tapGestureRecognizer: UITapGestureRecognizer) {
        let tappedImage = tapGestureRecognizer.view as! UIImageView
        
        tappedImage.backgroundColor = .mainBlue()
        
        switch tappedImage {
        case imageView1:
            imageView2.backgroundColor = .none
            imageView3.backgroundColor = .none
            imageView4.backgroundColor = .none
            imageView5.backgroundColor = .none
            isTheSelectedImage = imageView1
        case imageView2:
            imageView1.backgroundColor = .none
            imageView3.backgroundColor = .none
            imageView4.backgroundColor = .none
            imageView5.backgroundColor = .none
            isTheSelectedImage = imageView2
        case imageView3:
            imageView2.backgroundColor = .none
            imageView1.backgroundColor = .none
            imageView4.backgroundColor = .none
            imageView5.backgroundColor = .none
            isTheSelectedImage = imageView3
        case imageView4:
            imageView2.backgroundColor = .none
            imageView3.backgroundColor = .none
            imageView1.backgroundColor = .none
            imageView5.backgroundColor = .none
            isTheSelectedImage = imageView4
        case imageView5:
            imageView2.backgroundColor = .none
            imageView3.backgroundColor = .none
            imageView4.backgroundColor = .none
            imageView1.backgroundColor = .none
            isTheSelectedImage = imageView5
        default:
            tappedImage.backgroundColor = .none
        }
    }
    
    // MARK: - Helper Functions
    func configureViewComponents() {
        view.backgroundColor = .lightGray
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(didTapSaveButton))
        navigationController?.navigationBar.tintColor = .white
        
        view.addSubview(titleField)
        titleField.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 20, paddingLeft: 10, paddingBottom: 0, paddingRight: 10, width: view.frame.width, height: 52)
        
        view.addSubview(amountField)
        amountField.anchor(top: titleField.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 20, paddingLeft: 10, paddingBottom: 0, paddingRight: 10, width: view.frame.width, height: 52)
        
        view.addSubview(imageView1)
        imageView1.anchor(top: amountField.bottomAnchor, left: view.leftAnchor, bottom: nil, right: nil, paddingTop: 30, paddingLeft: 10, paddingBottom: 0, paddingRight: 0, width: 65, height: 65)
        imageView1.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(selectImage(tapGestureRecognizer:))))
        imageView1.isUserInteractionEnabled = true
        
        view.addSubview(imageView2)
        imageView2.anchor(top: amountField.bottomAnchor, left: imageView1.rightAnchor, bottom: nil, right: nil, paddingTop: 30, paddingLeft: 10, paddingBottom: 0, paddingRight: 0, width: 65, height: 65)
        imageView2.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(selectImage(tapGestureRecognizer:))))
        imageView2.isUserInteractionEnabled = true
        
        view.addSubview(imageView3)
        imageView3.anchor(top: amountField.bottomAnchor, left: imageView2.rightAnchor, bottom: nil, right: nil, paddingTop: 30, paddingLeft: 10, paddingBottom: 0, paddingRight: 0, width: 65, height: 65)
        imageView3.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(selectImage(tapGestureRecognizer:))))
        imageView3.isUserInteractionEnabled = true
        
        view.addSubview(imageView4)
        imageView4.anchor(top: amountField.bottomAnchor, left: imageView3.rightAnchor, bottom: nil, right: nil, paddingTop: 30, paddingLeft: 10, paddingBottom: 0, paddingRight: 0, width: 65, height: 65)
        imageView4.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(selectImage(tapGestureRecognizer:))))
        imageView4.isUserInteractionEnabled = true
        
        view.addSubview(imageView5)
        imageView5.anchor(top: amountField.bottomAnchor, left: imageView4.rightAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 30, paddingLeft: 10, paddingBottom: 0, paddingRight: 10, width: 65, height: 65)
        imageView5.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(selectImage(tapGestureRecognizer:))))
        imageView5.isUserInteractionEnabled = true

        
       view.addSubview(datePicker)
        datePicker.anchor(top: imageView1.bottomAnchor, left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, paddingTop: 10, paddingLeft: 10, paddingBottom: 0, paddingRight: 10, width: view.frame.width, height: view.frame.height/3)
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
