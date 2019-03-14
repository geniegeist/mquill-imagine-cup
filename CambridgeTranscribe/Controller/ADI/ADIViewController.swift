//
//  ADIViewController.swift
//  CambridgeTranscribe
//
//  Created by Viet Duc Nguyen on 11.03.19.
//  Copyright © 2019 Viet Duc Nguyen. All rights reserved.
//

import UIKit

class ADIViewController: UIViewController {
    
    var adiView: PullOverADIView!

    override func viewDidLoad() {
        super.viewDidLoad()

        adiView = UINib(nibName: "PullOverADIView", bundle: nil).instantiate(withOwner: self, options: nil).first as? PullOverADIView
        adiView.frame = CGRect(x: 12, y: 80, width: view.bounds.size.width - 12 * 2, height: 264)
        view.addSubview(adiView)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
