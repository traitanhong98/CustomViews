//
//  Builder.swift
//  CustomViews
//
//  Created by ECO0542-HoangNM on 11/10/2021.
//

import UIKit


class AttributedStringBuilder {
    var attributedString: NSMutableAttributedString
    init(string: String) {
        self.attributedString = NSMutableAttributedString(string: string)
    }
    func build() -> NSMutableAttributedString {
        return self.attributedString
    }
    // Single substring
    func addFont(font: UIFont, forSubString subString: String) -> AttributedStringBuilder {
        self.attributedString.addAttributes([NSMutableAttributedString.Key.font: font],
                                            range: self.attributedString.mutableString.range(of: subString))
        return self
    }
    
    func addColor(color: UIColor, forSubString subString: String) -> AttributedStringBuilder {
        self.attributedString.addAttributes([NSMutableAttributedString.Key.foregroundColor: color],
                                            range: self.attributedString.mutableString.range(of: subString))
        return self
    }
    
    func addLink(url: String, forSubString subString: String) -> AttributedStringBuilder {
        self.attributedString.addAttributes([NSMutableAttributedString.Key.link: url],
                                            range: self.attributedString.mutableString.range(of: subString))
        return self
    }
    func addBackGroundColor(_ color: UIColor, forSubString subString: String) -> AttributedStringBuilder {
        self.attributedString.addAttributes([NSMutableAttributedString.Key.backgroundColor: color],
                                            range: self.attributedString.mutableString.range(of: subString))
        return self
    }
    func addForgegroundColor(_ color: UIColor, forSubString subString: String) -> AttributedStringBuilder {
        self.attributedString.addAttributes([NSMutableAttributedString.Key.foregroundColor: color],
                                            range: self.attributedString.mutableString.range(of: subString))
        return self
    }
    func addParagrapStyle(_ style: NSParagraphStyle, forSubString subString: String) -> AttributedStringBuilder {
        self.attributedString.addAttributes([NSMutableAttributedString.Key.paragraphStyle: style],
                                            range: self.attributedString.mutableString.range(of: subString))
        return self
    }
    // Multiple
    func addFonts(font: UIFont, forSubStrings subStrings: [String]) -> AttributedStringBuilder {
        subStrings.forEach({
            self.attributedString.addAttributes([NSMutableAttributedString.Key.font: font],
                                                range: self.attributedString.mutableString.range(of: $0))
        })
        return self
    }
    
    func addColors(color: UIColor, forSubStrings subStrings: [String]) -> AttributedStringBuilder {
        subStrings.forEach({
            self.attributedString.addAttributes([NSMutableAttributedString.Key.foregroundColor: color],
                                                range: self.attributedString.mutableString.range(of: $0))
        })
        return self
    }
}
