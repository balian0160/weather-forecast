//
//  ShareButtonView.swift
//  WeatherForecast
//
//  Created by Tom Brhel on 17.12.2023.
//

import SwiftUI


struct ShareButtonView: View {
    
    private let temperature: String
    private let units: String
    
    init(temperature: String, units: String) {
        self.temperature = temperature
        self.units = units
    }
    
    var body: some View {
        Button {
            let stringToShare = "Hey man! Have you heard about this app?"
            guard let url = URL(string: "https://www.google.com") else {
                return }
            let stringToShare2 = "Btw, this is the temperature given by my new app:"
            let activityController = UIActivityViewController(
                activityItems: [stringToShare, url, stringToShare2, temperature + units],
                applicationActivities: nil
            )
            
            let scenes = UIApplication.shared.connectedScenes
            let windowScene = scenes.first as? UIWindowScene
            let window = windowScene?.windows.first
            let rootVC = window?.rootViewController ?? nil
            rootVC?.present(activityController, animated: true, completion: nil)
            
        } label: {
            HStack {
                Spacer()
                Text("Share")
                    .font(.regularLabel)
                    .foregroundColor(.shareButtonTextColor)
                Spacer()
            }
            .padding(.vertical, 8)
            .background(Color.shareButtonBackColor)
            .cornerRadius(32)
            .shadow(radius: 15)
        }
        .frame(width: 85, height: 45)
        .padding(.horizontal, 20)
    }
}

struct ShareButtonView_Previews: PreviewProvider {
    static var previews: some View {
        ShareButtonView(temperature: "20.5", units: "C")
    }
}
