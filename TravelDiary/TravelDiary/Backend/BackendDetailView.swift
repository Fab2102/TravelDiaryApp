//
//  BackendDetailView.swift
//  TravelDiary
//
//  Created by Fabian on 11.01.25.
//

import SwiftUI



struct BackendDetailView: View {
    
    let entry: BackendEntry
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                Text(entry.title.isEmpty ? "Unnamed Entry" : entry.title)
                    .font(.title)
                    .padding(.bottom, 10)
                
                Text((entry.locationName?.isEmpty == false ? entry.locationName : "Unknown Location")!)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                Text(formatDate(entry.dateTime))
                    .font(.footnote)
                    .foregroundColor(.gray)
                    .padding(.bottom, 20)
                
                Divider()
                
                Text(entry.text.isEmpty ? "Could not find any text." : entry.text)
                    .padding(.top, 15)
                
                if entry.images.isEmpty {
                    Text("No images available.")
                        .foregroundStyle(.secondary)
                        .padding(.top, 25)
                } else {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 16) {
                            ForEach(entry.images, id: \.id) { image in
                                if let url = URL(string: image.url) {
                                    AsyncImage(url: url) { phase in
                                        switch phase {
                                        case .success(let img):
                                            img
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: 120, height: 120)
                                                .cornerRadius(12)
                                        case .failure:
                                            Text("Image could not be loaded")
                                                .frame(width: 120, height: 120)
                                        default:
                                            ProgressView()
                                                .frame(width: 120, height: 120)
                                        }
                                    }
                                }
                            }
                        }
                        .padding(.top, 25)
                    }
                }
                
            }
            .padding(.horizontal, 35)
            .padding(.top, 30)
        }
    }
}


#Preview {
    let sampleEntry = BackendEntry(
            id: "1",
            title: "Sample Entry Title",
            text: "This is a sample entry description. It can be several lines long.",
            images: [
                    BackendEntry.Image(id: "1", url: "https://travel-diary.moetz.dev/diary/74a8d9ad-171c-4a6b-97ae-0e709961b2ed/image/baf39c8a-bfb7-400c-8a82-c863773cec72.png"),
                    BackendEntry.Image(id: "2", url: "https://travel-diary.moetz.dev/diary/b65892cf-437f-4256-9621-ecee5c34b11f/image/d95669f8-e1bc-4f47-bb6f-a6e18c340162.png"),
                    BackendEntry.Image(id: "3", url: "https://travel-diary.moetz.dev/diary/ae088408-7b92-4b3a-bb0f-cef667a212cf/image/89060e72-8f8e-4ff4-8d7c-6ee3aa88c890.png")
                ],
            locationName: "Vienna",
            dateTime: "2024-12-11T13:29:41.054923817Z")
    
    
    BackendDetailView(entry: sampleEntry)
}

