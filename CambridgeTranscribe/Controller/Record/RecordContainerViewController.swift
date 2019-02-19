//
//  RecordContainerViewController.swift
//  CambridgeTranscribe
//
//  Created by Viet Duc Nguyen on 17.02.19.
//  Copyright © 2019 Viet Duc Nguyen. All rights reserved.
//

import UIKit
import Motion

private enum CONSTANTS {
    static let cardCellReuseIdentifier = "RecordContainerCardCell"
}

class RecordContainerViewController: UIViewController {
    
    @IBOutlet weak var cardSwiper: VerticalCardSwiper!
    private var firstTimeAppearanceFlag = true
    private var isTranscribing = false
    private lazy var transcribingViewController: TranscribingViewController = {
        return TranscribingViewController.createFromStoryboard()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        cardSwiper.datasource = self
        cardSwiper.delegate = self
        cardSwiper.register(nib: UINib.init(nibName: "RecordContainerCardCell", bundle: nil), forCellWithReuseIdentifier: CONSTANTS.cardCellReuseIdentifier)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if (firstTimeAppearanceFlag && cardSwiper.scrollToCard(at: 4, animated: false)) {
            firstTimeAppearanceFlag = false
        }
    }
    
    //MARK: Public action
    
    func record() {
        isTranscribing = !isTranscribing

        transcribingViewController.view.frame = view.bounds
        addChild(transcribingViewController)
        view.addSubview(transcribingViewController.view)
        transcribingViewController.didMove(toParent: self)
 
        cardSwiper.animate(.translate(CGPoint.init(x: 0, y: -800)), .fadeOut)
    }

}

extension RecordContainerViewController: VerticalCardSwiperDatasource, VerticalCardSwiperDelegate {
    func numberOfCards(verticalCardSwiperView: VerticalCardSwiperView) -> Int {
        return 5
    }
    
    func cardForItemAt(verticalCardSwiperView: VerticalCardSwiperView, cardForItemAt index: Int) -> CardCell {
        let cardCell = verticalCardSwiperView.dequeueReusableCell(withReuseIdentifier: CONSTANTS.cardCellReuseIdentifier, for: index) as! RecordContainerCardCell
        
        return cardCell
    }
    
    func didTapCard(verticalCardSwiperView: VerticalCardSwiperView, index: Int) {
        let cardDetailViewController = UINib.init(nibName: "CardDetailViewController", bundle: nil).instantiate(withOwner: self, options: nil).first as! CardDetailViewController
        self.present(cardDetailViewController, animated: true, completion: nil)
    }
}
