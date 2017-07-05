//
//  APIError.swift
//  ArtistreeApp
//
//  Created by Nicolas Roldos on 7/4/17.
//  Copyright © 2017 artistreeapp. All rights reserved.
//

import Foundation


enum APIError: Error {
	
	case requestFailed
	case responseUnsuccessful
	case invalidData
	case jsonConversionFailure
	case invalidUrl
	case jsonParsingFailure
	
}
