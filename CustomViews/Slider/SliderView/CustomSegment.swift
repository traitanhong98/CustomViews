//
//  CustomSegment.swift
//  CustomViews
//
//  Created by ECO0542-HoangNM on 24/11/2021.
//

import UIKit

class CustomSegment: UIView {
    // MARK: - Properties
    private lazy var slideSegmentView: SlideSegmentView = {
        let segmentView = SlideSegmentView()
        segmentView.delegate = self
        segmentView.dataSource = self
        segmentView.isAutoResizing = true
        addSubview(segmentView)
        NSLayoutConstraint(item: segmentView, attribute: .centerX, relatedBy: .equal,
                           toItem: self, attribute: .centerX,
                           multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: segmentView, attribute: .centerY, relatedBy: .equal,
                           toItem: self, attribute: .centerY,
                           multiplier: 1, constant: 0).isActive = true
//        NSLayoutConstraint(item: segmentView, attribute: .leading, relatedBy: .equal,
//                           toItem: self, attribute: .leading,
//                           multiplier: 1, constant: 0).isActive = true
//        NSLayoutConstraint(item: segmentView, attribute: .top, relatedBy: .equal,
//                           toItem: self, attribute: .top,
//                           multiplier: 1, constant: 0).isActive = true
        return segmentView
    }()
    var listTitle: [NSMutableAttributedString] = [NSMutableAttributedString(string: "Segment 1"),
                                                  NSMutableAttributedString(string: "Segment 2")]
    // If array doesn't have enough color, the selected color will be first item
    var listSelectedColor: [UIColor] = [.blue]
    var leftPadding: CGFloat = 5
    var rightPadding: CGFloat = 5
    var topPadding: CGFloat = 0
    var bottomPadding: CGFloat = 0
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
    // MARK: - Func
    func reloadData() {
        slideSegmentView.reloadData()
    }
    
    func getTextSizeForAttributedString(_ attributedString: NSMutableAttributedString) -> CGSize {
        let largestSize = CGSize(width: frame.width,
                                 height: frame.height - topPadding - bottomPadding)
        let framesetter = CTFramesetterCreateWithAttributedString(attributedString)
        let textSize = CTFramesetterSuggestFrameSizeWithConstraints(framesetter, CFRange(), nil, largestSize, nil)
        return textSize
    }
}
// MARK: - SlideSegmentViewDelegate
extension CustomSegment: SlideSegmentViewDelegate {
    func slideSegmentView(_ view: SlideSegmentView, viewForButtonAtIndex index: Int) -> UIView {
        guard listTitle.count > index else {
            return UIView()
        }
        let attributedString = listTitle[index]
        let size = getTextSizeForAttributedString(attributedString)
        let containerView = UIView(frame: .init(origin: .zero,
                                                size: .init(width: size.width + leftPadding + rightPadding,
                                                            height: frame.height)))
        let label = UILabel()
        containerView.addSubview(label)
        NSLayoutConstraint(item: label, attribute: .centerX, relatedBy: .equal,
                           toItem: containerView, attribute: .centerX,
                           multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: label, attribute: .centerY, relatedBy: .equal,
                           toItem: containerView, attribute: .centerY,
                           multiplier: 1, constant: 0).isActive = true
        label.attributedText = attributedString
        return containerView
    }
    
    func slideSegmentView(_ view: SlideSegmentView, selectedColorAtIndex index: Int) -> UIColor {
        guard index < listSelectedColor.count else {
            return listSelectedColor.first ?? .blue
        }
        return listSelectedColor[index]
    }
}
// MARK: - SlideSegmentViewDataSource
extension CustomSegment: SlideSegmentViewDataSource {
    func numberOfButtonInSegmentView(_ segmentView: SlideSegmentView) -> Int {
        return listTitle.count
    }
}
