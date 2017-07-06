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
	var distances = [Int]()
	
	
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
	
	
	
	
	
	
	//		MARK-- UITable Data Source 'numberOfRowsInSection' function
	//	
	//	
	//	
	//
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		print(venues.count, "\n\t number of venues in this tableView\n")
		return venues.count
	}

	
	//		'numberOfSections' in tableView
	//
	//
	//
	//
	override func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}
	
	
	//	'heightForRowAt' function, allows you to maintain custom table-ROW-heights
	//
	//
	//
	//
	override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return 88
	}
	
	
	// 'tableView function:	cellForRowAt indexPath:'
	//
	//
	//
	//
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		
		let cell = tableView.dequeueReusableCell(withIdentifier:"Cell", for: indexPath)
		let venueName = venues[indexPath.row] as String
		
		if let venueName = venues[indexPath.row] as String?, let distance = distances[indexPath.row] as Int? {
			let distanceInMiles = String(format: "%.2f", (Double(distance) * 0.000621371))
			cell.textLabel?.text = venueName
			cell.detailTextLabel?.text = distanceInMiles + " miles"
		}
		if venueName == selectedVenueName {
			cell.accessoryType = .checkmark
		} else {
			cell.accessoryType = .none
		}
		
		return cell
	}
	

	//	MARK - 'UITableViewDelegate'
	//
	//	'didSelectRowAt' function
	//
	//	
	//	
	//
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		
		//		NOTE: insert new logic in here to get venue name into segue
		selectedIndexPath = indexPath
		print(selectedIndexPath.row)
		
		if let selectedCell = tableView.cellForRow(at: selectedIndexPath) {
			selectedCell.accessoryType = .checkmark
			selectedVenueName = venues[selectedIndexPath.row]
			print(selectedVenueName)
		}
	}

	
	

	
	
	//	'prepareForSegue' function transfers picked venue -BASED ON- the indexPath.row
	//		for the cell it came from
	//
	//
	//
	//
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == "VenuePicked" {
			let cell = sender as! UITableViewCell
			if let indexPath = tableView.indexPath(for: cell) {
				selectedVenueName = venues[indexPath.row]
			}
		}
	}
	
	
	
	// 'getVenues' function fetches data from FourSquare API
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
	
	
	
	
	//	'extractJSON' function: extracts JSON from HTTP GET request
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
					if let location = venue["location"] as? [String: AnyObject] {
						if let distance = location["distance"] as? Int {
							distances.append(distance)
						}
					}
				}
			}
		}
		DispatchQueue.main.async(execute:	{
			print(self.venues)
			print(self.distances)
			self.tableView.reloadData()
		})
	}
	


	
}
