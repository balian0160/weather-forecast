//
//  NoConnectionView.swift
//  WeatherForecast
//
//  Created by Tom Brhel on 17.12.2023.
//

import SwiftUI

struct NoConnectionView: View {
    var body: some View {
        VStack {
            Image(systemName: "wifi.slash")
                .font(.system(size: 56))
            Text("Not connected!")
                .padding()
        }
    }
}

struct NoConnectionView_Previews: PreviewProvider {
    static var previews: some View {
        NoConnectionView()
    }
}
