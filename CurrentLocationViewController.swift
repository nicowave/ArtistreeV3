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
	var location = CLLocation()
	//	initialize a variable of type boolean to false to monitor when location is being mointored
	var updatingLocation = false
	//	varible to monitor location errors
	var lastLocationError: Error?

	@IBOutlet weak var messageLabel: UILabel!
	@IBOutlet weak var latitudeLabel: UILabel!
	@IBOutlet weak var longitudeLabel: UILabel!
	@IBOutlet weak var addressLabel: UILabel!

	@IBOutlet weak var tagButton: UIButton!
	@IBOutlet weak var getButton: UIButton!
	
	@IBAction func getMyLocation(_ sender: Any) {
		//	authorization
		let authStatus = CLLocationManager.authorizationStatus()
		if authStatus == .notDetermined {
			locationManager.requestWhenInUseAuthorization()
			return
		}
		if authStatus == .denied || authStatus == .restricted {
			showLocationServicesDeniedAlert()
			return
		}
		startLocationManager()
		updateLabels()
	}
	
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// insert any logic to occur when view first loads
		updateLabels()
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
	}

	
	
	//	MARK -- CoreLocationManagerDelegate functions
	func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
		let newLocation = locations.last!
			print("did update locations \(newLocation)")
		location = newLocation
		lastLocationError = nil
		updateLabels()
	}
	
	
	func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
			print("did fail with error \(error)")
		if (error as NSError).code == CLError.locationUnknown.rawValue {
			return
		}
		lastLocationError = error
		stopLocationManager()
		updateLabels()
	}

	
	
	
	func updateLabels() {
		//		if there is a 'last location' value in 'location'
		if location == location {
			latitudeLabel.text = String(format: "%.8f", location.coordinate.latitude)
			longitudeLabel.text = String(format: "%.8f", location.coordinate.longitude)
			tagButton.isHidden = false
			messageLabel.text = ""
		//	else, if there are no location's or there was an 'error'
		} else {
			latitudeLabel.text = ""
			longitudeLabel.text = ""
			addressLabel.text = ""
			tagButton.isHidden = true
			messageLabel.text = "Tap 'Get My Location' to Start"
			
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
	
	
	
	
	//	MARK: 'stop' and 'start' fucntion
	func startLocationManager() {
		if CLLocationManager.locationServicesEnabled() {
			locationManager.delegate = self
			locationManager.desiredAccuracy = kCLLocationAccuracyBest
			locationManager.startUpdatingLocation()
			updatingLocation = true
		}
	}
	

	
	func stopLocationManager() {
		if updatingLocation {
			locationManager.stopUpdatingLocation()
			locationManager.delegate = nil
			updatingLocation = false
		}
	}
	
	
	
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
// END of CurrentLocationViewController
}

