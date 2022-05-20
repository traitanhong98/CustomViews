//
//  BasePopupViewController.swift
//  CustomViews
//
//  Created by ECO0542-HoangNM on 28/09/2021.
//

import UIKit

enum PopupPosition {
    case center
    case bottom
}

enum AnimateStyle {
    case floatIn
    case expanse
}

@objc
protocol BasePopupViewControllerDelegate {
    @objc
    optional func popupDidShow()
}

class BasePopupViewController: UIViewController {

    var popupPosition: PopupPosition = .center
    var animateStyle: AnimateStyle = .floatIn
    var isDismissWhenTappingAround: Bool = true
    var animateDuration: Double = 0.5
    var contentView: UIView?
    weak var delegate: BasePopupViewControllerDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func showPopup(in viewController: UIViewController) {
        self.modalPresentationStyle = .overFullScreen
        viewController.present(self, animated: false) {
            self.showContentView()
        }
    }
    
    private func showContentView() {
        guard let contentView = contentView else { return }
        contentView.alpha = 0
        self.view.addSubview(contentView)
        let originSize = contentView.frame.size
        switch self.animateStyle {
        case .expanse:
            contentView.frame.size = .init(width: originSize.width / 1.5, height:  originSize.height / 1.5)
            switch self.popupPosition {
            case .bottom:
                contentView.center = .init(x: view.center.x, y: view.frame.height - contentView.frame.height / 2)
            case .center:
                contentView.center = .init(x: view.center.x, y: view.center.y)
            }
        case .floatIn:
            switch self.popupPosition {
            case .bottom:
                contentView.center = .init(x: view.center.x, y: view.frame.height - contentView.frame.height / 2 + 100)
            case .center:
                contentView.center = .init(x: view.center.x, y: view.center.y + 100)
            }
        }
        UIView.animate(withDuration: animateDuration) {
            switch self.popupPosition {
            case .bottom:
                contentView.center = .init(x: self.view.center.x, y: self.view.frame.height - contentView.frame.height / 2)
            case .center:
                contentView.center = self.view.center
            }
            if self.animateStyle == .expanse {
                contentView.transform = CGAffineTransform(scaleX: 1.5, y: 1.5);
            }
            contentView.alpha = 1
        } completion: { _ in
            self.delegate?.popupDidShow?()
        }

    }
    
    func hidePopup() {
        hideContentView {
            self.dismiss(animated: false)
        }
    }
    
    private func hideContentView(completionBlock: @escaping ()-> Void) {
        guard let contentView = contentView else { return }
        UIView.animate(withDuration: animateDuration) {
            switch self.animateStyle {
            case .expanse:
                switch self.popupPosition {
                case .bottom:
                    contentView.center = .init(x: self.view.center.x, y: self.view.frame.height - contentView.frame.height / 2)
                case .center:
                    contentView.center = .init(x: self.view.center.x, y: self.view.center.y)
                }
                contentView.transform = CGAffineTransform(scaleX: 1/1.5, y: 1/1.5);
            case .floatIn:
                switch self.popupPosition {
                case .bottom:
                    contentView.center = .init(x: self.view.center.x, y: self.view.frame.height - contentView.frame.height / 2 + 100)
                case .center:
                    contentView.center = .init(x: self.view.center.x, y: self.view.center.y + 100)
                }
            }
            contentView.alpha = 0
        } completion: { _ in
            completionBlock()
        }
    }
    @IBAction func tapAround(_ sender: Any) {
        guard isDismissWhenTappingAround else { return }
        hidePopup()
    }
}
