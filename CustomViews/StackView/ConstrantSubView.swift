//
//  ConstrantSubView.swift
//  CustomViews
//
//  Created by ECO0542-HoangNM on 25/04/2022.
//

import UIKit

class ConstrantSubView: UIView {
    var myProperties = 0
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadViewFromNib()
        setupUI()
    }
    
    init() {
        super.init(frame: .zero)
        loadViewFromNib()
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadViewFromNib()
        setupUI()
    }
    
    func setupUI() {
    }
    
}
