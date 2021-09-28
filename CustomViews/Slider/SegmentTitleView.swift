//
//  SegmentTitleView.swift
//  CustomViews
//
//  Created by ECO0542-HoangNM on 25/09/2021.
//

import UIKit

class SegmentTitleView: UIView {
    @IBOutlet weak var label: UILabel!
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
