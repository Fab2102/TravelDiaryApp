//
//  AddTripView.swift
//  TravelDiary
//
//  Created by Fabian on 26.12.24.
//

import Foundation
import SwiftUI
import SwiftData


struct AddTripView: View {
    
    @State private var name = ""
    @State private var alertMessage = ""
    @State private var showAlert = false
    
    @Environment(\.modelContext) var modelContext
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            Form {
                Section("Tripname") {
                    TextField("Name", text: $name)
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Save") {
                        if !name.isEmpty {
                            let newTrip = Trip(name: name)
                            modelContext.insert(newTrip)
                            dismiss()
                        } else {
                            alertMessage = "The trip name cannot be empty!"
                            showAlert = true
                        }
                    }
                }
            }
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text("Error"),
                    message: Text(alertMessage),
                    dismissButton: .default(Text("OK"))
                )
            }
        }
    }
}



#Preview {
    AddTripView()
        .modelContainer(for: [Trip.self], inMemory: true)
}
