//
//  ZKCycleScrollView.swift
//  ZKSwiftProject
//
//  Created by bestdew on 2018/12/30.
//  Copyright © 2018 bestdew. All rights reserved.
//

import UIKit

public typealias ZKCycleScrollViewCell = UICollectionViewCell

public enum ZKScrollDirection: Int {
    case horizontal
    case vertical
}

@objc public protocol ZKCycleScrollViewDelegate: NSObjectProtocol {
    @objc optional func cycleScrollView(_ cycleScrollView: ZKCycleScrollView, didSelectItemAt indexPath: IndexPath)
    @objc optional func cycleScrollViewDidScroll(_ cycleScrollView: ZKCycleScrollView)
    @objc optional func cycleScrollView(_ cycleScrollView: ZKCycleScrollView, didScrollTo indexPath: IndexPath)
}

@objc public protocol ZKCycleScrollViewDataSource: NSObjectProtocol {
    @objc func numberOfItems(in cycleScrollView: ZKCycleScrollView) -> Int
    @objc func cycleScrollView(_ cycleScrollView: ZKCycleScrollView, cellForItemAt indexPath: IndexPath) -> ZKCycleScrollViewCell
    
    /// You can customize pageControl by this method.
    /// If you implement this method, pageIndicatorTintColor, currentPageIndicatorTintColor will be invalid.
    /// And you can set currentPage of pageControl by -cycleScrollView(_:didScrollItemAt:) or -cycleScrollViewDidScroll(_:).
    @objc optional func customPageControl(for cycleScrollView: ZKCycleScrollView) -> UIView
}

open class ZKCycleScrollView: UIView {

    weak open var delegate: ZKCycleScrollViewDelegate?
    weak open var dataSource: ZKCycleScrollViewDataSource?
    open var scrollDirection: ZKScrollDirection = .horizontal {
        didSet {
            switch scrollDirection {
            case .horizontal:
                flowLayout?.scrollDirection = .horizontal
            case .vertical:
                flowLayout?.scrollDirection = .vertical
            }
        }
    }
    open var isAutoScroll: Bool = true {
        didSet {
            if isAutoScroll {
                addTimer()
            } else {
                removeTimer()
            }
        }
    }
    open var showsPageControl: Bool = true {
        didSet {
            pageControl?.isHidden = !showsPageControl
            customPageControl?.isHidden = !showsPageControl
        }
    }
    open var autoScrollDuration: TimeInterval = 3 {
        didSet {
            addTimer()
        }
    }
    open var pageControlTransform: CGAffineTransform = .identity {
        didSet {
            pageControl?.transform = pageControlTransform
            customPageControl?.transform = pageControlTransform
        }
    }
    open var pageIndicatorTintColor: UIColor = .gray {
        didSet {
            pageControl?.pageIndicatorTintColor = pageIndicatorTintColor
        }
    }
    open var currentPageIndicatorTintColor: UIColor = .white {
        didSet {
            pageControl?.currentPageIndicatorTintColor = currentPageIndicatorTintColor
        }
    }
    open var contentOffset: CGPoint {
        return collectionView.contentOffset
    }
    public let numberOfSections: Int = 100
    
    private let kCellReuseId = "ZKCycleScrollViewCell"
    private var collectionView: UICollectionView!
    private var flowLayout: UICollectionViewFlowLayout!
    private var pageControl: UIPageControl?
    private var customPageControl: UIView?
    private var timer: Timer?
    private var count: Int = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initialization()
    }
    
    override open func awakeFromNib() {
        super.awakeFromNib()
        
        initialization()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override open var backgroundColor: UIColor? {
        didSet {
            collectionView.backgroundColor = backgroundColor
        }
    }
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        
        flowLayout.itemSize = bounds.size
        collectionView.frame = bounds
    }
    
    override open func willMove(toSuperview newSuperview: UIView?) {
        if newSuperview == nil { removeTimer() }
    }
    
    deinit {
        collectionView.delegate = nil
        collectionView.dataSource = nil
    }
    
    private func initialization() {
        flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumLineSpacing = 0
        flowLayout.scrollDirection = .horizontal
        flowLayout.headerReferenceSize = CGSize.zero
        flowLayout.footerReferenceSize = CGSize.zero
        
        collectionView = UICollectionView(frame: bounds, collectionViewLayout: flowLayout)
        collectionView.isPagingEnabled = true
        collectionView.scrollsToTop = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.delegate = self
        collectionView.dataSource = self
        addSubview(collectionView)
        
        DispatchQueue.main.async { self.configuration() }
    }
    
    private func configuration() {
        addTimer()
        addPageControl()
        var position: UICollectionView.ScrollPosition!
        switch scrollDirection {
        case .horizontal:
            position = .left
        case .vertical:
            position = .top
        }
        let section = Int(numberOfSections / 2)
        collectionView.scrollToItem(at: IndexPath(item: 0, section: section), at: position, animated: false)
        collectionView.isScrollEnabled = (count > 1)
    }
    
    private func addTimer() {
        removeTimer()
        if count < 2 || !isAutoScroll { return }
        timer = Timer.scheduledTimer(timeInterval: TimeInterval(autoScrollDuration), target: self, selector: #selector(automaticScroll), userInfo: nil, repeats: true)
        RunLoop.main.add(timer!, forMode: .common)
    }
    
    private func addPageControl() {
        pageControl?.removeFromSuperview()
        customPageControl?.removeFromSuperview()
        
        if let dataSource = dataSource, dataSource.responds(to: #selector(ZKCycleScrollViewDataSource.customPageControl(for:))) {
            customPageControl = dataSource.customPageControl!(for: self)
            guard let customPageControl = customPageControl else { return }
            customPageControl.frame = pageControlFrame()
            customPageControl.isHidden = !showsPageControl
            customPageControl.transform = pageControlTransform
            addSubview(customPageControl)
        } else {
            pageControl = UIPageControl()
            guard let pageControl = pageControl else { return }
            pageControl.frame = pageControlFrame()
            pageControl.numberOfPages = count
            pageControl.isHidden = !showsPageControl
            pageControl.transform = pageControlTransform
            pageControl.pageIndicatorTintColor = pageIndicatorTintColor
            pageControl.currentPageIndicatorTintColor = currentPageIndicatorTintColor
            addSubview(pageControl)
        }
    }
    
    private func pageControlFrame() -> CGRect {
        let pageControlWidth = CGFloat(count * 15)
        let pageControlX = (bounds.width - pageControlWidth) / 2
        let pageControlY = bounds.height - 15
        let pageControlorigin = CGPoint(x: pageControlX, y: pageControlY)
        let pageControlSize = CGSize(width: pageControlWidth, height: 15)
        
        return CGRect(origin: pageControlorigin, size: pageControlSize)
    }
    
    @objc private func automaticScroll() {
        let section: Int = currentIndexPath().section
        let item: Int = currentIndexPath().item
        var position: UICollectionView.ScrollPosition!
        switch scrollDirection {
        case .horizontal:
            position = .left
        case .vertical:
            position = .top
        }
        var targetIndexPath: IndexPath!
        var animated: Bool!
        
        if section < numberOfSections - 1 {
            if item < count - 1 {
                targetIndexPath = IndexPath(item: item + 1, section: section)
            } else {
                targetIndexPath = IndexPath(item: 0, section: section + 1)
            }
            animated = true
        } else {
            if item < count - 1 {
                targetIndexPath = IndexPath(item: item + 1, section: section)
                animated = true
            } else {
                let sec = Int(numberOfSections / 2)
                targetIndexPath = IndexPath(item: 0, section: sec)
                animated = false
            }
        }
        collectionView.scrollToItem(at: targetIndexPath, at: position, animated: animated)
    }
    
    private func removeTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    private func currentIndexPath() -> IndexPath {
        if bounds.width == 0 || bounds.height == 0 {
            return IndexPath(item: 0, section: 0)
        }
        var index: Int = 0
        switch scrollDirection {
        case .horizontal:
            index = Int((collectionView.contentOffset.x + flowLayout.itemSize.width / 2) / flowLayout.itemSize.width)
        case .vertical:
            index = Int((collectionView.contentOffset.y + flowLayout.itemSize.height / 2) / flowLayout.itemSize.height)
        }
        index = max(0, index)
        let section: Int = Int(index / count)
        let item: Int = Int(index % count)
        return IndexPath(item: item, section: section)
    }
    
    open func register(cellClass: AnyClass?) {
        collectionView.register(cellClass, forCellWithReuseIdentifier: kCellReuseId)
    }
    
    open func register(nib: UINib?) {
        collectionView.register(nib, forCellWithReuseIdentifier: kCellReuseId)
    }
    
    open func dequeueReusableCell(for indexPath: IndexPath) -> ZKCycleScrollViewCell {
        return collectionView.dequeueReusableCell(withReuseIdentifier: kCellReuseId, for: indexPath)
    }
    
    open func reloadData() {
        collectionView.reloadData()
        DispatchQueue.main.async { self.configuration() }
    }
        
    open func adjustWhenViewWillAppear() {
        if count <= 0 { return }
        let indexPath = currentIndexPath()
        guard indexPath.section < numberOfSections || indexPath.item < count else { return }
        var position: UICollectionView.ScrollPosition!
        switch scrollDirection {
        case .horizontal:
            position = .left
        case .vertical:
            position = .top
        }
        collectionView.scrollToItem(at: indexPath, at: position, animated: false)
    }
}

extension ZKCycleScrollView: UICollectionViewDelegate {
    
    // MARK: - UICollectionView Delegate
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let delegate = delegate, delegate.responds(to: #selector(ZKCycleScrollViewDelegate.cycleScrollView(_:didSelectItemAt:))) {
            delegate.cycleScrollView!(self, didSelectItemAt: indexPath)
        }
    }
    
    // MARK: - UIScrollView Delegate
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if let delegate = delegate, delegate.responds(to: #selector(ZKCycleScrollViewDelegate.cycleScrollViewDidScroll(_:))) {
            delegate.cycleScrollViewDidScroll!(self)
        }
        if count <= 0 { return }
        let indexPath = currentIndexPath()
        pageControl?.currentPage = indexPath.item
    }
    
    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        if isAutoScroll { removeTimer() }
    }
    
    public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if isAutoScroll { addTimer() }
    }
    
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        scrollViewDidEndScrollingAnimation(scrollView)
    }
    
    public func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        if let delegate = delegate, delegate.responds(to: #selector(ZKCycleScrollViewDelegate.cycleScrollView(_:didScrollTo:))) {
            if count <= 0 { return }
            let indexPath = currentIndexPath()
            delegate.cycleScrollView!(self, didScrollTo: indexPath)
        }
    }
}

extension ZKCycleScrollView: UICollectionViewDataSource {
    
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return numberOfSections
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        count = dataSource?.numberOfItems(in: self) ?? 0
        return count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return dataSource?.cycleScrollView(self, cellForItemAt: indexPath) ?? collectionView.dequeueReusableCell(withReuseIdentifier: kCellReuseId, for: indexPath)
    }
}
