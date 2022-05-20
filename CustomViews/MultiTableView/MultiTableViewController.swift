//
//  MultiTableViewController.swift
//  CustomViews
//
//  Created by ECO0542-HoangNM on 19/05/2022.
//

import UIKit

class MultiTableViewController: UIViewController {

    @IBOutlet weak var multiTableView: H_MultiTableView!

    var numberOfColumn = 4
    override func viewDidLoad() {
        super.viewDidLoad()
        multiTableView.dataSource = self
        multiTableView.delegate = self
        // Do any additional setup after loading the view.
      
    }
    @IBAction func tap(_ sender: Any) {
        numberOfColumn -= 1
        multiTableView.reloadBaseView()
    }
    
}

extension MultiTableViewController: H_MultiTableViewDataSource {
    func numberOfColumn(inTableView tableView: H_MultiTableView) -> Int {
        numberOfColumn
    }
    
    func multiTableView(_ multiTableView: H_MultiTableView, numberOfRowAt column: Int) -> Int {
        return 0
    }
    
    func multiTableView(_ multiTableView: H_MultiTableView, cellForRowAt indexPath: IndexPath, withColumn column: Int) -> UITableViewCell {
        return UITableViewCell()
    }
}

extension MultiTableViewController: H_MultiTableViewDelegate {
    func multiTableView(_ tableView: H_MultiTableView, widthForColumn column: Int) -> CGFloat {
        return view.frame.width / CGFloat(numberOfColumn)
    }
    
    func multiTableView(widthOfContent width: CGFloat, forColumn column: Int) -> CGFloat {
        return 300
    }
    
    func multiTableView(_ tableView: H_MultiTableView, heightForHeaderAt column: Int) -> CGFloat {
        50
    }
    func multiTableView(_ tableView: H_MultiTableView, viewForHeaderAt column: Int) -> UIView {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label)
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        return view
    }
}
