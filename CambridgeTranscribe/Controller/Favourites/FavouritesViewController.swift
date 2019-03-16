//
//  FavouritesViewController.swift
//  CambridgeTranscribe
//
//  Created by Viet Duc Nguyen on 16.03.19.
//  Copyright © 2019 Viet Duc Nguyen. All rights reserved.
//
// Lol this is so hacky I am so sorry

import UIKit

class FavouritesViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var tableViewImageView: UIImageView!
    
    private lazy var favourites: [(TranscriptDocument, TranscriptFragment)] = {
        let documents = TranscriptStore.transcripts.allObjects()
        var favourites = [(TranscriptDocument, TranscriptFragment)]()
        
        for doc in documents {
            let favFrags = doc.fragments.filter({ $0.isFavourite })
            favourites += favFrags.map({ (doc, $0) })
        }
        
        return favourites
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(rgb: 0xE74774)

        tableView.layer.cornerRadius = 16
        tableView.backgroundColor = UIColor.white
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.tableFooterView = UIView()
        tableView.layer.masksToBounds = true
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100
        tableView.contentInset = UIEdgeInsets(top: 260, left: 0, bottom: 32, right: 0)
        tableView.register(UINib(nibName: "FavouritesCell", bundle: nil), forCellReuseIdentifier: "cell")
        
        tableViewImageView = UIImageView(frame: CGRect(x: 0, y: -210, width: view.bounds.size.width, height: 300))
        tableViewImageView.image = UIImage(named: "favourites-scene")
        tableViewImageView.contentMode = UIView.ContentMode.scaleAspectFit
        tableView.insertSubview(tableViewImageView, at: 0)
        
        let dismissBtnSize: CGFloat = 44
        let dismissButton = UIButton(frame: CGRect(x: view.frame.size.width - dismissBtnSize - 12, y: 12.0 + tableView.frame.minY, width: dismissBtnSize, height: dismissBtnSize))
        dismissButton.setImage(UIImage(named: "close_filled_round"), for: .normal)
        view.addSubview(dismissButton)
        dismissButton.addTarget(self, action: #selector(dismissBtnTapped), for: .touchUpInside)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    @objc func dismissBtnTapped() {
        dismiss(animated: true, completion: nil)
    }
    
}

extension FavouritesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favourites.count
    }
    
    func tableView(_ tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int) {
        tableView.sendSubviewToBack(tableViewImageView)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! FavouritesCell
        let (doc, fragment) = favourites[indexPath.row]
        let lecture = LectureStore.lectures.object(withId: doc.lectureId)!
        
        cell.backgroundColor = UIColor.clear
        cell.selectionStyle = .none
        
        cell.titleLabel.text = doc.title
        cell.transcriptLabel.text = fragment.content
        cell.icon.color = lecture.color
        cell.icon.title = lecture.shortName

        let bgColorView = UIView()
        bgColorView.backgroundColor = UIColor.clear
        cell.selectedBackgroundView = bgColorView
        
        tableView.sendSubviewToBack(tableViewImageView)
        
        return cell
    }
    
    
}

