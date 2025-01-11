//
//  TripModel.swift
//  TravelDiary
//
//  Created by Fabian on 26.12.24.
//


import Foundation
import SwiftData


@Model
class Trip {
    var name: String
    @Relationship(deleteRule: .cascade) var tripEntries: [Entry]
    
    init(name: String) {
        self.name = name
        tripEntries = []
    }
}
