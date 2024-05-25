//
//  WeatherRowView+Extentions.swift
//  SimpleWeather
//
//  Created by Юрий Чекан on 19.05.2024.
//
import SwiftUI

 extension WeatherRow {
     func fetchSearchResults(for query: String) {
        searchResults = weatherManager.defaultCitiesArray.filter { city in
            city.name
                .capitalized(with: nil)
                .contains(searchQuery)
        }
    }
    struct TextFieldModifier: ViewModifier {
        func body(content: Content) -> some View {
            content
                .overlay(RoundedRectangle(cornerRadius: 8).stroke(.black))
                .textFieldStyle(.roundedBorder)
                .padding()
                .submitLabel(.search)
        }
    }
    
    func arrayView(weather: ResponseBody) -> some View {
        Button {
            weatherManager.userWeather = weather
            isPresented = false
        } label: {
            HStack {
                Text(weather.name)
                    .font(.title)
                
                Spacer()
                
                Text("\(weather.weather[0].main)")
                
                Text(weather.main.feelsLike.roundDouble() + "°")
                    .font(.body)
                
            }
            .foregroundStyle(.black)
        }
    }
}
