//
//  TravelDiaryApp.swift
//  TravelDiary
//
//  Created by Fabian on 26.12.24.
//

import SwiftUI

@main
struct TravelDiaryApp: App {
    var body: some Scene {
        WindowGroup {
            MainView()
                .modelContainer(for: [Trip.self, Entry.self])
        }
    }
}
