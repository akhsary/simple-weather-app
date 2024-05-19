//
//  ErrorView.swift
//  SimpleWeather
//
//  Created by Юрий Чекан on 17.05.2024.
//

import SwiftUI
struct ErrorView: View {
    let error: String
    var body: some View {
        VStack {
            Spacer()
            Divider()
            VStack {
                Text("An error occured: \(error)")
                Image(systemName: "icloud.slash")
            }
            Divider()
            Spacer()
            
        }
    }
    init(_ error: String) {
        self.error = error
    }
}

#Preview {
    ErrorView("error example")
}
