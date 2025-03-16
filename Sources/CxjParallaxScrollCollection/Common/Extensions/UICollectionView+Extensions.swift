//
//  UICollectionView+Extensions.swift
//  CxjParallaxScrollCollection
//
//  Created by Nikita Begletskiy on 16/03/2025.
//

import UIKit

extension UICollectionView {
	func register<T: UICollectionViewCell>(cell: T.Type) {
		register(cell.self, forCellWithReuseIdentifier: cell.reuseIdentifier)
	}
}
