import SwiftUI

struct AddCityView: View {
    @Environment(WeatherViewModel.self) var weatherManager
    
    @Binding var isActive: Bool
    
    @FocusState private var focused: Bool
    @State var name = ""
    @State private var isPresented = false
    
    var body: some View {
        List {
            HStack {
                TextField("Enter the name of the city...", text: $name)
                    .onSubmit {
                        Task {
                            await addCity()
                        }
                    }
                    .focused($focused)
                    .onAppear {
                        focused = true
                    }
                    .alert("Error", isPresented: $isPresented) {
                        Button("Try again", role: .cancel) {
                            focused = true
                            weatherManager.userCityError = nil
                        }
                        Button("Dismiss") {
                            weatherManager.userCityError = nil
                            isPresented = false
                            isActive = false
                        }
                    } message: {
                        Text(weatherManager.userCityError ?? "Unknown error")
                    }
                    .padding()
                
                Button("Cancel") {
                    weatherManager.userCityError = nil
                    isActive = false
                }
            }
        }
    }
    
    private func addCity() async {
        await weatherManager.addCity(name)
        if weatherManager.userCityError != nil {
            isPresented = true
        } else {
            isActive = false
        }
    }
}

#Preview {
    AddCityView(isActive: .constant(true))
        .environment(previewWeatherViewModel)
}
