//
//  FirstViewController.swift
//  ArtistreeApp
//
//  Created by Nicolas Roldos on 6/26/17.
//  Copyright © 2017 artistreeapp. All rights reserved.
//

import UIKit
import CoreLocation

class CurrentLocationViewController: UIViewController, CLLocationManagerDelegate {
	
	// iinitialize an instance of CLLocationManager
	let locationManager = CLLocationManager()
	
	//	new instance variable to store current location in
	var location: CLLocation?
	
	//	initialize a variable of type boolean to false to monitor when location is being mointored
	var updatingLocation = false
	
	//	varible to monitor location errors
	var lastLocationError: Error?
	
	let geocoder = CLGeocoder()
	var placemark: CLPlacemark?
	var performReverseGeocoding = false
	var lastGeocodingError: Error?

	@IBOutlet weak var messageLabel: UILabel!
	@IBOutlet weak var latitudeLabel: UILabel!
	@IBOutlet weak var longitudeLabel: UILabel!
	@IBOutlet weak var addressLabel: UILabel!

	@IBOutlet weak var tagButton: UIButton!
	@IBOutlet weak var getButton: UIButton!
	
	
	
	@IBAction func getMyLocation(_ sender: Any) {
		//	authorization of enabling location-services
		let authStatus = CLLocationManager.authorizationStatus()
		if authStatus == .notDetermined {
			locationManager.requestWhenInUseAuthorization()
			return
		}
		if authStatus == .denied || authStatus == .restricted {
			showLocationServicesDeniedAlert()
			return
		}
		// if 'getMyLocation' button is pressed when already updating location, tapping it again will stop location updates
		if updatingLocation {
			stopLocationManager()
		} else {
			location = nil
			lastLocationError = nil
			placemark = nil
			lastGeocodingError = nil
			startLocationManager()
		}
		updateLabels()
		configureGetButton()
	}
	
	
	//	'viewDidLoad'
	//
	//
	//
	//
	override func viewDidLoad() {
		super.viewDidLoad()
		// insert any logic to occur when view first loads
		configureGetButton()
		updateLabels()
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
	}

	
	//	MARK -- CoreLocationManagerDelegate functions
	//
	//	'didUpdateLocations'
	//
	//
	//
	func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
		let newLocation = locations.last!
			print("did update locations \(newLocation)")
		
		if newLocation.timestamp.timeIntervalSinceNow < -5 {
			return
		}
		if newLocation.horizontalAccuracy < 0 {
			return
		}
		if location == nil || location!.horizontalAccuracy > newLocation.horizontalAccuracy {
			
			lastLocationError = nil
			location = newLocation
			updateLabels()
			
			if newLocation.horizontalAccuracy <= locationManager.desiredAccuracy {
					print("\n sufficient horizontal accuracy achieved!\n")
				stopLocationManager()
				configureGetButton()
			}
			if !performReverseGeocoding {
					print("Geocoding current location...\n")
				performReverseGeocoding = true
				
				geocoder.reverseGeocodeLocation(newLocation, completionHandler: {
					
					placemarks, error in
					
						print("Found placemarks: \(placemarks!)\n")
					
					self.lastGeocodingError = error
					
					if error == nil, let p = placemarks, !p.isEmpty {
						self.placemark = p.last!
					} else {
						self.placemark = nil
					}
					
					self.performReverseGeocoding = false
					self.updateLabels()
				})
			}
		}
	}

	//	'didFailWithError'
	//
	//
	//
	//
	func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
			print("did fail with error \(error)")
		if (error as NSError).code == CLError.locationUnknown.rawValue {
			return
		}
		lastLocationError = error
		stopLocationManager()
		updateLabels()
		configureGetButton()
	}
	
	
	
	//	'showLocationServicesDeniedAlert'
	//
	//	informs user that something went wrong with authorizing && OR
	//	enabling location-services
	//
	//
	func showLocationServicesDeniedAlert() {
		let alert = UIAlertController(title: "Location Services Disabled",
		                              message: "Please enable location services for this app in Settings.",
		                              preferredStyle: .alert)
		let okAction = UIAlertAction(title: "OK",
		                             style: .default,
		                             handler: nil)
		alert.addAction(okAction)
		present(alert, animated: true, completion: nil)
	}

	
	
	// 'updateLabels'
	//
	//
	//
	//
	func updateLabels() {
		//		if there is a 'last location' value in 'location'
		if let location = location {
			
			latitudeLabel.text = String(format: "%.8f", location.coordinate.latitude)
			longitudeLabel.text = String(format: "%.8f", location.coordinate.longitude)
			tagButton.isHidden = false
			messageLabel.text = ""
			
			if let placemark = placemark {
				addressLabel.text = string(from: placemark)
			} else if performReverseGeocoding {
					addressLabel.text = "Searching for Location..."
			} else if lastGeocodingError != nil {
					addressLabel.text = "Error finding address"
			} else {
				addressLabel.text = "Searching for Location..."
			}
			
		//	else,
		// if there are 'nil' locations or there was an 'error'
		} else {
			
			latitudeLabel.text = ""
			longitudeLabel.text = ""
			addressLabel.text = ""
			tagButton.isHidden = true
			messageLabel.text = "Tap 'Get My Location' to Start"
			
			//	handle status of core location manager
			let statusMessage: String
			
			if let error = lastLocationError as NSError? {
				if error.domain == kCLErrorDomain && error.code  == CLError.denied.rawValue {
					statusMessage = "Location Services Disabled"
				} else {
					statusMessage = "Error getting location"
				}
			} else if !CLLocationManager.locationServicesEnabled() {
				statusMessage = "Location Services Disabled"
			//	if updatingLocation returns 'true'
			} else if updatingLocation {
				statusMessage = "Searching..."
			} else {
				statusMessage = "Tap 'Get My Location' to Start"
			}
			messageLabel.text = statusMessage
		}
	}

	
	
	//	MARK: 'start' and 'stop' location functions
	//	
	//
	//
	//
	func startLocationManager() {
		if CLLocationManager.locationServicesEnabled() {
			locationManager.delegate = self
			locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
			locationManager.startUpdatingLocation()
			updatingLocation = true
		}
	}
	
	
	//	'stop' location manager
	//	
	//
	//
	//
	func stopLocationManager() {
		if updatingLocation {
			locationManager.stopUpdatingLocation()
			locationManager.delegate = nil
			updatingLocation = false
		}
	}
	
	
	//	'configureGetButton'
	// function that toggles 'getMyLocation' button from 'get' to 'stop'
	//
	//
	//
	func configureGetButton() {
		// if updatingLocation is 'true'
		if updatingLocation {
			getButton.setTitle("Stop", for: .normal)
		} else {
			getButton.setTitle("Get my current location", for: .normal)
		}
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
// END of CurrentLocationViewController
