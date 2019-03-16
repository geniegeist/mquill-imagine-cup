//
//  CreateNewLectureViewController.swift
//  CambridgeTranscribe
//
//  Created by Viet Duc Nguyen on 15.03.19.
//  Copyright © 2019 Viet Duc Nguyen. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import Hero

class CreateNewLectureViewController: UIViewController {
    
    @IBOutlet weak var transcriptIconView: TranscriptIconView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var lectureIdentifierTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var lectureNameTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var saveButtonBottomConstraint: NSLayoutConstraint!
    
    private var color: LectureDocument.Color = LectureDocument.Color.magenta {
        didSet {
            transcriptIconView.color = color
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapped))
        view.addGestureRecognizer(tap)
        
        hero.isEnabled = true
        transcriptIconView.hero.id = "magenta"
        
        lectureIdentifierTextField.selectedLineColor = UIColor.white
        lectureIdentifierTextField.lineColor = UIColor(white: 1, alpha: 0.5)
        lectureNameTextField.selectedLineColor = UIColor.white
        lectureNameTextField.lineColor = UIColor(white: 1, alpha: 0.5)
        
        lectureIdentifierTextField.textColor = UIColor.white
        lectureIdentifierTextField.selectedTitleColor = UIColor.white
        lectureNameTextField.textColor = UIColor.white
        lectureNameTextField.selectedTitleColor = UIColor.white
                
        lectureIdentifierTextField.font = UIFont.brandonGrotesque(weight: .medium, size: 22)
        lectureIdentifierTextField.titleFont = UIFont.brandonGrotesque(weight: .medium, size: 15)
        lectureNameTextField.font = UIFont.brandonGrotesque(weight: .medium, size: 22)
        lectureNameTextField.titleFont = UIFont.brandonGrotesque(weight: .medium, size: 15)
        
        lectureNameTextField.delegate = self
        lectureIdentifierTextField.delegate = self
        
        lectureNameTextField.addTarget(self, action: #selector(nameDidChange), for: .editingChanged)
        lectureIdentifierTextField.addTarget(self, action: #selector(identifierDidChange(_ :)), for: .editingChanged)
        
        saveButton.titleLabel?.font = UIFont.brandonGrotesque(weight: .medium, size: 22)
        saveButton.backgroundColor = UIColor(rgb: 0x3D7BFF)
        saveButton.setTitle("Create class", for: .normal)
        saveButton.contentEdgeInsets = UIEdgeInsets(top: 8, left: 12, bottom: 8, right: 12)
        saveButton.setTitleColor(UIColor.white, for: .normal)
        saveButton.layer.cornerRadius = 8
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        lectureIdentifierTextField.becomeFirstResponder()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        lectureIdentifierTextField.resignFirstResponder()
        lectureNameTextField.resignFirstResponder()
    }
    
    @objc func tapped() {
        lectureIdentifierTextField.resignFirstResponder()
        lectureNameTextField.resignFirstResponder()
    }
    
    @objc func nameDidChange() {
        if ((lectureIdentifierTextField.text?.count ?? 0) > 0 && (lectureNameTextField.text?.count ?? 0) > 0) {
            self.saveButtonBottomConstraint.constant = 44
        } else {
            self.saveButtonBottomConstraint.constant = -66
        }
    }
    
    @objc func identifierDidChange(_ textfield: UITextField) {
        transcriptIconView.title = textfield.text
        
        if ((lectureIdentifierTextField.text?.count ?? 0) > 0 && (lectureNameTextField.text?.count ?? 0) > 0) {
            self.saveButtonBottomConstraint.constant = 44
        } else {
            self.saveButtonBottomConstraint.constant = -66
        }
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        let shortName = lectureIdentifierTextField.text!
        let name = lectureNameTextField.text!
        
        let lecture = LectureDocument(shortName: shortName, name: name, color: color)
        try! LectureStore.lectures.save(lecture)

        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func transcriptIconViewTapped(_ sender: Any) {
        let chooseVC = UINib(nibName: "ChooseIconForLectureViewController", bundle: nil).instantiate(withOwner: self, options: nil).first as! ChooseIconForLectureViewController
        chooseVC.delegate = self
        navigationController?.pushViewController(chooseVC, animated: true)
    }
}

extension CreateNewLectureViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if (textField == lectureIdentifierTextField) {
            if (range.location == 5) {
                return false
            }
        }
        
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if (textField == lectureIdentifierTextField) {
            lectureNameTextField.becomeFirstResponder()
        } else if (textField == lectureNameTextField) {
            lectureNameTextField.resignFirstResponder()
        }
        
        return true
    }
    
}


extension CreateNewLectureViewController: ChooseIconForLectureViewControllerDelegate {
    func chooseIconDidSelectColor(color: LectureDocument.Color) {
        self.color = color
    }
}
