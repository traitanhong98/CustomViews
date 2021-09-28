//
//  IncrementInputView.swift
//  CustomViews
//
//  Created by ECO0542-HoangNM on 25/09/2021.
//

import UIKit

protocol IncrementInputViewDelegate: AnyObject {
    func incrementInputViewDidSelectIncrease(_ view: IncrementInputView)
    func incrementInputViewDidSelectDecrease(_ view: IncrementInputView)
}
@IBDesignable
class IncrementInputView: UIView {

    @IBOutlet weak var keyLabel: UILabel!
    @IBOutlet weak var valueTextField: UITextField!
    @IBOutlet weak var increaseButton: UIButton!
    @IBOutlet weak var decreaseButton: UIButton!
    
    @IBInspectable var title: String? {
        didSet {
            keyLabel.text = title
        }
    }
    
    weak var delegate: IncrementInputViewDelegate?
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
    @IBAction func increaseAction(_ sender: Any) {
        delegate?.incrementInputViewDidSelectIncrease(self)
    }
    @IBAction func decreaseAction(_ sender: Any) {
        delegate?.incrementInputViewDidSelectDecrease(self)
    }
}
