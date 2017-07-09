//
//  HUDView.swift
//  ArtistreeApp
//
//  Created by Nicolas Roldos on 7/9/17.
//  Copyright © 2017 artistreeapp. All rights reserved.
//

import Foundation
import UIKit



class HUDView: UIView {
	var text = ""
	
	class func hud(inView view: UIView, animated: Bool) -> HUDView {
	
		let hudView = HUDView(frame: view.bounds)
		hudView.isOpaque = false
		hudView.backgroundColor = UIColor(red: 1, green: 0, blue: 0, alpha: 0.5)
		
		view.addSubview(hudView)
		view.isUserInteractionEnabled = false
		
		return hudView
	}
	
	
	
	
	
	
	override func draw(_ rect: CGRect) {
		let boxWidth:  CGFloat = 96
		let boxHeight: CGFloat = 96
		
		let boxRect = CGRect(
			x: round((bounds.size.width - boxWidth) / 2),
			y: round((bounds.size.height - boxHeight) / 2),
			width: boxWidth,
			height: boxHeight)
		
		let roundedRect = UIBezierPath(roundedRect: boxRect, cornerRadius: 10)
		UIColor(white: 0.3, alpha: 0.8).setFill()
		roundedRect.fill()
		
		if let image = UIImage(named: "Checkmark") {
			
			let imagePoint = CGPoint(
				x: center.x - round(image.size.width / 2),
				y: center.y - round(image.size.width / 2) - boxHeight / 8)

			image.draw(at: imagePoint)
		}
	}
}
