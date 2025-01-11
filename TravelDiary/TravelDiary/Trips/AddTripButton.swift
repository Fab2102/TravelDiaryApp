//
//  AddTripButton.swift
//  TravelDiary
//
//  Created by Fabian on 26.12.24.
//

import Foundation
import SwiftUI



struct AddTripButton: View  {
    
    @Environment(\.modelContext) var modelContext
    @State private var showSheet = false
    
    var body: some View {
        Button(action: {
            showSheet = true
        }, label: {
            Image(systemName: "plus")
        })
        .sheet(isPresented: $showSheet) {
            AddTripView()
                .presentationDetents([.height(450)])
        }
        
    }
}
    
    
#Preview {
    AddTripButton()
        .modelContainer(for: [Trip.self, Entry.self], inMemory: true)
}
