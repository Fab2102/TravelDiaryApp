//
//  WelcomeView.swift
//  TravelDiary
//
//  Created by Fabian on 07.01.25.
//

import SwiftUI
    

struct WelcomeView: View {
    
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
            VStack(spacing: 20) {
                Text("Welcome\n to Tripify!")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                    .padding(.top, 60)
                
                Text("Your Digital Travel Journal.")
                    .font(.title2)
                    .foregroundColor(.secondary)
                    .padding(.bottom, 60)
                    .padding(.top, 10)
                
                Text("With Tripify you can:")
                    .font(.headline)
                    .foregroundColor(.primary)
                
                VStack(alignment: .leading, spacing: 12) {
                    FeatureItem(icon: "airplane", text: NSLocalizedString("create_and_save_trips", comment: "Feature for creating and saving trips"))
                    FeatureItem(icon: "pencil", text: NSLocalizedString("add_and_edit_entries", comment: "Feature for adding and editing entries"))
                    FeatureItem(icon: "photo", text: NSLocalizedString("add_pictures_and_locations", comment: "Feature for adding pictures and locations"))
                    FeatureItem(icon: "arrow.up.circle", text: NSLocalizedString("share_and_synchronize_entries", comment: "Feature for sharing and synchronizing entries"))
                }
                .padding(.horizontal, 20)
                
                Spacer()
                
                Button(action: {
                    UserDefaults.standard.welcomeScreenShown = true
                    dismiss()
                }) {
                    HStack {
                        Text("Let's get started!")
                            .font(.system(size: 17))
                            .foregroundColor(.white)
                        Image(systemName: "arrow.right.circle")
                            .foregroundColor(.white)
                    }
                    .padding(.vertical, 16)
                    .padding(.horizontal, 75)
                    .background(Color.accentColor)
                    .foregroundColor(.white)
                    .cornerRadius(12)
                }
                .padding(.bottom, 100)
                
                
            }
            .padding()
            .onAppear(perform: {
                UserDefaults.standard.welcomeScreenShown = true
            })
    }
}


struct FeatureItem: View {
    var icon: String
    var text: String
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(.accentColor)
            Text(text)
                .font(.body)
                .foregroundColor(.primary)
        }
    }
}


#Preview("English") {
    WelcomeView()
        .modelContainer(for: [Trip.self, Entry.self], inMemory: true)
        .environment(\.locale, Locale(identifier: "EN"))
        
}

#Preview("German") {
    WelcomeView()
        .modelContainer(for: [Trip.self, Entry.self], inMemory: true)
        .environment(\.locale, Locale(identifier: "DE"))
}
