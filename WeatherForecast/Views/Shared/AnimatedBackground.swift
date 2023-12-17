//
//  AnimatedBackground.swift
//  WeatherForecast
//
//  Created by Tom Brhel on 17.12.2023.
//

import SwiftUI

struct AnimatedBackground: View {
    @State var start = UnitPoint.bottom
    @State var end = UnitPoint.topLeading

    let timer = Timer.publish(every: 1, on: .main, in: .default).autoconnect()
    let colors: [Color] = [.init("gradientStartColor"), .init("gradientMiddleColor1"), .init("gradientMiddleColor2"), .init("gradientEndColor")]

    var body: some View {
        LinearGradient(gradient: Gradient(colors: colors), startPoint: start, endPoint: end)
            .animation(Animation.easeInOut(duration: 6).repeatForever(autoreverses: true), value: start)
            .onReceive(timer) { _ in
                 
                self.start = . bottomLeading
                self.end = .top
            }
            .edgesIgnoringSafeArea(.all)
    }
}

struct AnimatedBackground_Previews: PreviewProvider {
    static var previews: some View {
        AnimatedBackground()
    }
}
