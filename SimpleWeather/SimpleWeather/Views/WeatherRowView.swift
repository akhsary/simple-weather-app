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
                        ForEach(weatherManager.defaultCitiesArray){ item in
                            arrayView(weather: item)
                        }.onDelete { index in
                            delete(at: index)
                        }
                    }
                    else {
                        ForEach(searchResults){ item in
                            arrayView(weather: item)
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

extension WeatherRow {
    func delete(at indexSet: IndexSet) {
                weatherManager.defaultCitiesArray.remove(atOffsets: indexSet)
                weatherManager.defaultNamesArray.remove(atOffsets: indexSet)
        }
}

#Preview {
    WeatherRow(isPresented: .constant(true))
        .environment(previewWeatherViewModel)
}
