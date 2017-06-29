//
//  LocationDetailsViewController.swift
//  ArtistreeApp
//
//  Created by Nicolas Roldos on 6/28/17.
//  Copyright © 2017 artistreeapp. All rights reserved.
//

import UIKit
import CoreLocation

class LocationDetailsViewController: UITableViewController {
	
	var coordinate = CLLocationCoordinate2D(latitude: 0, longitude: 0)
	var placemark: CLPlacemark?
	
	@IBOutlet weak var descriptionTextView: UITextView!
	@IBOutlet weak var postToPublicMapSwitch: UISwitch!
	@IBOutlet weak var postToFavoritesSwitch: UISwitch!
	@IBOutlet weak var customArtPostLocationSwitch: UISwitch!
	@IBOutlet weak var artVenueLabel: UILabel!
	@IBOutlet weak var artVenueCheckInSwitch: UISwitch!
	@IBOutlet weak var addressDetailLabel: UILabel!
	@IBOutlet weak var latitudeDetailLabel: UILabel!
	@IBOutlet weak var longitudeDetailLabel: UILabel!
	@IBOutlet weak var dateDetailLabel: UILabel!
	
	private let dateFormatter: DateFormatter = {
		let formatter = DateFormatter()
		formatter.dateStyle = .medium
		formatter.timeStyle = .short
		return formatter
	}()
	
	func format(date: Date) -> String {
		return dateFormatter.string(from: date)
	}
	
	
	//	'viewDidLoad'
	//
	//
	//
	//
	override func viewDidLoad() {
		super.viewDidLoad()
		descriptionTextView.text = ""
		artVenueLabel.text = ""
		latitudeDetailLabel.text = String(format: "%.8f", coordinate.latitude)
		longitudeDetailLabel.text = String(format: "%.8f", coordinate.longitude)
		dateDetailLabel.text = format(date: Date())
		
		if let placemark = placemark {
			addressDetailLabel.text = string(from: placemark)
		} else {
			addressDetailLabel.text = "No Address Found"
		}
	}

	//	MARK 'UITableViewDelgate'
	//		
	//	
	//	
	//	
	override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		
		if indexPath.section == 0 && indexPath.row == 0 {
			return 88
			
		} else if indexPath.section == 4 && indexPath.row == 0 {
			
			addressDetailLabel.frame.size = CGSize(
				width: view.bounds.size.width - 115,
				height: 10000)
			addressDetailLabel.sizeToFit()
			addressDetailLabel.frame.origin.x = view.bounds.size.width - addressDetailLabel.frame.size.width - 15
			return addressDetailLabel.frame.size.height + 20
			
		} else {
			return 44
		}
	}


	//
	//
	//
	//
	@IBAction func postToPublicMap(_ sender: Any) {
		
	}
	

	@IBAction func postToFavorites(_ sender: Any) {
		
	}
	
	
	@IBAction func postAsCustomLocation(_ sender: Any) {
		
	}
	
	
	@IBAction func artVenueCheckIn(_ sender: Any) {
		
	}
	
	
	@IBAction func cancel() {
		dismiss(animated: true, completion: nil)
	}
	
	@IBAction func done() {
		dismiss(animated: true, completion: nil)

	}
	
	
	@IBAction func submitPostButton(_ sender: Any) {
		
	}
	
	
	//	'string'
	//	function to convert && format CLPlacemark to String
	//
	//
	//
	func string(from placemark: CLPlacemark) -> String {
		
		var line1 = ""
		var line2 = ""
		
		if let s = placemark.subThoroughfare {
			line1 += s + " "
		}
		if let s = placemark.thoroughfare {
			line1 += s
		}
		if let s = placemark.locality {
			line2 += s + " "
		}
		if let s = placemark.administrativeArea {
			line2 += s + " "
		}
		if let s = placemark.postalCode {
			line2 += s
		}
		return line1 + "\n" + line2
	}
	
	
	// HTTP requests
	//
	//	
	//	
	//
	private func dataTask(request: URLRequest, method: String, completion: @escaping (Bool, AnyObject?) -> ()) {
		
		var method = request.httpMethod
		
		let session = URLSession(configuration: URLSessionConfiguration.default)
		
		session.dataTask(with: request) { (data, response, error) in
			
			
			if let data = data {
				
				let json = try? JSONSerialization.jsonObject(with: data, options: []) as AnyObject
				
				if let response = response as? HTTPURLResponse, 200...299 ~= response.statusCode {
					
					completion(true, json)
					
				} else {
					
					completion(false, json)
				}
			}
		}.resume()
	}
}
