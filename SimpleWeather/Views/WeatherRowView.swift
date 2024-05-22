//
//  WetherRowView.swift
//  SimpleWeather
//
//  Created by Юрий on 13.05.2024.
//

import SwiftUI
struct WeatherRow: View {
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
                    if searchResults.isEmpty {
                        ForEach(weatherManager.defaultCitiesArray){ weather in
                            arrayView(weather: weather)
                        }
                    } else {
                        ForEach(searchResults){ weather in
                            arrayView(weather: weather)
                        }
                    }
                }
                .navigationTitle("Choose your City")
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button("Dismiss"){
                            self.isPresented = false
                        }
                        .padding()
                        .foregroundStyle(.black)
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
            
    }
}

#Preview {
    WeatherRow(isPresented: .constant(true))
        .environment(previewWeatherViewModel)
}
