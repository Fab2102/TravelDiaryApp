import Foundation
import SwiftUI
import SwiftData
import PhotosUI




struct TripEntryDetailView: View {
    
    @Bindable var tripEntry: Entry
    @State private var photosPickerItems_edit: [PhotosPickerItem] = []
    @State private var images_edit: [UIImage] = []
    
    @State private var alertMessage: String = ""
    @State private var showAlert: Bool = false
    @State private var isLoading: Bool = false
    
    var body: some View {
        ZStack {
            Form {
                Section("Title") {
                    TextField("Title", text: $tripEntry.title)
                }
                Section("Text") {
                    TextField("Text", text: $tripEntry.text)
                }
                Section("Location") {
                    TextField("Location", text: Binding(
                        get: { tripEntry.place ?? "" },
                        set: { tripEntry.place = $0.isEmpty ? nil : $0 }
                    ))
                }
                Section("Images") {
                    VStack(alignment: .leading, spacing: 16) {
                        PhotosPicker(selection: $photosPickerItems_edit,
                                     selectionBehavior: .ordered,
                                     matching: .images) {
                            Label("Edit images", systemImage: "photo")
                        }
                        if !tripEntry.images.isEmpty {
                            ScrollView(.horizontal) {
                                HStack(spacing: 20) {
                                    ForEach(tripEntry.images, id: \.self) { imageData in
                                        if let image = UIImage(data: imageData) {
                                            Image(uiImage: image)
                                                .resizable()
                                                .frame(width: 80, height: 80)
                                                .cornerRadius(8)
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                .onChange(of: photosPickerItems_edit) { _, items in
                    Task {
                        tripEntry.images.removeAll()
                        photosPickerItems_edit.removeAll()
                        images_edit.removeAll()
                        
                        for item in items {
                            if let data = try? await item.loadTransferable(type: Data.self),
                               let image = UIImage(data: data) {
                                images_edit.append(image)
                            }
                        }
                        let imageData = images_edit.compactMap { $0.jpegData(compressionQuality: 0.8) }
                        tripEntry.images = imageData
                    }
                }
                Section("Created on:") {
                    Text(formatDateToString(date: tripEntry.timestamp))
                        .foregroundColor(.gray)
                }
            }
            
            // Show ProgressView when isLoading is true
            if isLoading {
                VStack {
                    Spacer()
                    ProgressView("Sharing...")
                        .padding(.top, 20)
                    Spacer()
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity) // Make Pro
                .background(Color.black.opacity(0.2))
                .edgesIgnoringSafeArea(.all)
            }
        }
        .navigationTitle(tripEntry.title)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("Share") {
                    Task {
                        isLoading = true
                        do {
                            let result = try await postEntry(entry: tripEntry)
                            alertMessage = "Successfully published!\nHTTP status code: \(result.statusCode)\nID: \(result.id)"
                            showAlert = true
                        } catch {
                            alertMessage = "Error while publishing.\nError: \(error)"
                            showAlert = true
                        }
                        isLoading = false
                    }
                }
            }
        }
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Status"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
    }
}



#Preview {
    @Previewable @State var tripEntry_preview = Entry(title: "Test Eintrag 8", text: "Test", images: [], place: "Test")
    NavigationStack {
        TripEntryDetailView(tripEntry: tripEntry_preview)
    }
}
