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
        let string = """
        hubId: \(hubId)
        date: \"\(date.asShortDateString())\"
        barsProduced: \(String(describing: barsProduced))
        soapmakersWorked: \(String(describing: soapmakersWorked))
        soapmakerHours: \(String(describing: soapmakerHours))
        soapPhotos: \(String(describing: soapPhotos))
        media: \(String(describing: media))
        """
        return string
    }
    
    init (hubId: String, date: Date, barsProduced: Int?, soapmakersWorked: Int?, soapmakerHours: Int?, soapPhotos: [String]?, media: [String]?) {
        self.hubId = hubId
        self.date = date
        self.barsProduced = barsProduced
        self.soapmakersWorked = soapmakersWorked
        self.soapmakerHours = soapmakerHours
        self.soapPhotos = soapPhotos
        self.media = media
    }
}
