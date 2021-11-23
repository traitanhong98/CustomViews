//
//  HyperLinkViewController.swift
//  CustomViews
//
//  Created by ECO0542-HoangNM on 11/10/2021.
//

import UIKit

class HyperLinkViewController: UIViewController {

    @IBOutlet weak var content: CustomLabel!
    
    var text = """
        Something  fun
        Click here for more detail
        """
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let paragrapStyle = NSParagraphStyle()
//        paragrapStyle.
        let attributedText = AttributedStringBuilder(string: text)
            .addColor(color: .orange, forSubString: "here")
            .addLink(url: "www.google.com", forSubString: "here")
            .addBackGroundColor(.blue, forSubString: "fun")
            .addForgegroundColor(.white, forSubString: "fun")
            .addFont(font: .systemFont(ofSize: 10), forSubString: "fun")
            .build()
        content.attributedText = attributedText
        content.isUserInteractionEnabled = true
        
        
    }
    @IBAction func back(_ sender: Any) {
        dismiss(animated: true)
    }
    @objc func selection() {
        print("User selected")
    }
}
