//
//  utils.swift
//  TravelDiary
//
//  Created by Fabian on 05.01.25.
//
import Foundation


// date to string
public func formatDateToString(date: Date) -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "dd.MM.yyyy HH:mm"
    return formatter.string(from: date)
}

// string to string (backend)
public func formatDate(_ dateTime: String) -> String {
    guard dateTime.count >= 19 else { return dateTime }
    let year = dateTime.prefix(4)
    let month = dateTime[dateTime.index(dateTime.startIndex, offsetBy: 5)..<dateTime.index(dateTime.startIndex, offsetBy: 7)]
    let day = dateTime[dateTime.index(dateTime.startIndex, offsetBy: 8)..<dateTime.index(dateTime.startIndex, offsetBy: 10)]
    let timePart = dateTime[dateTime.index(dateTime.startIndex, offsetBy: 11)..<dateTime.index(dateTime.startIndex, offsetBy: 16)]
    return "\(day).\(month).\(year) \(timePart)"
}


// API GET
func getEntries() async throws -> [BackendEntry] {
    
    let endpoint = "https://travel-diary.moetz.dev/api/v1/diary"
    
    guard let url = URL(string: endpoint) else {
        throw BeError.invalidURL
    }
    
    let (data, response) = try await URLSession.shared.data(from: url)
    
    guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
        throw BeError.invalidResponse
    }
    
    let decoder = JSONDecoder()
    decoder.keyDecodingStrategy = .convertFromSnakeCase
    
    do {
        return try decoder.decode([BackendEntry].self, from: data)
    } catch {
        let singleEntry = try decoder.decode(BackendEntry.self, from: data)
        return [singleEntry]
    }
}


// API POST
func postEntry(entry: Entry) async throws -> PostEntryResult {
    let endpoint = "https://travel-diary.moetz.dev/api/v1/diary"
    
    guard let url = URL(string: endpoint) else {
        throw BeError.invalidURL
    }
    
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    
    let requestBody: [String: Any] = [
        "title": entry.title,
        "text": entry.text,
        "locationName": entry.place ?? "",
        "images": entry.images.isEmpty ? [] : entry.images.map { $0.base64EncodedString() },
        "dateTime": ISO8601DateFormatter().string(from: entry.timestamp)
    ]
    
    guard let jsonData = try? JSONSerialization.data(withJSONObject: requestBody, options: .fragmentsAllowed) else {
        throw BeError.invalidData
    }
    
    request.httpBody = jsonData
    
    let (data, response) = try await URLSession.shared.data(for: request)
    
    guard let httpResponse = response as? HTTPURLResponse else {
        throw BeError.invalidResponse
    }
    
    let statusCode = httpResponse.statusCode
    guard (200...299).contains(statusCode) else {
        throw BeError.invalidResponse
    }
    
    let decoder = JSONDecoder()
    decoder.keyDecodingStrategy = .convertFromSnakeCase
    
    if let responseBody = try? decoder.decode(CreatedDiaryResponse.self, from: data) {
        return PostEntryResult(id: responseBody.id, statusCode: statusCode)
    } else {
        if let responseString = String(data: data, encoding: .utf8) {
            print("Error: Unexpected response format - \(responseString)")
        }
        throw BeError.invalidData
    }
}


struct CreatedDiaryResponse: Codable {
    let id: String
}

struct PostEntryResult {
    let id: String
    let statusCode: Int
}
