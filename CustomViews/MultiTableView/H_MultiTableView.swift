//
//  H_MultiTableView.swift
//  CustomViews
//
//  Created by ECO0542-HoangNM on 19/05/2022.
//

import UIKit

var keyScrollViewTag: Int = 500
var keyTableViewTag: Int {
    keyScrollViewTag + 500
}
var keyTableHeaderViewTag: Int {
    keyTableViewTag + 500
}

@objc protocol H_MultiTableViewDataSource: AnyObject {
    func numberOfColumn(inTableView tableView: H_MultiTableView) -> Int
    @objc optional func numberOfSection(inTableView tableView: H_MultiTableView) -> Int
    func multiTableView(_ multiTableView: H_MultiTableView, numberOfRowAt column: Int) -> Int
    func multiTableView(_ multiTableView: H_MultiTableView, cellForRowAt indexPath: IndexPath, withColumn column: Int) -> UITableViewCell
}

@objc protocol H_MultiTableViewDelegate: AnyObject {
    func multiTableView(_ tableView: H_MultiTableView, widthForColumn column: Int) -> CGFloat
    func multiTableView(widthOfContent width: CGFloat, forColumn column: Int) -> CGFloat
    // Big header
    @objc optional func multiTableView(_ tableView: H_MultiTableView, heightForHeaderAt column: Int) -> CGFloat
    @objc optional func multiTableView(_ tableView: H_MultiTableView, viewForHeaderAt column: Int) -> UIView
    // SectionHeader
    @objc optional func multiTableView(_ tableView: H_MultiTableView, heightForHeaderInSection section: Int) -> CGFloat
    @objc optional func multiTableView(_ tableView: H_MultiTableView, viewForHeaderInSection section: Int, withColumn column: Int) -> UIView
    // SectionFooter
    @objc optional func multiTableView(_ tableView: H_MultiTableView, heightForFooterInSection section: Int) -> CGFloat
    @objc optional func multiTableView(_ tableView: H_MultiTableView, viewForFooterInSection section: Int, withColumn column: Int) -> UIView
    // For Row
    @objc optional func multiTableView(_ tableView: H_MultiTableView, heighForRowAt indexPath: IndexPath, withColumn column: Int) -> CGFloat
    @objc optional func multiTableView(_ tableView: H_MultiTableView, didSelectRowAt indexPath: IndexPath, withColumn column: Int)
}

class H_MultiTableView: UIView {
    // Header
    private var headerView: UIView?
    private var headerHeight: CGFloat = 0
    // Footer
    private var footerView: UIView?
    private var footerHeight: CGFloat = 0
    // Pull to refresh
    private var scrollBeginOffsetY: CGFloat = 0
    private var previousOffsetY: CGFloat = 0
    private var maxPullToRefreshOrigin: Int = 0
    private var shoulAllowPullToRefresh: Bool = true
    private var isRefreshCallFired: Bool = true
    private var animatingView: UIView?
    
    weak var dataSource: H_MultiTableViewDataSource? {
        didSet {
            self.initBaseView()
        }
    }
    weak var delegate: H_MultiTableViewDelegate?
    // MARK: - LifeCycle
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func initBaseView() {
        guard let dataSource = dataSource else {
            return
        }
        subviews.forEach({$0.removeFromSuperview()})
        let numberOfColumn = dataSource.numberOfColumn(inTableView: self)
        for i in 0..<numberOfColumn {
            let scrollView = UIScrollView()
            scrollView.tag = keyScrollViewTag + i
            scrollView.backgroundColor = .clear
            scrollView.isDirectionalLockEnabled = true
            scrollView.showsVerticalScrollIndicator = false
            scrollView.showsHorizontalScrollIndicator = false
            scrollView.translatesAutoresizingMaskIntoConstraints = false
            scrollView.delegate = self
            
            // Table
            let tableView = UITableView()
            tableView.showsVerticalScrollIndicator = false
            tableView.showsHorizontalScrollIndicator = false
            tableView.tag = keyTableViewTag + i
            tableView.delegate = self
            tableView.dataSource = self
            tableView.keyboardDismissMode = .onDrag
            tableView.autoresizesSubviews = true
            tableView.separatorStyle = .none
            tableView.backgroundColor = .clear
            tableView.tableFooterView = UIView(frame: .zero)
            scrollView.addSubview(tableView)
            
            self.addSubview(scrollView)
            if #available(iOS 15.0, *) {
                tableView.sectionHeaderTopPadding = 0
            }
        }
    }
    
    private func reframeBaseView() {
        guard let delegate = delegate,
              let dataSource = dataSource else {
            return
        }
        let numberOfColumn = dataSource.numberOfColumn(inTableView: self)
        var offsetX: CGFloat = 0
        for column in 0..<numberOfColumn {
            if let scrollView = viewWithTag(keyScrollViewTag + column) as? UIScrollView {
                
                let widthForColumn = delegate.multiTableView(self, widthForColumn: column)
                let contentWidth = delegate.multiTableView(widthOfContent: widthForColumn, forColumn: column)
                let headerHeight = delegate.multiTableView?(self, heightForHeaderAt: column) ?? 0
                
                scrollView.frame = .init(x: offsetX,
                                         y: headerHeight,
                                         width: widthForColumn,
                                         height: frame.height)
                scrollView.contentSize = .init(width: contentWidth, height: scrollView.frame.height)
                var headerView = viewWithTag(keyTableHeaderViewTag + column)
                if headerView == nil,
                   let newHeaderView = delegate.multiTableView?(self, viewForHeaderAt: column) {
                    headerView = newHeaderView
                    scrollView.addSubview(newHeaderView)
                }
                if let headerView = headerView {
                    var frame = headerView.frame
                    frame.size.height = headerHeight
                    frame.size.width = contentWidth
                    headerView.frame = frame
                }
                
                if let tableView = viewWithTag(keyTableViewTag + column) {
                    
                    tableView.frame = .init(x: tableView.frame.origin.x,
                                            y: tableView.frame.origin.y,
                                            width: contentWidth,
                                            height: scrollView.frame.height)
                }
                offsetX += widthForColumn
            }
        }
    }
    
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        reframeBaseView()
    }
    
    // MARK: - Catagory Instances methods
    func tableForColumn(_ column: Int) -> UITableView? {
        return viewWithTag(keyScrollViewTag + column)?.viewWithTag(keyTableViewTag + column) as? UITableView
    }
    // MARK: - InstanceMethod
    func reuseHeaderForColumn(_ column: Int) -> UIView? {
        let scrollview = viewWithTag(keyScrollViewTag + column)
        return scrollview?.viewWithTag(keyTableHeaderViewTag + column)
    }
    
    func getVisibleCellsForColumn(_ column: Int) -> [UITableViewCell]? {
        return tableForColumn(column)?.visibleCells
    }
    
    func reloadBaseView() {
        initBaseView()
        reframeBaseView()
        reloadData()
    }
    
    func reloadData() {
        if let numberOfColumn = dataSource?.numberOfColumn(inTableView: self) {
            for column in 0..<numberOfColumn {
                self.tableForColumn(column)?.reloadData()
            }
        }
    }
    
    func scrollToRowAtIndexPath(_ indexPath: IndexPath, atScrollPosition position: UITableView.ScrollPosition, animated: Bool) {
        if let numberOfColumn = dataSource?.numberOfColumn(inTableView: self) {
            for column in 0..<numberOfColumn {
                self.tableForColumn(column)?.scrollToRow(at: indexPath, at: position, animated: animated)
            }
        }
    }
}

extension H_MultiTableView: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataSource?.numberOfSection?(inTableView: self) ?? 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let column = tableView.tag - keyTableViewTag
        return dataSource?.multiTableView(self, numberOfRowAt: column) ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let column = tableView.tag - keyTableViewTag
        return dataSource?.multiTableView(self, cellForRowAt: indexPath, withColumn: column) ?? UITableViewCell()
    }
}

extension H_MultiTableView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let column = tableView.tag - keyTableViewTag
        delegate?.multiTableView?(self, didSelectRowAt: indexPath, withColumn: column)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        delegate?.multiTableView?(self, heightForHeaderInSection: section) ?? 0.1
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let column = tableView.tag - keyTableViewTag
        return delegate?.multiTableView?(self, viewForHeaderInSection: section, withColumn: column)
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        delegate?.multiTableView?(self, heightForFooterInSection: section) ?? 0.1
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let column = tableView.tag - keyTableViewTag
        return delegate?.multiTableView?(self, viewForFooterInSection: section, withColumn: column)
    }
}

extension H_MultiTableView: UIScrollViewDelegate {
    
}
