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
    @objc optional func popupDidShow()
    @objc optional func popupDidHide()
}

class BasePopupViewController: UIViewController {
    // MARK: - Public
    var popupPosition: PopupPosition = .center
    var animateStyle: AnimateStyle = .floatIn
    var isDismissWhenTappingAround: Bool = true
    var animateDuration: Double = 0.3
    var movingDistance: Double = 70
    var contentView: UIView?
    var isSwipeDownToHidePopup: Bool = false
    var isAvoidKeyboard: Bool = true
    var popupDidShow: (() -> Void)?
    var popupDidHide: (() -> Void)?
    // MARK: - Private
    private var gestureStartLocation: CGPoint = .zero
    weak var popupDelegate: BasePopupViewControllerDelegate?
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    // MARK: - Show/Hide
    func showPopup(in viewController: UIViewController) {
        loadViewIfNeeded()
        viewController.view.addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        willMove(toParent: viewController)
        viewController.addChild(self)
        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: viewController.view.topAnchor),
            view.bottomAnchor.constraint(equalTo: viewController.view.bottomAnchor),
            view.leadingAnchor.constraint(equalTo: viewController.view.leadingAnchor),
            view.trailingAnchor.constraint(equalTo: viewController.view.trailingAnchor)
        ])
        view.frame = viewController.view.bounds
        showContentView()
    }
    
    func hidePopup() {
        hideContentView {
            self.view.removeFromSuperview()
            self.removeFromParent()
        }
    }
    
    // MARK: - Handle ContentView
    private func showContentView() {
        guard let contentView = contentView else { return }
        contentView.alpha = 0
        view.backgroundColor = .clear
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
                contentView.center = .init(x: view.center.x, y: view.frame.height - contentView.frame.height / 2 + movingDistance)
            case .center:
                contentView.center = .init(x: view.center.x, y: view.center.y + movingDistance)
            }
        }
        UIView.animate(withDuration: animateDuration) {
            switch self.popupPosition {
            case .bottom:
                if self.animateStyle == .expanse {
                    contentView.frame.size = originSize
                }
                contentView.center = .init(x: self.view.center.x, y: self.view.frame.height - contentView.frame.height / 2)
            case .center:
                contentView.center = self.view.center
            }
            contentView.alpha = 1
            self.view.backgroundColor = .black.withAlphaComponent(0.1)
        } completion: { [weak self] _ in
            guard let self = self else { return }
            self.isDismissWhenTappingAround ? self.setupHideWhenTapAround() : nil
            self.isSwipeDownToHidePopup ? self.setUpSwipeToHide() : nil
            if let delegate = self.popupDelegate {
                delegate.popupDidShow?()
            } else {
                self.popupDidShow?()
            }
        }
    }
    
    private func hideContentView(completionBlock: @escaping ()-> Void) {
        guard let contentView = contentView else { return }
        UIView.animate(withDuration: animateDuration) {
            switch self.animateStyle {
            case .expanse:
                contentView.transform = CGAffineTransform(scaleX: 1/1.5, y: 1/1.5);
            case .floatIn:
                switch self.popupPosition {
                case .bottom:
                    contentView.center = .init(x: self.view.center.x, y: max(self.view.frame.height - contentView.frame.height / 2 + self.movingDistance, contentView.center.y))
                case .center:
                    contentView.center = .init(x: self.view.center.x, y: max(self.view.center.y + self.movingDistance, contentView.center.y))
                }
            }
            contentView.alpha = 0
        } completion: { _ in
            completionBlock()
        }
    }
    // MARK: - Tapped around
    @objc func tapAround(_ sender: Any) {
        guard isDismissWhenTappingAround else { return }
        hidePopup()
    }
    
    func setupHideWhenTapAround() {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(tapAround(_:)))
        let invisibleView = UIView()
        invisibleView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(invisibleView)
        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: invisibleView.topAnchor),
            view.bottomAnchor.constraint(equalTo: invisibleView.bottomAnchor),
            view.leadingAnchor.constraint(equalTo: invisibleView.leadingAnchor),
            view.trailingAnchor.constraint(equalTo: invisibleView.trailingAnchor)
        ])
        invisibleView.addGestureRecognizer(gesture)
        view.sendSubviewToBack(invisibleView)
    }
    // MARK: - Swipe Down
    func setUpSwipeToHide() {
        guard let contentView = contentView else { return }
        let gesture = UIPanGestureRecognizer(
            target: self,
            action: #selector(handlePanGesture(_:))
        )
        gesture.cancelsTouchesInView = false
        contentView.addGestureRecognizer(gesture)
    }
    
    @objc func handlePanGesture(_ gesture: UIPanGestureRecognizer) {
        switch gesture.state {
        case .began:
            view.endEditing(true)
            let location = gesture.location(in: self.view)
            gestureStartLocation = location
        case .changed: ()
            guard let contentView =  contentView else { return }
            let currentLocation = gesture.location(in: self.view)
            // offSetY > 0 -> swipeDown
            // offSetY < 0 -> swipeUp
            let offSetY = currentLocation.y - gestureStartLocation.y
            guard offSetY > 0 else { return }
            let offSetToCalculateAlpha = min(offSetY, movingDistance)
            let alpha: CGFloat = 1 - min(offSetToCalculateAlpha / movingDistance, 0.9)
            contentView.alpha = alpha
            switch self.popupPosition {
            case .bottom:
                contentView.center = .init(x: self.view.center.x, y: self.view.frame.height - contentView.frame.height / 2 + offSetY)
            case .center:
                contentView.center = .init(x: self.view.center.x, y: self.view.center.y + offSetY) 
            }
        case .ended: ()
            guard let contentView =  contentView else { return }
            let lastLocaltion = gesture.location(in: self.view)
            let offSetY = lastLocaltion.y - gestureStartLocation.y
            guard offSetY > 0 else { return }
            let offSetToCalculateDistance = min(offSetY, movingDistance)
            if offSetToCalculateDistance / movingDistance > 0.7 {
                self.hidePopup()
            } else {
                UIView.animate(withDuration: animateDuration) { [weak self] in
                    guard let self = self,
                          let contentView = self.contentView else {
                        return
                    }
                    switch self.popupPosition {
                    case .bottom:
                        contentView.center = .init(x: self.view.center.x, y: self.view.frame.height - contentView.frame.height / 2)
                    case .center:
                        contentView.center = self.view.center
                    }
                } completion: { _ in
                    contentView.alpha = 1
                }
            }
            
        default: ()
        }
    }
}


