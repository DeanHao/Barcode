//
//  AlbumDetailsViewController.swift
//  CDBarcodes
//
//  Created by Matthew Maher on 1/29/16.
//  Copyright © 2016 Matt Maher. All rights reserved.
//

import UIKit

class AlbumDetailsViewController: UIViewController {
	
	@IBOutlet weak var artistAlbumLabel: UILabel!
	@IBOutlet weak var yearLabel: UILabel!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		artistAlbumLabel.text = "Let's scan an album!"
		yearLabel.text = ""
		
		NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(setLabel(_:)), name: "AlbumNotification", object: nil)
		
	}
	
	func setLabel(notification: NSNotification) {
		let data = DataService.dataService
		
		let albumInfo = Album(artistAlbum: data.ALBUM_FROM_DISCOGS, albumYear: data.YEAR_FROM_DISCOGS)
		
		artistAlbumLabel.text = "\(albumInfo.album)"
		yearLabel.text = "\(albumInfo.year)"
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		
	}
	
}
