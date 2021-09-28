//
//  TestTextFieldViewController.swift
//  CustomViews
//
//  Created by ECO0542-HoangNM on 25/09/2021.
//

import UIKit

class TestTextFieldViewController: UIViewController {

    @IBOutlet weak var viewA: IncrementInputView!
    @IBOutlet weak var viewB: IncrementInputView!
    @IBOutlet weak var viewC: IncrementInputView!
    @IBOutlet weak var viewD: IncrementInputView!
    @IBOutlet weak var contentScrollView: UIScrollView!
    
    @IBOutlet weak var containerView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        contentScrollView.autoFitKeyBoard()
    }
    
    @IBAction func backAction(_ sender: Any) {
        dismiss(animated: true)
    }
}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

class CommonFunction {
    static func getPortraitKeyboardHeight() -> CGFloat {
        if UIDevice().userInterfaceIdiom == .phone {
                return 300

        }
        return 372
    }
}

extension UIView {
    func autoFitKeyBoard() {
        NotificationCenter.default.addObserver( self, selector: #selector(keyboardWillShow(_:)), name:  UIResponder.keyboardWillShowNotification, object: nil )
        NotificationCenter.default.addObserver( self, selector: #selector(keyboardWillHide(_:)), name:  UIResponder.keyboardWillHideNotification, object: nil )
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        guard let edittingview = getEdittingView(fromView: self),
              let windowSize = window?.frame.size,
              let thisViewPoint = self.superview?.convert(frame.origin, to: window),
              let firstResponserPoint = edittingview.superview?.convert(edittingview.frame.origin,
                                                              to: window) else { return }
        let bottomSpace = windowSize.height - thisViewPoint.y - frame.height
        if bottomSpace > CommonFunction.getPortraitKeyboardHeight() {
            return
        }
        let toMoveOffset = windowSize.height - ( CommonFunction.getPortraitKeyboardHeight() + 35)
        
        let keyBoardOffset = (firstResponserPoint.y + edittingview.frame.size.height + 5) - toMoveOffset
        if keyBoardOffset > 0 {
            frame.origin.y -= keyBoardOffset
        }
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        superview?.setNeedsLayout()
        superview?.layoutIfNeeded()
    }
    
    func getEdittingView(fromView view: UIView) -> UIView? {
        if view.isFirstResponder {
            return view
        }
        if view.subviews.isEmpty {
            return nil
        }
        for subView in view.subviews {
            if let editingView = getEdittingView(fromView: subView) {
                return editingView
            }
        }
        return nil
    }
}

