//
//  SlideSegmentView.swift
//  POEMS GFO
//
//  Created by ECO0542-HoangNM on 25/09/2021.
//  Copyright © 2021 Market Simplified. All rights reserved.
//

import UIKit


@objc protocol SlideSegmentViewDelegate: AnyObject {
    @objc func slideSegmentView(_ view: SlideSegmentView, viewForButtonAtIndex index: Int) -> UIView
    @objc func slideSegmentView(_ view: SlideSegmentView, selectedColorAtIndex index: Int) -> UIColor
    // Selection
    @objc optional func slideSegmnetView(_ view: SlideSegmentView, willSelectSegmentAtIndex index: Int) -> Bool
    @objc optional func slideSegmentView(_ view: SlideSegmentView, didSelectSegmentAtIndex index: Int)
}

@objc protocol SlideSegmentViewDataSource: AnyObject {
    @objc func numberOfButtonInSegmentView(_ segmentView: SlideSegmentView) -> Int
}
@IBDesignable
class SlideSegmentView: UIView {
    
    @IBOutlet weak var contentView: UIView!
    var containerView = UIView()
    lazy var slideView: UIView = {
        let slideView = UIView()
        slideView.layer.cornerRadius = 6
        return slideView
    }()
    weak var delegate: SlideSegmentViewDelegate?
    weak var dataSource: SlideSegmentViewDataSource?
    var selectedSliderIndex = 0
    var animateDuration: Double = 0.2
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
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        self.backgroundColor = .red
    }
    func setupUI() {
    }
    
    override func layoutSubviews() {
        print("LayOutSubView")
        drawUI()
    }
    
    func reloadData() {
        selectedSliderIndex = 0
        drawUI()
    }
    
    func drawUI() {
        guard let delegate = delegate,
              let dataSource = dataSource else {
            return
        }
        containerView.removeFromSuperview()
        containerView = UIView()
        containerView.frame = contentView.bounds
        let numberOfButton = dataSource.numberOfButtonInSegmentView(self)
        let withOfButton = frame.width / CGFloat(numberOfButton)
        slideView.frame = .init(x: CGFloat(selectedSliderIndex) * withOfButton, y: 0, width: withOfButton, height: frame.height)
        slideView.backgroundColor = delegate.slideSegmentView(self, selectedColorAtIndex: selectedSliderIndex)
        containerView.addSubview(slideView)
        for index in 0..<numberOfButton {
            let buttonView = delegate.slideSegmentView(self, viewForButtonAtIndex: index)
            buttonView.frame = .init(x: CGFloat(index) * withOfButton, y: 0, width: withOfButton, height: frame.height)
            buttonView.tag = index
            let gesture = UITapGestureRecognizer(target: self, action: #selector(indexSelected(_:)))
            buttonView.addGestureRecognizer(gesture)
            containerView.addSubview(buttonView)
        }
        contentView.addSubview(containerView)
    }
    
    @objc private func indexSelected(_ gesture: UITapGestureRecognizer) {
        guard let delegate = delegate else {
            return
        }
        let viewIndex = gesture.view?.tag ?? -1
        guard delegate.slideSegmnetView?(self, willSelectSegmentAtIndex: viewIndex) ?? false else {
            return
        }
        delegate.slideSegmentView?(self, didSelectSegmentAtIndex: viewIndex)
        let numberOfButton = dataSource?.numberOfButtonInSegmentView(self) ?? 0
        let withOfButton = frame.width / CGFloat(numberOfButton)
        selectedSliderIndex = viewIndex
        UIView.animate(withDuration: animateDuration) {
            self.slideView.frame = .init(x: CGFloat(viewIndex) * withOfButton, y: 0, width: withOfButton, height: self.frame.height)
            self.slideView.backgroundColor = delegate.slideSegmentView(self, selectedColorAtIndex: viewIndex)
        }
    }
}
