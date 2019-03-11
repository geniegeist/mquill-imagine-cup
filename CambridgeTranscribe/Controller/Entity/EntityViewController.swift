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
    
    var headerImage: UIImage?
    var content: String?
    @IBOutlet weak var tableView: UITableView!
    var stretchyHeader: GSKStretchyHeaderView!
    
    @IBOutlet weak var askADIButton: UIButton!
    @IBOutlet weak var websearchButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        
        let headerSize = CGSize(width: tableView.frame.size.width,
                                height: 320) // 200 will be the default height
        stretchyHeader = GSKStretchyHeaderView(frame: CGRect(x: 0, y: 0,
                                                                          width: headerSize.width,
                                                                          height: headerSize.height))
        
        let entityHeader = UINib(nibName: "EntityHeader", bundle: nil).instantiate(withOwner: self, options: nil).first as! EntitiyHeader
        entityHeader.frame = stretchyHeader.bounds
        entityHeader.title = title
        entityHeader.backButton.addTarget(self, action: #selector(back), for: .touchUpInside)
        stretchyHeader.contentView.addSubview(entityHeader)
        
        tableView.addSubview(stretchyHeader)
    }

    @objc private func back() {
        navigationController?.popViewController(animated: true)
    }
}

extension EntityViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! EntityCell
        cell.content = content
        return cell;
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let content = self.content else { return 0 }
        return EntityCell.heightOfCell(content, width: view.bounds.size.width)
    }
    
}
