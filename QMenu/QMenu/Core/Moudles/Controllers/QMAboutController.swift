//
//  QMAboutController.swift
//  QMenu
//
//  Created by password 1234 on 9/2/21.
//

import Cocoa
import macOSThemeKit

class QMAboutController: QMBaseController {

    @IBOutlet weak var nameLabel: NSTextField!
    @IBOutlet var textView: NSTextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        makeUI()
    }
    
}

fileprivate extension QMAboutController {
    func makeUI() {
        textView.textContainerInset = NSSize.init(width: 10, height: 10)
        
        let text = "\(QMUtiles.App.name) v\(QMUtiles.App.version)"
        let paragraph = NSMutableParagraphStyle.init()
        paragraph.alignment = .center
        let attributedString = NSMutableAttributedString.init(string: text, attributes: [
            NSAttributedString.Key.font: NSFont.boldSystemFont(ofSize: 15),
            NSAttributedString.Key.foregroundColor: ThemeColor.menuNormalTextColor,
            NSAttributedString.Key.paragraphStyle: paragraph,
        ])
        let range = (text as NSString).range(of: "v\(QMUtiles.App.version)")
        attributedString.addAttributes([NSAttributedString.Key.font: NSFont.systemFont(ofSize: 12)], range: range)
        nameLabel.attributedStringValue = attributedString
    }
}
