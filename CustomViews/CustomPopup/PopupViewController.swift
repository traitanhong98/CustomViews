//
//  PopupViewController.swift
//  CustomViews
//
//  Created by ECO0542-HoangNM on 28/09/2021.
//

import UIKit

class PopupViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }


    @IBAction func back(_ sender: Any) {
        dismiss(animated: true)
    }
    @IBAction func showPopup(_ sender: Any) {
        let popup = BasePopupViewController()
        let contentView = UIView(frame: .init(origin: .zero, size: .init(width: view.frame.width, height: 300)))
        contentView.layer.cornerRadius = 8
        contentView.backgroundColor = .blue
        popup.isSwipeDownToHidePopup = true
        popup.contentView = contentView
        popup.popupPosition = .bottom
        popup.animateStyle = .expanse
        popup.showPopup(in: self)
    }
  
    @IBAction func showPopup2(_ sender: Any) {
        let popup = BasePopupViewController()
        let contentView = UIView(frame: .init(origin: .zero, size: .init(width: view.frame.width, height: 300)))
        contentView.layer.cornerRadius = 8
        contentView.backgroundColor = .blue
        popup.isSwipeDownToHidePopup = true
        popup.contentView = contentView
        popup.popupPosition = .bottom
        popup.animateStyle = .floatIn
        popup.showPopup(in: self)
    }
    
    @IBAction func showPopup3(_ sender: Any) {
        let popup = BasePopupViewController()
        let contentView = UIView(frame: .init(origin: .zero, size: .init(width: view.frame.width - 32, height: 300)))
        contentView.layer.cornerRadius = 8
        contentView.backgroundColor = .blue
        popup.isSwipeDownToHidePopup = true
        popup.contentView = contentView
        popup.popupPosition = .center
        popup.animateStyle = .expanse
        popup.showPopup(in: self)
    }
    
    @IBAction func showPopup4(_ sender: Any) {
        let popup = BasePopupViewController()
        let contentView = UIView(frame: .init(origin: .zero, size: .init(width: view.frame.width - 32, height: 300)))
        contentView.layer.cornerRadius = 8
        contentView.backgroundColor = .blue
        popup.isSwipeDownToHidePopup = true
        popup.contentView = contentView
        popup.popupPosition = .center
        popup.animateStyle = .floatIn
        popup.showPopup(in: self)
    }
}
