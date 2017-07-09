//
//  MapGeoTagsViewController.swift
//  ArtistreeApp
//
//  Created by Nicolas Roldos on 7/6/17.
//  Copyright © 2017 artistreeapp. All rights reserved.
//

import UIKit
import MapKit
//import CoreLocation
import CoreData



class MapGeoTagsViewController: UIViewController {
	
//	var locations = [Location]()
//	var managedObjectContext: NSManagedObjectContext!
		var coordinate = CLLocationCoordinate2D(latitude: 0, longitude: 0)
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		
		mapView.isZoomEnabled = true
		let region = MKCoordinateRegionMakeWithDistance(coordinate, 1000, 1000)
		mapView.setRegion(mapView.regionThatFits(region), animated: true)
		
		mapView.showsUserLocation = true
		
		
	}
	
	
	@IBOutlet weak var mapView: MKMapView!


	

	
}

extension MapGeoTagsViewController: MKMapViewDelegate {
	
}
