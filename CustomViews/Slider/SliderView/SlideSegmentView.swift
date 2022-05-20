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
    @objc optional func slideSegmentViewDidFinishAnimate(_ view: SlideSegmentView)
    @objc optional func slideSegmnetView(_ view: SlideSegmentView, willSelectSegmentAtIndex index: Int) -> Bool
    @objc optional func slideSegmentView(_ view: SlideSegmentView, didSelectSegmentAtIndex index: Int)
}

@objc protocol SlideSegmentViewDataSource: AnyObject {
    @objc func numberOfButtonInSegmentView(_ segmentView: SlideSegmentView) -> Int
}

@IBDesignable
class SlideSegmentView: UIView {
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
    var ideaWithForItem: CGFloat = .infinity
    var isAutoResizing: Bool = false
    // MARK: - LifeCycle
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    init() {
        super.init(frame: .zero)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        drawUI()
    }
    // MARK: - Func
    func reloadData() {
        selectedSliderIndex = 0
        setNeedsLayout()
    }
    
    func drawUI() {
        guard let delegate = delegate,
              let dataSource = dataSource else {
            return
        }
        containerView.removeFromSuperview()
        containerView = UIView()
        isAutoResizing ? self.frame.size.width = 0 : nil
        containerView.frame = self.bounds
        let numberOfButton = dataSource.numberOfButtonInSegmentView(self)
        let availableWidthForButton = frame.width / CGFloat(numberOfButton)
        let withOfButton = availableWidthForButton > ideaWithForItem ? ideaWithForItem : availableWidthForButton
        var currentX: CGFloat = 0
        slideView.frame = .init(x: CGFloat(selectedSliderIndex) * withOfButton, y: 0, width: withOfButton, height: frame.height)
        slideView.backgroundColor = delegate.slideSegmentView(self, selectedColorAtIndex: selectedSliderIndex)
        slideView.layer.cornerRadius = frame.height / 2
        self.layer.cornerRadius = frame.height / 2
        containerView.addSubview(slideView)
        for index in 0..<numberOfButton {
            let buttonView = delegate.slideSegmentView(self, viewForButtonAtIndex: index)
            buttonView.frame = .init(x: currentX,
                                     y: 0,
                                     width: isAutoResizing ? buttonView.frame.width : withOfButton,
                                     height: frame.height)
            buttonView.tag = index
            let gesture = UITapGestureRecognizer(target: self, action: #selector(indexSelected(_:)))
            buttonView.addGestureRecognizer(gesture)
            containerView.addSubview(buttonView)
            currentX += buttonView.frame.width
            isAutoResizing ? self.frame.size.width += (isAutoResizing ? buttonView.frame.width : withOfButton) : nil
        }
        addSubview(containerView)
    }
    
    @objc private func indexSelected(_ gesture: UITapGestureRecognizer) {
        guard let delegate = delegate else {
            return
        }
        let viewIndex = gesture.view?.tag ?? -1
        guard delegate.slideSegmnetView?(self, willSelectSegmentAtIndex: viewIndex) ?? true else {
            return
        }
        delegate.slideSegmentView?(self, didSelectSegmentAtIndex: viewIndex)
        let numberOfButton = dataSource?.numberOfButtonInSegmentView(self) ?? 0
        var withOfButton = frame.width / CGFloat(numberOfButton)
        if isAutoResizing {
            withOfButton = gesture.view?.frame.width ?? 0
        }
        selectedSliderIndex = viewIndex
        UIView.animate(withDuration: animateDuration) {
            self.slideView.frame = .init(x: CGFloat(viewIndex) * withOfButton, y: 0, width: withOfButton, height: self.frame.height)
            self.slideView.backgroundColor = delegate.slideSegmentView(self, selectedColorAtIndex: viewIndex)
        } completion: { [weak self] _ in
            guard let self = self else { return }
            self.delegate?.slideSegmentViewDidFinishAnimate?(self)
        }
    }
}
