//
//  ApiClient.swift
//  ArtistreeApp
//
//  Created by Nicolas Roldos on 6/29/17.
//  Copyright © 2017 artistreeapp. All rights reserved.
//

import CoreLocation



class ApiClient {

	
	var coordinate = CLLocationCoordinate2D(latitude: 0, longitude: 0)
	
	private var fourSquareClientId = "HVSJE4I0ZG1SVTHBJLZUUALAV32FXW03PVSUY1KPIYYMU0H5"
	private var fourSquareClientSecret = "UVLSIJIVTZORUESDYHVPO14RNPVOFYWMSGEJMMWEYG0NECXL"

	
	// HTTP requests
	//
	//
	//
	//
	class func dataTask(request: URLRequest, method: String, completion: @escaping (Bool, AnyObject?) -> ()) {
		
		var method = request.httpMethod
		let session = URLSession(configuration: URLSessionConfiguration.default)
		
		session.dataTask(with: request) { (data, response, error) in
			
			if let data = data {
				let json = try? JSONSerialization.jsonObject(with: data, options: []) as AnyObject
				
				if let response = response as? HTTPURLResponse, 200...299 ~= response.statusCode {
					completion(true, json)
					print(json)
				} else {
					completion(false, json)
				}
			}
		}.resume()
	}

	class func post(request: URLRequest, completion: @escaping (_ success: Bool, _ object: AnyObject?) -> ()) {
		dataTask(request: request, method: "POST", completion: completion)
	}

	class func get(request: URLRequest, completion: @escaping (_ success: Bool, _ object: AnyObject?) -> ()) {
		dataTask(request: request, method: "GET", completion: completion)
	}
	
	
	//	 'getArtLocations'
	//
	//
	//
	//
	class func getArtLocations(urlEndpoint: URL, location: CLLocationCoordinate2D) -> AnyObject {
		
		let coordinateString = String(location.latitude) + "," + String(location.longitude)
		
		let url = "https://api.foursquare.com/v2/venues/search?client_id=HVSJE4I0ZG1SVTHBJLZUUALAV32FXW03PVSUY1KPIYYMU0H5&client_secret=UVLSIJIVTZORUESDYHVPO14RNPVOFYWMSGEJMMWEYG0NECXL&v=20130815&ll=" + coordinateString + "&query=art"
		
		request = URLRequest(url: url)
		
		get(request: request), completion: (success: _ Bool, object: AnyObject?) in
			dispatch_async(dispatch_get_main_queue(), { () -> Void in
				if success {
					return object
				} else {
			
		}
	}
}
