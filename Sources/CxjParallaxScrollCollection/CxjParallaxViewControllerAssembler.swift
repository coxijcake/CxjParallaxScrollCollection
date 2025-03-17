//
//  CxjParallaxViewControllerAssembler.swift
//  CxjParallaxScrollCollection
//
//  Created by Nikita Begletskiy on 17/03/2025.
//

import UIKit

@MainActor
public enum CxjParallaxViewControllerAssembler {
	public typealias Module = CxjParallaxScrollCollection
	
	public static func vcWith(
		layout: Module.Layout,
		dataSource: Module.DataSource,
		delegate: Module.Delegate
	) -> Module.ViewController {
		let viewController: ParallaxScrollCollectionViewControllerImpl = ParallaxScrollCollectionViewControllerImpl()
		viewController.layout = layout
		viewController.dataSource = dataSource
		viewController.delegate = delegate
		
		return viewController
	}
}
