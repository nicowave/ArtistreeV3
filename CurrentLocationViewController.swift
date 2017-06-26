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
	let locationManger = CLLocationManager()
	
	//	new instance variable to store current location in
	var location = CLLocation()

	@IBOutlet weak var messageLabel: UILabel!
	@IBOutlet weak var latitudeLabel: UILabel!
	@IBOutlet weak var longitudeLabel: UILabel!
	@IBOutlet weak var addressLabel: UILabel!

	@IBOutlet weak var tagButton: UIButton!
	@IBOutlet weak var getButton: UIButton!


	
	
	@IBAction func getMyLocation(_ sender: Any) {
		
		//		authorization
		let authStatus = CLLocationManager.authorizationStatus()
		
		if authStatus == .notDetermined {
			locationManger.requestWhenInUseAuthorization()
			return
		}
		if authStatus == .denied || authStatus == .restricted {
			showLocationServicesDeniedAlert()
			return
		}
		
		locationManger.delegate = self
		locationManger.desiredAccuracy = kCLLocationAccuracyBest
		locationManger.startUpdatingLocation()
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
		
		//		function that takes care of UI when new location is aadded
		updateLabels()
	}
	
	func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
		print("did fail with error \(error)")
	}

	
	
	func updateLabels() {
		if location == location {
			latitudeLabel.text = String(format: "%.8f", location.coordinate.latitude)
			longitudeLabel.text = String(format: "%.8f", location.coordinate.longitude)
			tagButton.isHidden = false
			messageLabel.text = ""
			
		} else {
			latitudeLabel.text = ""
			longitudeLabel.text = ""
			addressLabel.text = ""
			tagButton.isHidden = true
			messageLabel.text = "Tap 'Get My Location' to Start"
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
	
	
}

