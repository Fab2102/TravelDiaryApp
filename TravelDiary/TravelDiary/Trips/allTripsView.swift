//
//  allTripsView.swift
//  TravelDiary
//
//  Created by Fabian on 26.12.24.
//

import Foundation
import SwiftUI
import SwiftData


struct allTripsView: View {
    
    @Query(sort: \Trip.name) var allTrips: [Trip]
    @Environment(\.modelContext) var modelContext
    
    var body: some View {
        List {
            if allTrips.isEmpty {
                Text("No trips available.")
                    .foregroundStyle(.secondary)
            } else {
                ForEach(allTrips) { trip_loop in
                    NavigationLink(value: trip_loop) {
                        tripRows(trip: trip_loop)
                    }
                    .swipeActions {
                        Button("Delete", role: .destructive) {
                            modelContext.delete(trip_loop)
                        }
                    }
                }
            }
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                AddTripButton()
            }
        }
        .navigationTitle("Trips")
        .navigationDestination(for: Trip.self) {trip in
            TripDetailView(trip: trip)
        }
    }
}



struct tripRows: View {
    
    @Environment(\.modelContext) var modelContext
    
    var trip: Trip
    
    var body: some View {
            Text(trip.name)
    }
}



#Preview {
    NavigationStack {
        allTripsView()
            .modelContainer(for: [Trip.self, Entry.self], inMemory: true)
    }
}
