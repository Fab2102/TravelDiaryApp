//
//  EntryModel.swift
//  TravelDiary
//
//  Created by Fabian on 26.12.24.
//

import Foundation
import SwiftData

@Model
class Entry {
    var title: String
    var text: String
    var images: [Data]
    var place: String?
    var timestamp: Date

    init(title: String, text: String, images: [Data] = [], place: String? = "", timestamp: Date = Date()) {
        self.title = title
        self.text = text
        self.images = images
        self.place = place
        self.timestamp = timestamp
    }
}

