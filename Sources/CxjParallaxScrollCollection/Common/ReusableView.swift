//
//  ReusableView.swift
//  CxjParallaxScrollCollection
//
//  Created by Nikita Begletskiy on 16/03/2025.
//

import UIKit

protocol ReusableView where Self: UIView {
	static var reuseIdentifier: String { get }
}

extension ReusableView {
	static var reuseIdentifier: String {
		return String(describing: self)
	}
}

extension UICollectionViewCell: ReusableView {}

extension UICollectionReusableView: ReusableView {}
