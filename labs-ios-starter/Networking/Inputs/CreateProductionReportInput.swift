//
//  CreateProductionReportInput.swift
//  labs-ios-starter
//
//  Created by Christy Hicks on 10/14/20.
//  Copyright © 2020 Spencer Curtis. All rights reserved.
//

import Foundation

class CreateProductionReportInput: Input {
    let hubId: String
    let date: Date
    let barsProduced, soapmakersWorked, soapmakerHours: Int?
    let soapPhotos, media: [String]?

    
    var formatted: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-mm-dd"
        var string = """
        hubId: \"\(hubId)\"
        date: \"\(date.asShortDateString())\"
        """
        if let barsProduced = barsProduced {
            string += "barsProduced: \(barsProduced)\n"
        }

        if let soapmakersWorked = soapmakersWorked {
            string += "soapmakersWorked: \(soapmakersWorked)\n"
        }

        if let soapmakerHours = soapmakerHours {
            string += "soapmakerHours: \(soapmakerHours)\n"
        }

        var soapPhotoQuery: String {
            guard let soapPhotos = soapPhotos, !soapPhotos.isEmpty else {
                return ""
            }
            var string = "soapPhotos: ["
            for photo in soapPhotos {
                string += "\"\(photo)\", "
            }
            string += "]\n"
            return string
        }
        
        var mediaQuery: String {
            guard let media = media, !media.isEmpty else {
                return ""
            }
            var string = "media: ["
            for item in media {
                string += "\"\(item)\", "
            }
            string += "]\n"
            return string
        }
        
        string += soapPhotoQuery
        string += mediaQuery
        
        return string
    }
    
    init(hubId: String,
         date: Date,
         barsProduced: Int?,
         soapmakersWorked: Int?,
         soapmakerHours: Int?,
         soapPhotos: [String]?,
         media: [String]?) {
        
        self.hubId = hubId
        self.date = date
        self.barsProduced = barsProduced
        self.soapmakersWorked = soapmakersWorked
        self.soapmakerHours = soapmakerHours
        self.soapPhotos = soapPhotos
        self.media = media
    }
}
