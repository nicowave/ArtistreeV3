//
//  NearestVenues.swift
//  ArtistreeApp
//
//  Created by Nicolas Roldos on 7/3/17.
//  Copyright © 2017 artistreeapp. All rights reserved.
//

import Foundation
import CoreLocation



class NearestVenues {
	
	var coordinate = CLLocationCoordinate2D(latitude: 0, longitude: 0)
	
	
	class func getVenues(coordinate: CLLocationCoordinate2D, completionHandler: @escaping (_ results: [String]) -> Void) {
		
		var venues: [String] = []
		
		let coordinateString = String(coordinate.latitude) + "," + String(coordinate.longitude)
		print("\n******\t" + coordinateString + "\t******\n")
		
		let endpoint = "https://api.foursquare.com/v2/venues/search?client_id=HVSJE4I0ZG1SVTHBJLZUUALAV32FXW03PVSUY1KPIYYMU0H5&client_secret=UVLSIJIVTZORUESDYHVPO14RNPVOFYWMSGEJMMWEYG0NECXL&v=20130815&ll=" + coordinateString + "&query=art"
		let url: URL = URL(string: endpoint)!
		var request = URLRequest(url: url)
		request.httpMethod = "GET"
		let session = URLSession(configuration: URLSessionConfiguration.default)
		
		let task = session.dataTask(with: request, completionHandler: { (data, response, error) in
			
			let response = response as! HTTPURLResponse
			let status = response.statusCode
			
			if (status == 200) {
				print("\n Success, HTTP response went through \n")
				
				do {
					
					let json = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! [String: AnyObject]
					let res = json["response"]! as? [String: AnyObject]
					let artVenues = res?["venues"] as? [[String: Any]]
					for venue in artVenues! {
						if let currentVenue = venue["name"] as? String {
							venues.append(currentVenue)
						}
					}
				} catch {
					print("Error with Json: \(error)")
				}
			}
			completionHandler(venues)
		})
		task.resume()
	}
	
	
}
