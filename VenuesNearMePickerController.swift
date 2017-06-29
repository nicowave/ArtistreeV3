//
//  VenuesNearMePickerController.swift
//  ArtistreeApp
//
//  Created by Nicolas Roldos on 6/29/17.
//  Copyright © 2017 artistreeapp. All rights reserved.
//

import UIKit

class VenuesNearMePickerController: UITableViewController {
	
	var selectedVenueName = ""
	
	let venues = []
	
	var selectedIndexPath = IndexPath()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		
		for i in 0..<venues.count {
			if venues[i] == selectedVenueName {
				selectedIndexPath = IndexPath(row: i, section: 0)
				break
			}
		}
		
	}
	
	
	
	
}
