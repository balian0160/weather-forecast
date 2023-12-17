//
//  ActivityIndicator.swift
//  WeatherForecast
//
//  Created by Tom Brhel on 17.12.2023.
//

import SwiftUI

struct ActivityIndicator: View {
    
    @State var degress = 0.0
    
    var body: some View {
        Circle()
            .trim(from: 0.0, to: 0.6)
            .stroke(Color("gradientEndColor"), lineWidth: 10.0)
            .frame(width: 120, height: 120)
            .rotationEffect(Angle(degrees: degress))
            .onAppear(perform: { self.start() })
    }
    
    func start() {
        _ = Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { _ in
            withAnimation {
                self.degress += 10.0
            }
            if self.degress == 360.0 {
                self.degress = 0.0
            }
        }
    }
}

struct ActivityIndicator_Previews: PreviewProvider {
    static var previews: some View {
        ActivityIndicator()
    }
}
