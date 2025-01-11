//
//  AddTripEntryButton.swift
//  TravelDiary
//
//  Created by Fabian on 26.12.24.
//

import Foundation
import SwiftUI


struct AddTripEntryButton: View  {
    
    @Bindable var trip: Trip
    @Environment(\.modelContext) var modelContext
    @State private var showSheet = false
    
    var body: some View {
        Button(action: {
            showSheet = true
        }, label: {
            Image(systemName: "plus")
        })
        .sheet(isPresented: $showSheet) {
            AddTripEntryView(trip: trip)
                .presentationDetents([.height(750)])
        }
        
    }
}
    
    
#Preview {
    @Previewable @State var trip_preview = Trip(name: "Test")
    AddTripEntryButton(trip: trip_preview)
        .modelContainer(for: [Trip.self, Entry.self], inMemory: true)
}
