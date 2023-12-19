//
//  SearchBarView.swift
//  WeatherForecast
//
//  Created by Tom Brhel on 17.12.2023.
//

import SwiftUI

struct SearchBarView: View {
    
    private let islocationAuthorized: Bool
    private let permissionString: String
    @State private var animationState = false
    @FocusState private var textFieldIsFocused: Bool
    @State private var enteredCity: String = ""
    
    var onLocationClicked: () -> Void
    var onSearchClicked: (String) -> Void
    
    init(
        islocationAuthorized: Bool,
        permissionString: String,
        onLocationClicked: @escaping () -> Void,
        onSearchClicked: @escaping (String) -> Void
    ) {
        self.islocationAuthorized = islocationAuthorized
        self.permissionString = permissionString
        self.onLocationClicked = onLocationClicked
        self.onSearchClicked = onSearchClicked
    }
    
    var body: some View {
        HStack(alignment: .center, spacing: 8) {
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
                    
                } else {
                    onLocationClicked()
                }
                withAnimation(.easeOut(duration: 3).repeatCount(3, autoreverses: true)) {
                    animationState.toggle()

                }
            } label: {
                Image(systemName: "location.circle")
                    .font(.system(size: 32, weight: .light))
                    .rotationEffect(.degrees(animationState ? 360 : 0))
                    .scaleEffect(animationState ? 1.3 : 1)
            }
            
            TextField("Enter city", text: $enteredCity)
                .submitLabel(.search)
                .frame(width: 164, height: 32)
                .padding(EdgeInsets(top: 0, leading: 6, bottom: 0, trailing: 6))
                .background(Color.searchFieldColor)
                .cornerRadius(8)
                .shadow(radius: 5)
                .focused($textFieldIsFocused)
                .onSubmit {
                    textFieldIsFocused = false
                    // fix for cities with whitespace like San Francisco, New York etc.
                    enteredCity = enteredCity.split(separator: " ").joined(separator: "+")
                    onSearchClicked(enteredCity)
                    enteredCity = ""
                }
            
            Spacer()
        }
    }
}

struct SearchBarView_Previews: PreviewProvider {
    static var previews: some View {
        SearchBarView(
            islocationAuthorized: true,
            permissionString: "Permision bla bla",
            onLocationClicked: {},
            onSearchClicked: { _ in }
        )
    }
}
