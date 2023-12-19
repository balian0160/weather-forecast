//
//  EnableLocationView.swift
//  WeatherForecast
//
//  Created by Tom Brhel on 17.12.2023.
//

import SwiftUI


struct EnableLocationView: View {

    private let islocationAuthorized: Bool
    private let permissionString: String
    
    init(islocationAuthorized: Bool, permissionString: String) {
        self.islocationAuthorized = islocationAuthorized
        self.permissionString = permissionString
    }
    
    var body: some View {
        HStack {
            Spacer()
            Button {
                if !islocationAuthorized {
                    let alertController = UIAlertController(title: "Location Permission Required", message: permissionString, preferredStyle: UIAlertController.Style.alert)
                           
                    let okAction = UIAlertAction(title: "Settings", style: .default, handler: { _ in
                        // Redirect to Settings app
                        guard let url = URL(string: UIApplication.openSettingsURLString) else {
                            return
                        }
                        UIApplication.shared.open(url)
                        
                    })
                           
                    let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel)
                    alertController.addAction(cancelAction)
                    alertController.addAction(okAction)
                    
                    let scenes = UIApplication.shared.connectedScenes
                    let windowScene = scenes.first as? UIWindowScene
                    let window = windowScene?.windows.first
                    let rootVC = window?.rootViewController ?? nil
                    rootVC?.present(alertController, animated: true, completion: nil)
                }
            } label: {
                HStack {
                    Spacer()
                    Text("Enable location")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.shareButtonTextColor)
                    Spacer()
                }
                .padding(.vertical, 8)
                .background(Color.shareButtonBackColor)
                .cornerRadius(32)
                .shadow(radius: 15)
            }
            .frame(width: 135, height: 45)
            Spacer()
        }
    }
}

struct EnableLocationView_Previews: PreviewProvider {
    static var previews: some View {
        EnableLocationView(islocationAuthorized: true, permissionString: "permission bla bla")
    }
}
