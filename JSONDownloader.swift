//
//  JSONDownloader.swift
//  ArtistreeApp
//
//  Created by Nicolas Roldos on 7/4/17.
//  Copyright © 2017 artistreeapp. All rights reserved.
//

import Foundation


class JSONDownloader {
	
	var session = URLSession()
	
	init(configuration: URLSessionConfiguration) {
		self.session = URLSession(configuration: configuration)
	}
	
	convenience init() {
			self.init(configuration: .default)
	}
	
	typealias JSON = [String: AnyObject]
	typealias JSONTaskCompletionHandler = (JSON?, APIError?) -> Void
	
	
	func jsonTask(with request: URLRequest, completionHandler completion: @escaping JSONTaskCompletionHandler) -> URLSessionDataTask {
		
		let task = session.dataTask(with: request) { data, response, error in
			
			guard let httpResponse = response as? HTTPURLResponse else {
					completion(nil, .requestFailed)
					return
			}
			if httpResponse.statusCode == 200 {
				if let data = data {
					do {
						let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: AnyObject]
						completion(json, nil)
						
					} catch {
						completion(nil, .jsonConversionFailure)
					}
				} else {
					completion(nil, .invalidData)
				}
			} else {
				completion(nil, .responseUnsuccessful)
			}
		}
		return task
	}
	
}
