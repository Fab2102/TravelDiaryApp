//
//  BackendView.swift
//  TravelDiary
//
//  Created by Fabian on 10.01.25.
//

import SwiftUI



struct BackendView: View {
    
    @State private var entries: [BackendEntry] = []
    
    var body: some View {
        NavigationStack {
            List {
                if entries.isEmpty {
                    Text("No entries on the backend.")
                        .foregroundStyle(.secondary)
                } else {
                    ForEach(entries) { entry in
                        NavigationLink(value: entry) {
                            Text(entry.title)
                        }
                    }
                }
            }
            .navigationTitle("Backend Entries")
            .navigationDestination(for: BackendEntry.self) { entry in
                BackendDetailView(entry: entry)}
            .task {
                do {
                    entries = try await getEntries()
                } catch BeError.invalidURL {
                    print("Invalid URL")
                } catch BeError.invalidResponse {
                    print("Invalid response")
                } catch BeError.invalidData {
                    print("Invalid data")
                } catch {
                    print("Unknown Error: \(error)")
                }
            }
        }
    }
}


#Preview {
    BackendView()
}



struct BackendEntry: Identifiable, Codable, Hashable {
    let id: String
    let title: String
    let text: String
    let images: [Image]
    let locationName: String?
    let dateTime: String
    
    struct Image: Codable, Hashable {
        let id: String?
        let url: String
    }
}

enum BeError: Error {
    case invalidURL
    case invalidResponse
    case invalidData
}
