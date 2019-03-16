//
//  ChoseLectureViewController.swift
//  CambridgeTranscribe
//
//  Created by Viet Duc Nguyen on 15.03.19.
//  Copyright © 2019 Viet Duc Nguyen. All rights reserved.
//

import UIKit
import Hero

protocol SaveTranscriptViewControllerDelegate {
    func saveTranscript(_: SaveTranscriptViewController, inLecture lectureId: String)
}

class SaveTranscriptViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var saveButtonBottomConstraint: NSLayoutConstraint!
    
    private var createNewLectureVC: CreateNewLectureViewController?
    
    var saveTranscriptDelegate: SaveTranscriptViewControllerDelegate?
    
    private var lectures: [LectureDocument] {
        return LectureStore.lectures.allObjects().sorted(by: { $0.date.compare($1.date) == .orderedAscending })
    }
    
    class func createFromNib() -> SaveTranscriptViewController {
        return UINib(nibName: "SaveTranscriptViewController", bundle: nil).instantiate(withOwner: self, options: nil).first as! SaveTranscriptViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hero.isEnabled = true
        hero.modalAnimationType = .slide(direction: .up)
                
        view.backgroundColor = UIColor(white: 0, alpha: 0.9)
        tableView.backgroundColor = UIColor.clear
        tableView.register(UINib(nibName: "SaveTranscriptCell", bundle: nil), forCellReuseIdentifier: "cell")
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
        tableView.allowsSelection = true
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 60, right: 0)
        
        closeButton.addTarget(self, action: #selector(dismissSaveTranscriptVC), for: .touchUpInside)
        
        saveButton.titleLabel?.font = UIFont.brandonGrotesque(weight: .medium, size: 22)
        saveButton.backgroundColor = UIColor(rgb: 0x3D7BFF)
        saveButton.setTitle("Save", for: .normal)
        saveButton.contentEdgeInsets = UIEdgeInsets(top: 8, left: 12, bottom: 8, right: 12)
        saveButton.setTitleColor(UIColor.white, for: .normal)
        saveButton.layer.cornerRadius = 8
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    @objc func dismissSaveTranscriptVC() {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func save(_ sender: Any) {
        let selectedIndex = tableView.indexPathForSelectedRow!
        let lectureId = lectures[selectedIndex.row].id
        saveTranscriptDelegate?.saveTranscript(self, inLecture: lectureId)
    }
}

extension SaveTranscriptViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lectures.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! SaveTranscriptCell

        
        if (indexPath.row == lectures.count) {
            cell.titleLabel.text = "Create new class"
            cell.transcriptIconView.imageView.image = UIImage(named: "add")
            cell.transcriptIconView.hero.id = "magenta"
            cell.selectionStyle = .none
            return cell
        } else {
            let lecture = lectures[indexPath.row]
            cell.titleLabel.text = lecture.name
            cell.transcriptIconView.color = lecture.color
            cell.transcriptIconView.title = lecture.shortName
            cell.transcriptIconView.hero.id = nil
            
            let bgColorView = UIView()
            bgColorView.backgroundColor = UIColor(white: 1, alpha: 0.2)
            cell.selectedBackgroundView = bgColorView
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("did select")
        
        if (indexPath.row == lectures.count) {
            createNewLectureVC = UINib(nibName: "CreateNewLectureViewController", bundle: nil).instantiate(withOwner: self, options: nil).first as? CreateNewLectureViewController
            
            guard let createNewLectureVC = self.createNewLectureVC else { return }
            navigationController?.pushViewController(createNewLectureVC, animated: true)
        } else {
            saveButtonBottomConstraint.constant = 28
            UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut, animations: {
                self.view.layoutIfNeeded()
            })
        }
    }
}
