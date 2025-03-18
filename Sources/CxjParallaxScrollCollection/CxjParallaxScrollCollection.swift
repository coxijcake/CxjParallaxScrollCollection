// The Swift Programming Language
// https://docs.swift.org/swift-book

import UIKit


/// `CxjParallaxScrollCollection` provides a synced horizontal scrolling system across multiple collections with a parallax-like effect.
public enum CxjParallaxScrollCollection {

	// MARK: - View

	/// A view that manages the parallax scrolling collections.
	@MainActor
	public protocol View: UIView {

		/// Reloads all sections and items.
		func reloadData()

		/// Reloads specific sections.
		/// - Parameter sections: Sections to be reloaded.
		func reloadSections(_ sections: IndexSet)

		/// Reconfigures a specific item.
		/// - Parameter indexPath: IndexPath of the item to reconfigure.
		func reconfigureItemAtIndexPath(_ indexPath: IndexPath)

		/// Scrolls to a particular item.
		/// - Parameters:
		///   - indexPath: Target item.
		///   - scrollPosition: Position (left, center, right).
		///   - animated: Whether the scroll should be animated.
		func scrollToItemAt(indexPath: IndexPath, atPosition scrollPosition: ScrollPosition, animated: Bool)
	}

	// MARK: - Layout

	/// Defines layout and spacing of collections.
	public struct Layout {
		let sectionHeight: CGFloat
		let interSectionSpacing: CGFloat
		let interItemSpacing: CGFloat
		let sectionInset: UIEdgeInsets

		/// Initializes layout configuration.
		/// - Parameters:
		///   - sectionHeight: The height of each collection section.
		///   - interSectionSpacing: The vertical spacing between sections.
		///   - interItemSpacing: The horizontal spacing between cells.
		///   - sectionInset: Insets for each collection section.
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

	// MARK: - CellModel

	/// Represents a view model for a collection cell.
	///
	/// `requiredWidth` can be a static value or dynamically calculated from model data.
	/// This width is used to layout the cell in the collection.
	public protocol CellModel {
		var requiredWidth: CGFloat { get }
	}

	// MARK: - ContentCell

	/// A custom collection cell should conform to this protocol.
	///
	/// The cell will receive its model through this method.
	@MainActor
	public protocol ContentCell: UICollectionViewCell {

		/// Configures the cell with the given model.
		func configureWithModel(_ cellModel: CellModel)
	}

	// MARK: - Delegate

	/// Handles user interactions such as cell selection.
	@MainActor
	public protocol Delegate: AnyObject {

		/// Called when a cell is tapped.
		func didSelectModelAtIndexPath(_ indexPath: IndexPath)
	}

	// MARK: - DataSource

	/// Provides the data for the parallax scrolling view.
	///
	@MainActor
	public protocol DataSource: AnyObject {

		/// Your custom `UICollectionViewCell` class.
		/// ⚠️ Important: Provide a custom `UICollectionViewCell` class directly, not a nib (xib).
		var cellType: ContentCell.Type { get }

		/// The number of horizontal sections (independent collections).
		func numberOfSections() -> Int

		/// The number of items inside a section.
		func numberOfItemsInSection(_ sectionIndex: Int) -> Int

		/// The model for a specific cell.
		func cellModelForIndexPath(_ indexPath: IndexPath) -> CellModel
	}

	// MARK: - ScrollPosition

	/// Scroll target position.
	public enum ScrollPosition {
		/// Align to the left.
		case left
		/// Align to the right.
		case right
		/// Align to the center.
		case center
	}
}
