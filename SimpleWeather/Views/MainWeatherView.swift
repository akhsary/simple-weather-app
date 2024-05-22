//
//  MainWeatherView.swift
//  SimpleWeather
//
//  Created by Юрий on 10.05.2024.
//

import SwiftUI

struct MainWeatherView: View {
    @State var isPresented = false
    @State private var counter = true
    
    @Environment(WeatherViewModel.self) var weatherManager
    
    var body: some View {
        if let weather = weatherManager.userWeather {
            ZStack(alignment: .leading) {
                VStack {
                    VStack(alignment: .leading, spacing: 5) {
                        HStack {
                            Text(weather.name)
                                .bold()
                                .font(.title)
                            
                            Button {
                                if counter {
                                    weatherManager.defaultCitiesArray.insert(weather, at: 0)
                                    counter = false
                                }
                                isPresented.toggle()
                            } label: {
                                Text("Another City?")
                            }
                            .foregroundStyle(.white)
                        }
                        .sheet(isPresented: $isPresented) {
                            WeatherRow(isPresented: $isPresented)
                                .environment(weatherManager)
                                .preferredColorScheme(.light)
                        }
                        
                        Text("Today, \(Date().formatted(.dateTime.month().day().hour().minute()))")
                            .fontWeight(.light)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                    VStack {
                        HStack {
                            Text(weather.main.feelsLike.roundDouble() + "°")
                                .font(.system(size: 90))
                                .fontWeight(.bold)
                                .padding()
                                .frame(width: 200, alignment: .leading)
                            
                            Spacer()
                            
                            VStack(spacing: 20) {
                                if weather.weather[0].main == "Clouds"
                                {
                                    Image(systemName: "cloud.sun")
                                        .font(.system(size: 40))
                                } else if weather.weather[0].main == "Clear" {
                                    Image(systemName: "sun.max")
                                        .font(.system(size: 40))
                                } else if weather.weather[0].main == "Rain" {
                                    Image(systemName: "cloud.rain")
                                        .font(.system(size: 40))
                                } else {
                                    Image(systemName: "cloud")
                                        .font(.system(size: 40))
                                }
                                
                                Text(weather.weather[0].main)
                            }
                            .frame(width: 80, alignment: .leading)
                        }
                        .padding(.leading, -10)
                        
                        Spacer()
                            .frame(height:  20)
                        
                        //MapView(locationInvalid: weather.coord)
                        Image("town")
                            .resizable()
                        //.frame(height: 300)
                            .clipShape(Circle())
                            .overlay {
                                Circle().stroke(.blue, lineWidth: 4)
                            }
                            .shadow(radius: 7)
                            .frame(width: 300, height: 300)
                        
                        Spacer()
                    }
                    .frame(maxWidth: .infinity, alignment: .trailing)
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                
                VStack {
                    Spacer()
                    VStack(alignment: .leading, spacing: 20) {
                        Text("Weather now")
                            .bold()
                            .padding(.bottom)
                        
                        HStack {
                            WeatherItemRow(logo: "thermometer.low", name: "Min temp", value: (weather.main.tempMin.roundDouble() + "°"))
                            Spacer()
                                .frame(width: 75)
                            
                            WeatherItemRow(logo: "thermometer.high", name: "Max temp", value: (weather.main.tempMax.roundDouble() + "°"))
                        }
                        
                        HStack {
                            WeatherItemRow(logo: "wind", name: "Wind speed", value: (weather.wind.speed.roundDouble() + "m/s"))
                            Spacer()
                                .frame(width: 60)
                            
                            WeatherItemRow(logo: "humidity", name: "Humidity", value: "\(weather.main.humidity)%")
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                    .padding(.bottom, 20)
                    .foregroundColor(Color(.black))
                    .background(.white)
                    .cornerRadius(20)
                }
                
            }
            .edgesIgnoringSafeArea(.bottom)
            .background(Color(.blue))
            .preferredColorScheme(.dark)
        }
    }
}
#Preview {
    MainWeatherView()
        .environment(previewWeatherViewModel)
}

