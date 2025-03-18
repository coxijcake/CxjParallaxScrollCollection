//
//  CxjParallaxViewAssembler.swift
//  CxjParallaxScrollCollection
//
//  Created by Nikita Begletskiy on 17/03/2025.
//

import UIKit

/// Assembler for creating and configuring a `CxjParallaxScrollCollection.View`.
@MainActor
public enum CxjParallaxViewAssembler {
	public typealias Module = CxjParallaxScrollCollection
	
	/// Creates and assembles a ready-to-use parallax view.
	/// - Parameters:
	///   - layout: Layout configuration for parallax sections.
	///   - dataSource: The data source providing models for cells.
	///   - delegate: The delegate to handle user interaction.
	/// - Returns: A configured instance conforming to `CxjParallaxScrollCollection.View`.
	public static func assembleWith(
		layout: Module.Layout,
		dataSource: Module.DataSource,
		delegate: Module.Delegate
	) -> Module.View {
		let view: ParallaxScrollCollectionView = ParallaxScrollCollectionView(
			layout: layout,
			dataSource: dataSource,
			delegate: delegate
		)
		
		return view
	}
}
