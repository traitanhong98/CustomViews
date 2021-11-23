//
//  CustomLabel.swift
//  CustomViews
//
//  Created by ECO0542-HoangNM on 11/10/2021.
//

import UIKit
import CoreText

class CustomLabel: UILabel {
    private var bouncingBox: CGRect = .zero
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
//            print(touch.location(in: self))
//            print(getCharacterIndexForPoint(touch.location(in: self)))
        }
    }
    
    
//    func attributedTextRangeForPoint(_ point: CGPoint) {
//        let indexOfCharacter = getCharacterIndexForPoint(point)
//
//    }
    
//    func getCharacterIndexForPoint(_ point: CGPoint) -> Int {
//        let bouncingBox = self.getAttributedTextBouncingBox()
//        let path = CGMutablePath()
//        path.addRect(bouncingBox)
//
//        let frameSetter = CTFramesetterCreateWithAttributedString(self.attributedText!)
//        let ctFrame = CTFramesetterCreateFrame(frameSetter, CFRangeMake(0, self.attributedText!.length), path, nil)
//
//        let verticalPadding = (frame.height - bouncingBox.height) / 2
//        let horizontalPadding = (frame.width - bouncingBox.width) / 2
//        let ctPointX = point.x - horizontalPadding
//        let ctPointY = (bouncingBox.height - (point.y - verticalPadding)) / 2
//        let ctPoint = CGPoint(x: ctPointX, y: ctPointY)
//
//        let lines = CTFrameGetLines(ctFrame)
//
//        var lineOrigins = Array<CGPoint>(repeating: CGPoint.zero, count: CFArrayGetCount(lines))
//        CTFrameGetLineOrigins(ctFrame, .init(location: 0, length: 0), &lineOrigins)
//
//        var indexOfCharacter = -1
//
//        for index in 0..<CFArrayGetCount(lines) {
//            let line = CFArrayGetValueAtIndex(lines, index)
//
//            var ascent: CGFloat = 0
//            var descent: CGFloat = 0
//            var leading: CGFloat = 0
//            CTLineGetTypographicBounds(lines as! CTLine, &ascent, &descent, &leading)
//
//            let origins = lineOrigins[index]
//
//            if ctPointY > origins.y - descent {
//                indexOfCharacter = CTLineGetStringIndexForPosition(line as! CTLine, ctPoint)
//                break
//            }
//        }
//
//        return indexOfCharacter;
//    }
    
//    func getAttributedTextBouncingBox() -> CGRect {
//        if bouncingBox.width != 0 {
//            return bouncingBox
//        }
//
//        let layoutManager = NSLayoutManager()
//        let textContainer = NSTextContainer()
//
//        textContainer.lineFragmentPadding = 0
//        textContainer.lineBreakMode = lineBreakMode
//        textContainer.maximumNumberOfLines = self.numberOfLines
//        textContainer.size = bounds.size
//        layoutManager.addTextContainer(textContainer)
//
//        let storage = NSTextStorage(attributedString: attributedText ?? NSAttributedString())
//        storage.addLayoutManager(layoutManager)
//
//        var bouncingBox = layoutManager.usedRect(for: textContainer)
//
//        var height: CGFloat = 0
//        let frameSetter = CTFramesetterCreateWithAttributedString(attributedText ?? NSAttributedString())
//        var box = CGRect(x: 0, y: 0, width: bouncingBox.width, height: CGFloat.greatestFiniteMagnitude)
//        let startIndex: CFIndex = 0
//        let path = CGMutablePath()
//        path.addRect(box)
//        let frame = CTFramesetterCreateFrame(frameSetter, CFRangeMake(startIndex, 0), path, nil)
//
//        let lineArray = CTFrameGetLines(frame)
//        var lineCount = CFArrayGetCount(lineArray)
//        if lineCount > numberOfLines && numberOfLines != 0 {
//            lineCount = numberOfLines
//        }
//
//        var h: CGFloat = 0
//        var ascent: CGFloat = 0
//        var descent: CGFloat = 0
//        var leading: CGFloat = 0
//
//        for index in 0..<lineCount {
//            let currentLine = CFArrayGetValueAtIndex(lineArray, index)
//            CTLineGetTypographicBounds(currentLine, &ascent, &descent, &leading)
//            h = ascent + descent + leading
//            height += h
//        }
//        box.size.height = height
//        bouncingBox = box
//
//        return bouncingBox
//    }

}
