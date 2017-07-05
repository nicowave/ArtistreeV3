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
	var venues = [String]()
	
	
	
	//	'viewDidLoad'
	//
	//
	//
	//
	override func viewDidLoad() {
		super.viewDidLoad()
		
		getVenues(coordinate: coordinate)

	
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
		print(venues.count, "\t number of venues in this tableview\n")
		return venues.count
	}

	override func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}
	
	// 'cellForRowAt indexPath'
	//
	//
	//
	//
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
	
		let cell = tableView.dequeueReusableCell(withIdentifier: "Cell",  for: indexPath)
		if let venue = venues[indexPath.row] as String? {
			
			cell.textLabel!.text = venue
		}
		return cell
	}
	

	//	MARK - 'UITableViewDelegate'
	//	
	//	
	//	
	//
//	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//		
//		if indexPath.row != selectedIndexPath.row {
//			if let newCell = tableView.cellForRow(at: indexPath) {
//				newCell.accessoryType = .checkmark
//			}
//			if let oldCell = tableView.cellForRow(at: selectedIndexPath) {
//				oldCell.accessoryType = .none
//			}
//			selectedIndexPath = indexPath
//		}
//	}
	
	
	//
	//
	//
	//
	//
	func getVenues(coordinate: CLLocationCoordinate2D) {
		
		let coordinateString = String(coordinate.latitude) + "," + String(coordinate.longitude)
			print("\n******\t" + coordinateString + "\t******\n")
		let endpoint = "https://api.foursquare.com/v2/venues/search?client_id=HVSJE4I0ZG1SVTHBJLZUUALAV32FXW03PVSUY1KPIYYMU0H5&client_secret=UVLSIJIVTZORUESDYHVPO14RNPVOFYWMSGEJMMWEYG0NECXL&v=20130815&ll=" + coordinateString + "&query=art"
		
		let url: URL = URL(string: endpoint)!
		let session = URLSession(configuration: URLSessionConfiguration.default)
		var request = URLRequest(url: url)
		request.httpMethod = "GET"
		
		let task = session.dataTask(with: request, completionHandler: { (data, response, error) in
			
			let response = response as! HTTPURLResponse
			
			let status = response.statusCode
			if (status == 200) {
				print("\n Success, HTTP response went through \n")
			}
			if let data = data as Data? {
				self.extractJSON(data: data)
			}
		})
		task.resume()
	}
	
	
	
	//	'extractJSON' function
	//
	//
	//
	//
	func extractJSON(data: Data) {
		let json: [String: AnyObject]
		
		do {
			json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String: AnyObject]
		} catch {
			print("Error with Json: \(error)")
			return
		}
		if let res = json["response"] as? [String: AnyObject] {
			if let artVenues = res["venues"] as? [[String: Any]] {
				for venue in artVenues {
					if let currentVenue = venue["name"] as? String {
						venues.append(currentVenue)
						
					}
				}
			}
		}
		DispatchQueue.main.async(execute:	{
			print(self.venues)
			self.tableView.reloadData()
			
		})
	}
	


	
}
