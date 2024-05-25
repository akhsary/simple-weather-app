//
//  AddCityView.swift
//  SimpleWeather
//
//  Created by Юрий Чекан on 23.05.2024.
//

import SwiftUI

struct AddCityView: View {
    @Environment (WeatherViewModel.self) var weatherManager
    
    @Binding var isActive: Bool
    
    @FocusState private var focused: Bool
    @State var name = ""
    @State private var isPresented = false
    
    var body: some View {
            List {
                HStack {
                    TextField(text: $name) {
                        Text("Enter the name of the city...")
                    }
                    .onSubmit {
                        Task {
                            do {
                                try await weatherManager.loadWeatherForCityName(name)
                                if weatherManager.userCityError != nil {
                                    isPresented = true
                                } else {
                                    isActive = false
                                }
                            } catch {
                                weatherManager.userCityError = error.localizedDescription
                            }
                        }
                    }
                    .focused(self.$focused)
                    .onAppear {
                        self.focused = true
                    }
                    .alert("Fail", isPresented: $isPresented) {
                        Button("Try again", role: .cancel){
                            self.focused = true
                            weatherManager.userCityError = nil
                        }
                        Button("Dismiss") {
                            weatherManager.userCityError = nil
                            isPresented = false
                            isActive = false
                        }
                    } message: {
                        Text("Added city failed. Try again")
                    }
                    .padding()
                    
                    Button("Cancel"){
                        weatherManager.userCityError = nil
                        isActive = false
                    }
                }
            }

    }
}

#Preview {
    AddCityView(isActive: .constant(true))
        .environment(previewWeatherViewModel)
}
