// The Swift Programming Language
// https://docs.swift.org/swift-book

import UIKit

public enum CxjParallaxScrollCollection {
	@MainActor
	public protocol ViewController: UIViewController {		
		func reloadData()
		func reloadSections(_ sections: IndexSet)
		func reconfigureItemAtIndexPath(_ indexPath: IndexPath)
		func scrollToItemAt(indexPath: IndexPath, atPosition scrollPosition: ScrollPosition, animated: Bool)
	}
	
	public struct Layout {
		let sectionHeight: CGFloat
		let interSectionSpacing: CGFloat
		let interItemSpacing: CGFloat
		let sectionInset: UIEdgeInsets
		
		public init(
			sectionHeight: CGFloat,
			interSectionSpacing: CGFloat,
			interItemSpacing: CGFloat,
			sectionInset: UIEdgeInsets
		) {
			self.sectionHeight = sectionHeight
			self.interSectionSpacing = interSectionSpacing
			self.interItemSpacing = interItemSpacing
			self.sectionInset = sectionInset
		}
	}
	
	public protocol CellModel {
		var requiredWidth: CGFloat { get }
	}
	
	@MainActor
	public protocol ContentCell: UICollectionViewCell {
		func configureWithModel(_ cellModel: CellModel)
	}
	
	@MainActor
	public protocol Delegate: AnyObject {
		func didSelectModelAtIndexPath(_ indexPath: IndexPath)
	}
	
	@MainActor
	public protocol DataSource: AnyObject {
		var cellType: ContentCell.Type { get }
		
		func numberOfSections() -> Int
		func numberOfItemsInSection(_ sectionIndex: Int) -> Int
		func cellModelForIndexPath(_ indexPath: IndexPath) -> CellModel
	}
	
	public enum ScrollPosition {
		case left, right, center
	}
}
