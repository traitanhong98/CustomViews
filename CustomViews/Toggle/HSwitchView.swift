//
//  HSwitchView.swift
//  CustomViews
//
//  Created by ECO0542-HoangNM on 12/05/2023.
//

import UIKit

@IBDesignable
class HSwitchView: UIView {
    private var switchContentLeftConstraint: NSLayoutConstraint!
    private var switchContentRightConstraint: NSLayoutConstraint!
    private var switchContent: UIView! = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.shadowColor = UIColor.lightGray.cgColor
        view.layer.shadowRadius = 10
        view.layer.shadowOpacity = 5
        return view
    }()
    
    private var button: UIButton! = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    @IBInspectable var isOn: Bool = false {
        didSet {
            UIView.animate(withDuration: 0.2) {
                self.isUserInteractionEnabled = false
                self.switchContentLeftConstraint.isActive = !self.isOn
                self.switchContentRightConstraint.isActive = self.isOn
                self.fillColor()
                self.layoutIfNeeded()
            } completion: { isComplete in
                self.isUserInteractionEnabled = true
            }
        }
    }
    
    @IBInspectable var isRounded: Bool = true
    
    @IBInspectable var cornerRadius: CGFloat {
        get {
            layer.cornerRadius
        }
        
        set {
            guard !isRounded else { return }
            layer.cornerRadius = newValue
            switchContent.layer.cornerRadius = newValue
        }
    }
    
    @IBInspectable var activeContentColor: UIColor = .blue
    @IBInspectable var activeBackgroundColor: UIColor = .blue.withAlphaComponent(0.5)
    @IBInspectable var normalContentColor: UIColor = .gray
    @IBInspectable var normalBackgroundColor: UIColor = .gray.withAlphaComponent(0.5)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        drawUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        drawUI()
    }
    
    init() {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        drawUI()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if isRounded {
            layer.cornerRadius = frame.height / 2
            switchContent.layer.cornerRadius = frame.height / 2
        }
    }
    
    private func fillColor() {
        switchContent.backgroundColor = isOn ? activeContentColor : normalContentColor
        backgroundColor = isOn ? activeBackgroundColor : normalBackgroundColor
    }
    
    private func setupUI() {
        button.addTarget(self, action: #selector(onTap), for: .touchUpInside)
        clipsToBounds = true
    }
    
    @objc private func onTap() {
        isOn.toggle()
    }
    
    private func drawUI() {
        addSubview(switchContent)
        switchContentLeftConstraint = switchContent.leftAnchor.constraint(equalTo: leftAnchor, constant: 0)
        switchContentRightConstraint = switchContent.rightAnchor.constraint(equalTo: rightAnchor, constant: 0)
        NSLayoutConstraint.activate([
            switchContent.topAnchor.constraint(equalTo: topAnchor, constant: 0),
            switchContent.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0),
            switchContent.heightAnchor.constraint(equalTo: switchContent.widthAnchor)
        ])
        switchContentLeftConstraint.isActive = !isOn
        switchContentRightConstraint.isActive = isOn
        
        addSubview(button)
        NSLayoutConstraint.activate([
            button.topAnchor.constraint(equalTo: topAnchor, constant: 0),
            button.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0),
            button.leftAnchor.constraint(equalTo: leftAnchor, constant: 0),
            button.rightAnchor.constraint(equalTo: rightAnchor, constant: 0)
        ])
        
        fillColor()
        setupUI()
    }
 }
