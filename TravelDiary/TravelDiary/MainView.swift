//
//  MainView.swift
//  TravelDiary
//
//  Created by Fabian on 26.12.24.
//

import SwiftUI


extension UserDefaults {
    var welcomeScreenShown: Bool {
        get {
            return (UserDefaults.standard.value(forKey: "welcomeScreenShown") as? Bool) ?? false
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: "welcomeScreenShown")
        }
    }
}


struct MainView: View {
    
    @State private var showWelcomeScreen: Bool = !UserDefaults.standard.welcomeScreenShown
    
    var body: some View {
        TabView {
            Tab("Trips", systemImage: "airplane") {
                NavigationStack {
                    allTripsView()
                }
            }
            
            Tab("Backend Entries", systemImage: "cloud") {
                BackendView()
            }
        }
        .sheet(isPresented: $showWelcomeScreen) {
            WelcomeView()
                .presentationDetents([.large])
        }
    }
}

#Preview("English") {
    MainView()
        .modelContainer(for: [Trip.self, Entry.self], inMemory: true)
        .environment(\.locale, Locale(identifier: "EN"))
        
}

#Preview("German") {
    MainView()
        .modelContainer(for: [Trip.self, Entry.self], inMemory: true)
        .environment(\.locale, Locale(identifier: "DE"))
}

