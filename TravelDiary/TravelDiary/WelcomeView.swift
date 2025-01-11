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
                    FeatureItem(icon: "airplane", text: "Create and save trips.")
                    FeatureItem(icon: "pencil", text: "Add and edit entries.")
                    FeatureItem(icon: "photo", text: "Add pictures and locations.")
                    FeatureItem(icon: "arrow.up.circle", text: "Share and synchronize entries.")
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


#Preview {
    WelcomeView()
        .modelContainer(for: [Trip.self, Entry.self])
}
