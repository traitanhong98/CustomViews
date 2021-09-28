//
//  ViewController.swift
//  CustomViews
//
//  Created by ECO0542-HoangNM on 25/09/2021.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var someView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        print("ViewDidLoad")
    }
    
    @IBAction func buttonAction(_ sender: Any) {
        let vc = SliderViewController()
        self.modalPresentationStyle = .overFullScreen
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: true)
    }
    
    @IBAction func testTextfieldAction(_ sender: Any) {
        let vc = TestTextFieldViewController()
        self.modalPresentationStyle = .overFullScreen
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: true)
    }
    @IBAction func showPopup(_ sender: Any) {
        let vc = PopupViewController()
        self.modalPresentationStyle = .overFullScreen
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: true)
    }
}

