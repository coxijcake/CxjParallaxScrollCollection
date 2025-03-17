//
//  ParallaxScrollCollectionViewController+ScrollView.swift
//  CxjParallaxScrollCollection
//
//  Created by Nikita Begletskiy on 16/03/2025.
//

import UIKit

extension ParallaxScrollCollectionViewControllerImpl {
	final class ParallaxMasterScrollView: UIScrollView {
		var collectionViews: [UICollectionView] = []
		
		override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
			super.touchesBegan(touches, with: event)
			
			if let targeCollectiontView = findTargetCollectionView(for: touches),
			   let (_, cell) = indexPathAndCellInsideCollection(targeCollectiontView, forTouches: touches) {
				cell.isHighlighted = true
			}
		}
		
		override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
			super.touchesMoved(touches, with: event)
			
			if let targetCollectionView = findTargetCollectionView(for: touches),
			   let (_, cell) = indexPathAndCellInsideCollection(targetCollectionView, forTouches: touches) {
				cell.isHighlighted = false
			}
		}
		
		override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
			super.touchesEnded(touches, with: event)
			
			if let targetCollectionView = findTargetCollectionView(for: touches),
			   let (indexPath, cell) = indexPathAndCellInsideCollection(targetCollectionView, forTouches: touches) {
				cell.isHighlighted = false
				targetCollectionView.delegate?.collectionView?(targetCollectionView, didSelectItemAt: indexPath)
			}
		}
		
		
		override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
			super.touchesCancelled(touches, with: event)
			
			if let targetCollectionView = findTargetCollectionView(for: touches),
			   let (_, cell) = indexPathAndCellInsideCollection(targetCollectionView, forTouches: touches) {
				cell.isHighlighted = false
			}
		}
		
		private func findTargetCollectionView(for touches: Set<UITouch>) -> UICollectionView? {
			guard let touch = touches.first else { return nil }
			
			let touchLocation = touch.location(in: self)
			
			for collectionView in collectionViews {
				let collectionViewFrame = collectionView.convert(collectionView.bounds, to: self)
				if collectionViewFrame.contains(touchLocation) {
					return collectionView
				}
			}
			
			return nil
		}
		
		private func indexPathAndCellInsideCollection(
			_ collectionView: UICollectionView,
			forTouches touches: Set<UITouch>
		) -> (IndexPath, UICollectionViewCell)? {
			guard let touch = touches.first else { return nil }
			
			let locationInCollectionView = touch.location(in: collectionView)
			
			guard
				let indexPath: IndexPath = collectionView.indexPathForItem(at: locationInCollectionView),
				let cell = collectionView.cellForItem(at: indexPath)
			else { return nil }
			
			return (indexPath, cell)
		}
	}
}
