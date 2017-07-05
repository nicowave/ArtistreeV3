//
//  Coordinate.swift
//  ArtistreeApp
//
//  Created by Nicolas Roldos on 7/4/17.
//  Copyright © 2017 artistreeapp. All rights reserved.
//

import Foundation

struct Coordinate {
		let latitude: Double
		let longitude: Double
}

extension Coordinate: CustomStringConvertible {
	var description: String {
		return "\(latitude),\(longitude)"
	}
}
