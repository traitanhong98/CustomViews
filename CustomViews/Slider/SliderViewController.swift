//
//  SliderViewController.swift
//  CustomViews
//
//  Created by ECO0542-HoangNM on 25/09/2021.
//

import UIKit

class SliderViewController: UIViewController {
    // Slider
    @IBOutlet weak var slideView: SlideSegmentView!
    @IBOutlet weak var numberTextField: UITextField!
    @IBOutlet weak var labelSelected: UILabel!
    // Real segment
    @IBOutlet weak var numberOfSegment: UITextField!
    @IBOutlet weak var customSegment: CustomSegment!
    @IBOutlet weak var segmentInfo: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        slideView.delegate = self
        slideView.dataSource = self
        print("ViewDidLoad")
        customSegment.listTitle = getListSegment()
        customSegment.reloadData()
    }
    override func viewWillLayoutSubviews() {
        print("viewWillLayoutSubviews")
    }
    
    override func viewDidLayoutSubviews() {
        print("viewDidLayoutSubviews")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("viewWillAppear")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        print("viewDidAppear")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        print("viewWillDisappear")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        print("viewDidDisappear")
        
    }
    
    @IBAction func backAction(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @IBAction func update(_ sender: Any) {
        slideView.reloadData()
    }
    
    func getListSegment() -> [NSMutableAttributedString]{
        let att1 = AttributedStringBuilder(string: "Hello")
            .addFont(font: .systemFont(ofSize: 16), forSubString: "Hello")
            .addColor(color: .black, forSubString: "Hello")
            .build()
        let att2 = AttributedStringBuilder(string: "Hi")
            .addFont(font: .systemFont(ofSize: 20), forSubString: "Hi")
            .addColor(color: .black, forSubString: "Hi")
            .build()
        return [att1, att2]
    }
}

extension SliderViewController: SlideSegmentViewDataSource {
    func numberOfButtonInSegmentView(_ segmentView: SlideSegmentView) -> Int {
        return Int(numberTextField.text ?? "") ?? 1
    }
}

extension SliderViewController: SlideSegmentViewDelegate {
    func slideSegmentView(_ view: SlideSegmentView, viewForButtonAtIndex index: Int) -> UIView {
        let view = SegmentTitleView()
        view.backgroundColor = .clear
        view.label.text = String(index)
        return view
    }
    
    func slideSegmentView(_ view: SlideSegmentView, selectedColorAtIndex index: Int) -> UIColor {
        return [UIColor.blue, UIColor.green, UIColor.red][index % 3]
    }
    
    func slideSegmnetView(_ view: SlideSegmentView, willSelectSegmentAtIndex index: Int) -> Bool {
        return true
    }
    
    func slideSegmentView(_ view: SlideSegmentView, didSelectSegmentAtIndex index: Int) {
        labelSelected.text = "Selected segment index: \(index)"
    }
}
