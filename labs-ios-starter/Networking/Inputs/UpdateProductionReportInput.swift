//
//  UpdateProductionReportInput.swift
//  labs-ios-starter
//
//  Created by Christy Hicks on 10/14/20.
//  Copyright © 2020 Spencer Curtis. All rights reserved.
//

import Foundation

class UpdateProductionReportInput: Input {
    private let id: String
    private let date: Date?
    private let barsProduced, soapmakersWorked, soapmakerHours: Int?
    private let soapPhotos, media: [String]?
    
    private var soapPhotosQuery: String {
        guard let soapPhotos = soapPhotos, !soapPhotos.isEmpty else {
            return ""
        }
        
        var photoArray: [String] = []
        
        for photo in soapPhotos {
            photoArray.append(photo)
        }
        
        return "soapPhotos: [\(photoArray.joined(separator: ", "))]\n"
    }
    
    private var mediaQuery: String {
        guard let media = media, !media.isEmpty else {
            return ""
        }
        
        var mediaArray: [String] = []
        
        for item in media {
            mediaArray.append(item)
        }
        
        return "media: [\(mediaArray.joined(separator: ", "))]\n"
    }
    
    private var queryBody: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-mm-dd"
        var string = ""
        
        if let date = date {
            string += "date: \"\(date.asShortDateString())\"\n"
        }
        
        if let barsProduced = barsProduced {
            string += "barsProduced: \(barsProduced)\n"
        }
        
        if let soapmakersWorked = soapmakersWorked {
            string += "soapmakersWorked: \(soapmakersWorked)\n"
        }
        
        if let soapmakerHours = soapmakerHours {
            string += "soapmakerHours: \(soapmakerHours)\n"
        }
        
        string += soapPhotosQuery
        string += mediaQuery
        
        return string
    }
    
    var formatted: String {
        return """
        id: \"\(id)\"
        \(queryBody)
        """
    }
    
    internal init(id: String,
                  date: Date? = nil,
                  barsProduced: Int? = nil,
                  soapmakersWorked: Int? = nil,
                  soapmakerHours: Int? = nil,
                  soapPhotos: [String]? = nil,
                  media: [String]? = nil) {
        
        self.id = id
        self.date = date
        self.barsProduced = barsProduced
        self.soapmakersWorked = soapmakersWorked
        self.soapmakerHours = soapmakerHours
        self.soapPhotos = soapPhotos
        self.media = media
    }
}
