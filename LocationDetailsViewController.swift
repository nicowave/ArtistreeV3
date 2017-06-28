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

	
}
