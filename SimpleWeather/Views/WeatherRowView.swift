//
//  WetherRowView.swift
//  SimpleWeather
//
//  Created by Юрий on 13.05.2024.
//

import SwiftUI
struct WeatherRow: View {
    //Add new
    @State var isActive = false
    
    // Search
    @State var searchResults: [ResponseBody] = []
    @State var searchQuery: String = ""
    var isSearching: Bool {
        return !searchQuery.isEmpty
    }
    //-------------------------
    @Binding var isPresented: Bool
    @Environment(WeatherViewModel.self) var weatherManager
    
    var body: some View {
            NavigationStack {
                
                List {
                    
                    if searchResults.isEmpty && searchQuery == "" {
                        ForEach(weatherManager.defaultCitiesArray){ weather in
                            arrayView(weather: weather)
                        }
                    } else {
                        ForEach(searchResults){ weather in
                            arrayView(weather: weather)
                        }
                    }
                }
                .navigationTitle("Choose your city")
                .toolbar {
                    
                    ToolbarItem(placement: .topBarLeading) {
                        Button("+"){
                                isActive = true
                        }
                        .padding()
                        .font(.title)
                    }
                    
                    
                    ToolbarItem(placement: .topBarTrailing) {
                        Button("Dismiss"){
                            self.isPresented = false
                        }
                        .padding()
                    }
                }
            }
            .searchable(
                text: $searchQuery,
                placement: .navigationBarDrawer(displayMode: .always),
                prompt: "Search..."
            )
            .textInputAutocapitalization(.words)
            .onChange(of: searchQuery) {
                self.fetchSearchResults(for: searchQuery)
            }
            .overlay {
                if searchResults.isEmpty && searchQuery != "" {
                    ContentUnavailableView.search(text: searchQuery)
                }
            }
            .overlay {
                if isActive == true {
                    AddCityView(isActive: $isActive)
                        .environment(weatherManager)
                }
            }
            
    }
}

#Preview {
    WeatherRow(isPresented: .constant(true))
        .environment(previewWeatherViewModel)
}
