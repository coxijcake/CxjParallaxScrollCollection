//
//  CxjParallaxScrollCollectionViewController.swift
//  CxjParallaxScrollCollection
//
//  Created by Nikita Begletskiy on 16/03/2025.
//

import Foundation
import UIKit

//MARK: - Types
extension ParallaxScrollCollectionViewControllerImpl {
	typealias Module = CxjParallaxScrollCollection
	
	typealias CellModel = Module.CellModel
	typealias ContentCell = Module.ContentCell
	typealias ScrollPosition = Module.ScrollPosition
}

final class ParallaxScrollCollectionViewControllerImpl: UIViewController {
	//MARK: - Subviews
	private let contentSizeReferenceView = UIView()
	private let scrollView = ParallaxMasterScrollView()
	private let stackView = UIStackView()
	private var collectionViews: [UICollectionView] {
		get { scrollView.collectionViews }
		set { scrollView.collectionViews = newValue }
	}
	
	//MARK: - Props
	var layout: Module.Layout = .init(
		sectionHeight: 40,
		interSectionSpacing: 10,
		interItemSpacing: 8,
		sectionInset: .init(top: 0, left: 16, bottom: 0, right: 16)
	)
	
	weak var dataSource: Module.DataSource!
	weak var delegate: Module.Delegate!
	
	//MARK: - Lifecycle
	override func viewDidLoad() {
		super.viewDidLoad()
		
		setupSubviews()
	}

	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		
		adjustScrollViewContentSize()
	}
}

//MARK: - Helpers
private extension ParallaxScrollCollectionViewControllerImpl {
	var cellType: Module.ContentCell.Type { dataSource.cellType }
	
	func collectionSectionForIndexPath(_ indexPath: IndexPath) -> UICollectionView {
		collectionViews[indexPath.section]
	}
	
	func sectionIndexForCollection(_ collectionView: UICollectionView) -> Int {
		collectionViews.firstIndex(of: collectionView)!
	}
	
	func cellModelAtIndexPath(_ indexPath: IndexPath, forCollection collectionView: UICollectionView) -> CellModel {
		let sectionIndex: Int = sectionIndexForCollection(collectionView)
		return dataSource.cellModelForIndexPath(IndexPath(row: indexPath.row, section: sectionIndex))
	}
	
	func numberOfItemsInCollectionView(_ collectionView: UICollectionView) -> Int {
		let sectionIndex: Int = sectionIndexForCollection(collectionView)
		return dataSource.numberOfItemsInSection(sectionIndex)
	}
}

//MARK: - Scrolling
extension ParallaxScrollCollectionViewControllerImpl {
	func contentOffsetFactorForItemAt(
		indexPath: IndexPath,
		inCollectionView collectionView: UICollectionView,
		atPosition scrollPosition: ScrollPosition
	) -> CGFloat {
		let contentWidth = collectionView.contentSize.width
		let visibleWidth = collectionView.bounds.width
		
		guard contentWidth > visibleWidth else { return .zero }
		
		guard let attributes = collectionView.layoutAttributesForItem(at: indexPath) else { return .zero }
		
		let itemOffsetX: CGFloat = switch scrollPosition {
		case .left: attributes.frame.minX
		case .center: attributes.frame.midX - (visibleWidth / 2)
		case .right: attributes.frame.maxX - visibleWidth
		}
		
		let maxOffsetX = contentWidth - visibleWidth
		
		let progress = itemOffsetX / maxOffsetX
		return min(max(progress, 0.0), 1.0)
	}
	
	func updateCollectionsOffsetForProgress(_ progress: CGFloat) {
		if progress < 0.0 {
			let translationX: CGFloat = abs(scrollView.contentOffset.x)
			stackView.transform = .init(translationX: translationX, y: .zero)
		} else if progress > 1.0 {
			let translationX: CGFloat = scrollView.contentOffset.x - (scrollView.contentSize.width - scrollView.bounds.size.width)
			stackView.transform = .init(translationX: -abs(translationX), y: .zero)
		} else {
			if stackView.transform != .identity {
				stackView.transform = .init(translationX: .zero, y: .zero)
			}
		}
		
		for collectionView in collectionViews {
			let maxOffsetX = collectionView.contentSize.width - collectionView.bounds.width
			
			let adjustedOffsetX = max(0, min(maxOffsetX, maxOffsetX * progress))
			
			collectionView.contentOffset.x = adjustedOffsetX
		}
	}
	
	func adjustScrollViewContentSize() {
		view.layoutIfNeeded()
		
		guard
			let widestCollection = collectionViews.max(by: { $0.contentSize.width < $1.contentSize.width })
		else { return }

		let maxWidth = widestCollection.contentSize.width

		contentSizeReferenceView.frame = CGRect(x: 0, y: 0, width: maxWidth, height: scrollView.bounds.size.height)

		scrollView.contentSize = CGSize(width: maxWidth, height: scrollView.bounds.height)
	}
}

//MARK: - CxjParallaxScrollCollection.ViewController
extension ParallaxScrollCollectionViewControllerImpl: CxjParallaxScrollCollection.ViewController {
	func reloadData() {
		let requiredSectionCount = dataSource.numberOfSections()
		let currentSectionCount = collectionViews.count

		if requiredSectionCount > currentSectionCount {
			for i in currentSectionCount..<requiredSectionCount {
				insertCollectionView(at: i)
			}
		} else if requiredSectionCount < currentSectionCount {
			for i in stride(from: currentSectionCount - 1, through: requiredSectionCount, by: -1) {
				removeCollectionView(at: i)
			}
		}

		collectionViews.forEach { $0.reloadData() }
		adjustScrollViewContentSize()
	}
	
	func reloadSections(_ sections: IndexSet) {
		for sectionIndex in sections where sectionIndex < collectionViews.count {
			collectionViews[sectionIndex].reloadData()
		}
		
		adjustScrollViewContentSize()
	}
	
	func reconfigureItemAtIndexPath(_ indexPath: IndexPath) {
		let collectionViewToReconfigure: UICollectionView = collectionViews[indexPath.section]
		let collectionViewIndexPath: IndexPath = IndexPath(item: indexPath.item, section: .zero)
		
		collectionViewToReconfigure.reconfigureItems(at: [collectionViewIndexPath])
	}
	
	func scrollToItemAt(indexPath: IndexPath, atPosition scrollPosition: ScrollPosition, animated: Bool) {
		let contentViewMaxOfffsetX: CGFloat = scrollView.contentSize.width - scrollView.bounds.size.width
		
		guard contentViewMaxOfffsetX > 0 else { return }
		
		let collectionView = collectionSectionForIndexPath(indexPath)
		let collectionIndexPath: IndexPath = .init(row: indexPath.row, section: 0)
		let progress = contentOffsetFactorForItemAt(indexPath: collectionIndexPath, inCollectionView: collectionView, atPosition: scrollPosition)
		
		
		let contentTargetOffsetX: CGFloat = contentViewMaxOfffsetX * progress
		let contentTargetOffset: CGPoint = CGPoint(x: contentTargetOffsetX, y: scrollView.contentOffset.y)
		
		scrollView.setContentOffset(contentTargetOffset, animated: animated)
	}
}

// MARK: - UICollectionView DataSource
extension ParallaxScrollCollectionViewControllerImpl: UICollectionViewDataSource {
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return numberOfItemsInCollectionView(collectionView)
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell: ContentCell = collectionView.dequeueReusableCell(withReuseIdentifier: cellType.reuseIdentifier, for: indexPath) as! ContentCell
		let model = cellModelAtIndexPath(indexPath, forCollection: collectionView)
		cell.configureWithModel(model)
		
		return cell
	}
}

//MARK: - UICollectionViewDelegate
extension ParallaxScrollCollectionViewControllerImpl: UICollectionViewDelegate {
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		let sectionIndex: Int = sectionIndexForCollection(collectionView)
		let selectedIndexPath: IndexPath = IndexPath(item: indexPath.item, section: sectionIndex)
		
		delegate.didSelectModelAtIndexPath(selectedIndexPath)
	}
}

//MARK: - UICollectionViewDelegateFlowLayout
extension ParallaxScrollCollectionViewControllerImpl: UICollectionViewDelegateFlowLayout {
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		let model = cellModelAtIndexPath(indexPath, forCollection: collectionView)
		return .init(width: model.requiredWidth, height: layout.sectionHeight)
	}
}

//MARK: - UIScrollViewDelegate
extension ParallaxScrollCollectionViewControllerImpl: UIScrollViewDelegate {
	func scrollViewDidScroll(_ scrollView: UIScrollView) {
		guard scrollView === self.scrollView else { return }
		
		let scrollProgress = scrollView.contentOffset.x / (scrollView.contentSize.width - scrollView.bounds.width)

		updateCollectionsOffsetForProgress(scrollProgress)
	}
}

//MARK: - Subviews Configuration
private extension ParallaxScrollCollectionViewControllerImpl {
	func setupSubviews() {
		setupScrollView()
		setupCollectionViews()
	}
	
	func setupScrollView() {
		view.addSubview(scrollView)
		scrollView.translatesAutoresizingMaskIntoConstraints = false
		scrollView.delegate = self
		scrollView.showsHorizontalScrollIndicator = false

		NSLayoutConstraint.activate([
			scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
			scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
			scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
			scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
		])

		view.addSubview(stackView)
		stackView.axis = .vertical
		stackView.spacing = layout.interSectionSpacing
		stackView.translatesAutoresizingMaskIntoConstraints = false
		stackView.isUserInteractionEnabled = false

		NSLayoutConstraint.activate([
			stackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
			stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
			stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
			stackView.heightAnchor.constraint(greaterThanOrEqualToConstant: layout.sectionHeight)
		])
		
		scrollView.addSubview(contentSizeReferenceView)
		contentSizeReferenceView.backgroundColor = .clear
		contentSizeReferenceView.isUserInteractionEnabled = false
	}
	
	func makeCollectionView() -> UICollectionView {
		let collectionLayout = UICollectionViewFlowLayout()
		collectionLayout.scrollDirection = .horizontal
		collectionLayout.minimumInteritemSpacing = layout.interItemSpacing
		collectionLayout.sectionInset = layout.sectionInset

		let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionLayout)
		collectionView.dataSource = self
		collectionView.delegate = self
		collectionView.showsHorizontalScrollIndicator = false
		collectionView.backgroundColor = .clear
		collectionView.register(cell: cellType)
		collectionView.isScrollEnabled = false
		collectionView.isUserInteractionEnabled = false
		
		collectionView.heightAnchor.constraint(equalToConstant: layout.sectionHeight).isActive = true

		return collectionView
	}
	
	func setupCollectionViews() {
		for i in 0..<dataSource.numberOfSections() {
			insertCollectionView(at: i)
		}
	}
	
	func insertCollectionView(at index: Int) {
		let collectionView = makeCollectionView()
		collectionViews.insert(collectionView, at: index)
		stackView.insertArrangedSubview(collectionView, at: index)
	}

	func removeCollectionView(at index: Int) {
		guard index < collectionViews.count else { return }
		
		let collectionView = collectionViews.remove(at: index)
		stackView.removeArrangedSubview(collectionView)
		collectionView.removeFromSuperview()
	}
}
