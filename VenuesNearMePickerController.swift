//
//  VenuesNearMePickerController.swift
//  ArtistreeApp
//
//  Created by Nicolas Roldos on 6/29/17.
//  Copyright © 2017 artistreeapp. All rights reserved.
//

import UIKit
import CoreLocation



class VenuesNearMePickerController: UITableViewController {
	
	var selectedVenueName = ""
	
	var coordinate = CLLocationCoordinate2D(latitude: 0, longitude: 0)
	var selectedIndexPath = IndexPath()
	var venueName: String?
	var venues: [String] = []
	//	'viewDidLoad'
	//
	//
	//
	//
	override func viewDidLoad() {
		super.viewDidLoad()
		
		NearestVenues.getVenues(coordinate: coordinate) { venues in
			
			print(venues)
			
		}
		
		for i in 0..<venues.count {
			if venues[i] == selectedVenueName {
				selectedIndexPath = IndexPath(row: i, section: 0)
				break
			}
		}
	}
	
	
	
	//		MARK-- UITable Data Source
	//	
	//	
	//	
	//
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return self.venues.count
	}

	
	
	// 'cellForRowAt indexPath'
	//
	//
	//
	//
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		
		var cell = tableView.dequeueReusableCell(withIdentifier: "cell")
		
		let venue = venues[indexPath.row]
		
		if !(cell != nil) {
			cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
		}
		
		cell?.textLabel?.text = venue
		//	cell?.detailTextLabel?.text = self.coords[indexPath.row]
		
		
		if venue == selectedVenueName {
			cell?.accessoryType = .checkmark
		} else {
			cell?.accessoryType = .none
		}
		return cell!
	}
	
	
	//	MARK - 'UITableViewDelegate'
	//	
	//	
	//	
	//
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		
		if indexPath.row != selectedIndexPath.row {
			if let newCell = tableView.cellForRow(at: indexPath) {
				newCell.accessoryType = .checkmark
			}
			if let oldCell = tableView.cellForRow(at: selectedIndexPath) {
				oldCell.accessoryType = .none
			}
			selectedIndexPath = indexPath
		}
	}
	
	
	//	'loadNearestVenues'
	//
	//
	//
	//
//	func loadVenues(coordinate: CLLocationCoordinate2D) -> Void {
//	
//}

	
}
