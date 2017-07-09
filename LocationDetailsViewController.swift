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
//	var venueName = "Check-in to Art Venues Near You..."
	var selectedVenueName = "Art Venues Near You..."
	var venueInfo = "Venue Info"
	var postToPublic = false
	var postToFavorites = false
	
	
	@IBOutlet weak var descriptionTextView: UITextView!
	@IBOutlet weak var postToPublicMapSwitch: UISwitch!
	@IBOutlet weak var postToFavoritesSwitch: UISwitch!
	@IBOutlet weak var postNameLabel: UILabel!

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
		
		
		
		let latitudeString = String(format: "%.8f", coordinate.latitude)
		let longitudeString = String(format: "%.8f", coordinate.longitude)
		
		descriptionTextView.text = ""
		artVenueLabel.text = "Art Venues Near You..."
		latitudeDetailLabel.text = latitudeString
		longitudeDetailLabel.text = longitudeString
		
		dateDetailLabel.text = format(date: Date())
		
		if let placemark = placemark {
			addressDetailLabel.text = string(from: placemark)
		} else {
			addressDetailLabel.text = "No Address Found"
		}
		
		let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(hideKeyBoard(_:)))
		gestureRecognizer.cancelsTouchesInView = false
		tableView.addGestureRecognizer(gestureRecognizer)

	}

	//	MARK 'UITableViewDelgate'
	//		
	//	
	//	
	//	
	override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		
		if indexPath.section == 0 && indexPath.row == 1 {
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
	
	
	//	'tableView willSelectnRowAtIndexPath' function for sections 0 and 1
	//
	//
	//
	//
	override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
		if indexPath.section == 0 || indexPath.section == 1 {
			return indexPath
		} else {
			return nil
		}
	}
	
	
	//	'tableView didSelectnRowAtIndexPath' function for Description text-field, section 0
	//
	//
	//
	//
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		if indexPath.section == 0 && indexPath.row == 1 {
			descriptionTextView.becomeFirstResponder()
		}
	}
	
	
	
	
	
	func hideKeyBoard(_ gestureRecognizer: UIGestureRecognizer) {
		
		let point = gestureRecognizer.location(in: tableView)
		let indexPath = tableView.indexPathForRow(at: point)
		
		if indexPath != nil && indexPath!.section == 0 && indexPath!.row == 1 {
			return
		}
		descriptionTextView.resignFirstResponder()
	}
	
	
	
	
	
	//	'prepareForSegue' function transfers picked venue back to LocationDetailsViewControlller
	//
	//
	//
	//
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
			if segue.identifier == "PickVenue" {
				let controller = segue.destination as! VenuesNearMePickerController
				controller.selectedVenueName = selectedVenueName
				controller.coordinate = self.coordinate
		}
	}
	
	
	
	//	IBAction functions
	//
	//
	//
	//
	@IBAction func venuesNearMePickerDidPickVenue(_ segue: UIStoryboardSegue) {
		let controller = segue.source as! VenuesNearMePickerController
		selectedVenueName = controller.selectedVenueName
		artVenueLabel.text = selectedVenueName
		postNameLabel.text = selectedVenueName
	}
	
	
	
	@IBAction func postToPublicMap(_ sender: Any) {
		if postToPublic != true {
			postToPublic = true
		} else {
			postToPublic = false
		}
	}

	@IBAction func postToFavorites(_ sender: Any) {
		if postToFavorites != true {
			postToFavorites = true
		} else {
			postToFavorites = false
		}
	}
	
	@IBAction func artVenueCheckIn(_ sender: Any) {
	}
	
	@IBAction func cancel() {
		dismiss(animated: true, completion: nil)
	}
	
	@IBAction func done() {
		let hudView = HUDView.hud(inView: navigationController!.view, animated: true)
		hudView.text = "tagged"
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
