//
//  Album.swift
//  CDBarcodes
//
//  Created by Matthew Maher on 1/29/16.
//  Copyright © 2016 Matt Maher. All rights reserved.
//

import Foundation

class Album {
    private(set) var album:String!
    private(set) var year:String!
    
    init(artistAlbum:String,albumYear:String) {
        self.album = "Album:  \n  \(artistAlbum)"
        self.year = "Released in:  \(albumYear)"
    }
}