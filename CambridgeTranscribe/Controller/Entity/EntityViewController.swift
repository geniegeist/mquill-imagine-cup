//
//  EntityViewController.swift
//  CambridgeTranscribe
//
//  Created by Viet Duc Nguyen on 10.03.19.
//  Copyright © 2019 Viet Duc Nguyen. All rights reserved.
//

import UIKit
import GSKStretchyHeaderView

class EntityViewController: UIViewController {
    
    @IBOutlet weak var contentLabel: UILabel?
    var content: String? {
        didSet {
            contentLabel?.text = content
        }
    }
    
    @IBOutlet weak var tableView: UITableView!
    var stretchyHeader: GSKStretchyHeaderView!
    var entityHeader: EntitiyHeader!
    
    @IBOutlet weak var askADIButton: UIButton!
    @IBOutlet weak var websearchButton: UIButton!
    
    private var cell: EntityCell?
    var isLoading: Bool = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        tableView.estimatedRowHeight = 1
        tableView.rowHeight = 1
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 400, right: 0)
        tableView.setContentOffset(CGPoint(x: 0, y: -400), animated: false)
        
        let headerSize = CGSize(width: tableView.frame.size.width,
                                height: 320) // 200 will be the default height
        stretchyHeader = GSKStretchyHeaderView(frame: CGRect(x: 0, y: 0,
                                                                          width: headerSize.width,
                                                                          height: headerSize.height))
        
        entityHeader = UINib(nibName: "EntityHeader", bundle: nil).instantiate(withOwner: self, options: nil).first as! EntitiyHeader
        entityHeader.frame = stretchyHeader.bounds
        entityHeader.title = title
        entityHeader.backButton.addTarget(self, action: #selector(back), for: .touchUpInside)
        stretchyHeader.contentView.addSubview(entityHeader)
        
        tableView.addSubview(stretchyHeader)
        
        contentLabel?.text = content
    }

    @objc private func back() {
        navigationController?.popViewController(animated: true)
    }
}

extension EntityViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! EntityCell
        self.cell = cell
        return cell;
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let content = self.content else { return 0 }
        return EntityCell.heightOfCell(content, width: view.bounds.size.width)
    }
    
}
