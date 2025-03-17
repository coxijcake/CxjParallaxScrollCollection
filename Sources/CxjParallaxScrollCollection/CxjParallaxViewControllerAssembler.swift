//
//  CxjParallaxViewControllerAssembler.swift
//  CxjParallaxScrollCollection
//
//  Created by Nikita Begletskiy on 17/03/2025.
//

import UIKit

/// Assembler for creating and configuring a `CxjParallaxScrollCollection.ViewController`.
@MainActor
public enum CxjParallaxViewControllerAssembler {
	public typealias Module = CxjParallaxScrollCollection
	
	/// Creates and assembles a ready-to-use parallax view controller.
	/// - Parameters:
	///   - layout: Layout configuration for parallax sections.
	///   - dataSource: The data source providing models for cells.
	///   - delegate: The delegate to handle user interaction.
	/// - Returns: A configured instance conforming to `CxjParallaxScrollCollection.ViewController`.
	public static func assembleWith(
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
