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
        let customView = UILabel()

        customView.frame = CGRect(x: 0, y: 0, width: 36, height: 36)

        customView.backgroundColor = .white


        let layer0 = CAGradientLayer()

        layer0.colors = [

          UIColor(red: 0.796, green: 0.039, blue: 0.514, alpha: 1).cgColor,

          UIColor(red: 0.357, green: 0.067, blue: 0.502, alpha: 1).cgColor

        ]

        layer0.locations = [0, 1]

        layer0.startPoint = CGPoint(x: 0.25, y: 0.5)

        layer0.endPoint = CGPoint(x: 0.75, y: 0.5)

        layer0.transform = CATransform3DMakeAffineTransform(CGAffineTransform(a: 1, b: 0, c: 0, d: 0.67, tx: 0, ty: -0.33))

        layer0.bounds = customView.bounds.insetBy(dx: -0.5*customView.bounds.size.width, dy: -0.5*customView.bounds.size.height)

        layer0.position = customView.center

        customView.layer.addSublayer(layer0)

        customView.layer.cornerRadius = 20
        self.view.addSubview(customView)
        customView.translatesAutoresizingMaskIntoConstraints = false

        customView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 100).isActive = true

        customView.topAnchor.constraint(equalTo: view.topAnchor, constant: 100).isActive = true
        customView.heightAnchor.constraint(equalToConstant: 36).isActive = true
        customView.widthAnchor.constraint(equalToConstant: 36).isActive = true
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
    @IBAction func hyperLink(_ sender: Any) {
        let vc = HyperLinkViewController()
        self.modalPresentationStyle = .overFullScreen
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: true)
    }
    @IBAction func textSizeAction(_ sender: Any) {
        let vc = LabelViewController()
        self.modalPresentationStyle = .overFullScreen
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: true)
    }
}

