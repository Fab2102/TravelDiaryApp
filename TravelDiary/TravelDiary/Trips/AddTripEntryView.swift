//
//  AddTripEntryView.swift
//  TravelDiary
//
//  Created by Fabian on 26.12.24.
//

import Foundation
import SwiftUI
import SwiftData
import PhotosUI

struct AddTripEntryView: View {
    
    @Bindable var trip: Trip
    
    @State private var title = ""
    @State private var text = ""
    @State private var place = ""
    @State private var timestamp = Date()
    
    @State private var photosPickerItems: [PhotosPickerItem] = []
    @State private var images: [UIImage] = []
    
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    @Environment(\.modelContext) var modelContext
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            Form {
                Section("Title") {
                    TextField("Title", text: $title)
                }
                Section("Text") {
                    TextField("Text", text: $text)
                }
                Section("Location (optional)") {
                    TextField("Location", text: $place)
                }
                Section("Images (optional)") {
                    VStack(alignment: .leading, spacing: 16) {
                        PhotosPicker(selection: $photosPickerItems,
                                     selectionBehavior: .ordered,
                                     matching: .images) {
                            Label("Add images", systemImage: "photo")
                        }
                        if !images.isEmpty {
                            ScrollView(.horizontal) {
                                HStack(spacing: 20) {
                                    ForEach(0..<images.count, id: \.self) { item in
                                        Image(uiImage: images[item])
                                            .resizable()
                                            .frame(width: 80, height: 80)
                                            .cornerRadius(8)
                                    }
                                }
                            }
                        }
                    }
                }
                .onChange(of: photosPickerItems) { _, items in
                    Task {
                        photosPickerItems.removeAll()
                        images.removeAll()
                        for item in items {
                            if let data = try? await item.loadTransferable(type: Data.self),
                               let image = UIImage(data: data) {
                                images.append(image)
                            }
                        }
                    }
                }
                Section("Created on:") {
                    Text(formatDateToString(date: timestamp))
                        .foregroundColor(.gray)
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
                        if !title.isEmpty && !text.isEmpty {
                            let imageData = images.compactMap { $0.jpegData(compressionQuality: 0.8) }
                            let newEntry = Entry(title: title,
                                                 text: text,
                                                 images: imageData,
                                                 place: place,
                                                 timestamp: timestamp)
                            
                            trip.tripEntries.append(newEntry)
                            dismiss()
                        } else {
                            alertMessage = NSLocalizedString("title_and_text_empty", comment: "")
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
    @Previewable @State var trip_preview = Trip(name: "Test")
    AddTripEntryView(trip: trip_preview)
        .modelContainer(for: [Trip.self], inMemory: true)
}

