//
//  EntityCell.swift
//  CambridgeTranscribe
//
//  Created by Viet Duc Nguyen on 10.03.19.
//  Copyright © 2019 Viet Duc Nguyen. All rights reserved.
//

import UIKit

class EntityCell: UITableViewCell {

    @IBOutlet weak var textView: UITextView!
    var content: String? {
        didSet {
            textView.attributedText = EntityCell.textToAttributedString(content)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()

        //textView.isEditable = false
        //textView.textContainerInset = UIEdgeInsets(top: 32, left: 24, bottom: 32, right: 24)
        //textView.isUserInteractionEnabled = false
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    class func heightOfCell(_ text: String, width: CGFloat) -> CGFloat {
        let attributedStr = EntityCell.textToAttributedString(text)
        return attributedStr!.boundingRect(with: CGSize(width: width, height: CGFloat.greatestFiniteMagnitude), options: NSStringDrawingOptions.usesLineFragmentOrigin, context: nil).height + 150
    }

    private class func textToAttributedString(_ text: String?) -> NSAttributedString? {
        guard let text = text else { return nil }
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 8
        
        return NSAttributedString(string: text,
                                  attributes: [NSAttributedString.Key.font : UIFont.maratPro(weight: .regular, size: 22),
                                               NSAttributedString.Key.foregroundColor : UIColor(white: 0, alpha: 0.75),
                                               NSAttributedString.Key.paragraphStyle : paragraphStyle])
    }
}
