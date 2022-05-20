//
//  LabelViewController.swift
//  CustomViews
//
//  Created by ECO0542-HoangNM on 24/11/2021.
//

import UIKit
import CoreText

class LabelViewController: UIViewController {

    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var inputTextView: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }


    override func viewDidLayoutSubviews() {
        let textSize = getTextSize(text: textLabel.text ?? "")
        infoLabel.text = """
TextLabel: \(textLabel.frame.width) : \(textLabel.frame.height)
TextSize: \(textSize.width) : \(textSize.height)
"""
        
    }

    @IBAction func updateAction(_ sender: Any) {
//        textLabel.text = inputTextView.text
//        let text = inputTextView.text ?? ""
//        let path = CGMutablePath()
//        let attributedString = AttributedStringBuilder(string: text)
//            .addFont(font: .systemFont(ofSize: 17), forSubString: text)
//            .build()
//        path.addRect(.init(origin: inputTextView.frame.origin, size: getTextSize(text: text)))
//        let framesetter = attributedString.framesetter()
//        let frame = framesetter.createFrame(path)
//        let origins = frame.lineOrigins()
//
//        let lines = frame.lines()
//        let lastLineIndex = origins.count - 1
//        let lastLine = lines[lastLineIndex]
//
//        var xLine: CGFloat = 0
//        var yLine: CGFloat = 0
//        if let lastRun = lastLine.glyphRuns().last {
//            let font = lastRun.font
//            let glyphs = lastRun.glyphs()
//            let glyphsBoundingRects =  font.boundingRects(of: glyphs)
//            let glyphPositions = lastRun.glyphPositions()
//            xLine += (glyphPositions.last ?? .zero).x + (glyphsBoundingRects.last ?? .zero).width
//            yLine += origins[0].y
//        }
//
//        if let lastDotView = view.viewWithTag(999) {
//            lastDotView.removeFromSuperview()
//        }
//        let dotView = UIView(frame: .init(origin: .init(x: xLine, y: yLine ),
//                                          size: .init(width: 10, height: 10)))
//        dotView.tag = 999
//        dotView.backgroundColor = .red
//        textLabel.addSubview(dotView)
        textLabel.text = "\(Date().timeIntervalSince1970)"
    }
    
    func getTextSize(text: String) -> CGSize {
        let string = text
        let font = UIFont.systemFont(ofSize: 17)
        let attributes: [NSAttributedString.Key: Any] = [.font: font]
        let attributedString = NSAttributedString(string: string, attributes: attributes)
        let largestSize = CGSize(width: inputTextView.frame.width,
                                 height: .greatestFiniteMagnitude)

        let framesetter = CTFramesetterCreateWithAttributedString(attributedString)
        let textSize = CTFramesetterSuggestFrameSizeWithConstraints(framesetter, CFRange(), nil, largestSize, nil)
        
        return textSize
    }
    

  
}
