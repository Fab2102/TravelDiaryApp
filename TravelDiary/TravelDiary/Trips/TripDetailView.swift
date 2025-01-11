//
//  TripDetailView.swift
//  TravelDiary
//
//  Created by Fabian on 26.12.24.
//

import Foundation
import SwiftUI
import SwiftData



struct TripDetailView: View {
    
    @Bindable var trip: Trip
    @Environment(\.modelContext) var modelContext
    
    var body: some View {
        List {
            Section("Entries for \(trip.name)") {
                if trip.tripEntries.isEmpty {
                    Text("No entries available.")
                        .foregroundColor(.secondary)
                } else {
                    ForEach(trip.tripEntries) { item in
                        NavigationLink(value: item) {
                            TripEntryRows(entry: item)
                        }
                        .swipeActions {
                            Button("Delete", role: .destructive) {
                                let index = trip.tripEntries.firstIndex(where: { entry in
                                    entry.id == item.id
                                })
                                if let index = index {
                                    let entryToRemove = trip.tripEntries.remove(at: index)
                                    modelContext.delete(entryToRemove)
                                }
                            }
                        }
                    }
                }
            }
        }
        .navigationTitle("Entries")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                AddTripEntryButton(trip: trip)
            }
        }
        .navigationDestination(for: Entry.self) { item in
            TripEntryDetailView(tripEntry: item)
        }
    }
}



struct TripEntryRows: View {
    
    let entry: Entry
    
    var body: some View {
        Text(entry.title)
    }
}


#Preview {
    @Previewable var trip_preview = Trip(name: "Test")
    NavigationStack {
        TripDetailView(trip: trip_preview)
    }
}
