//
//  ContentView.swift
//  WWAPI
//
//  Created by Sara Sd on 03/02/1445 AH.
//

import SwiftUI
import MapKit
import CoreLocation


struct ContentView: View {
    @State private var isNight = false
    
    @Environment(\.managedObjectContext) var viewContext
    @FetchRequest(sortDescriptors: [], animation: .default) var myCoreDataWeather: FetchedResults <WeatherDB>
    
    @StateObject var locationManager = LocationManager()
    @StateObject var weatheViewModel = WeatheViewModel()
    var body: some View {
        
        ZStack {
            BackgroundView(top: isNight ? .black:.blue, bottom: isNight ? .gray:.white)
            ScrollView {
                HStack(spacing: 20) {
                    WeatherDayView(dayofWeek: "TUE", imageName: isNight ? "moon.stars.fill": "cloud.sun.fill")
                    WeatherDayView(dayofWeek: "WED", imageName: isNight ? "cloud.moon.rain.fill": "sun.max.fill")
                    WeatherDayView(dayofWeek: "THU", imageName: isNight ? "sparkles": "cloud.sun.fill")
                    WeatherDayView(dayofWeek:"FRI", imageName: "cloud.sun.fill")
                    WeatherDayView(dayofWeek: "SAT", imageName: isNight ? "cloud.heavyrain.fill": "cloud.sun.fill")
                }
                VStack {
                    TextField("Enter city name", text: $weatheViewModel.cityName)
                        .padding()
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .disableAutocorrection(true)
                    Picker("Unit Selection", selection: $weatheViewModel.unitSelection) {
                        Text("C").tag(0)
                        Text("F").tag(1)
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding()
                    
                    Button(action: {
                        weatheViewModel.fetchWeatherData()
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            let weatherDB = WeatherDB(context: viewContext)
                            weatherDB.cityName  = weatheViewModel.cityName
                            weatherDB.speed     = weatheViewModel.weatherData?.wind.speed ?? 0.0
                            weatherDB.pressure  = Int16(weatheViewModel.weatherData?.main.pressure ?? 0)
                            weatherDB.icon      = weatheViewModel.weatherData?.weather.first?.icon
                            weatherDB.temp      = weatheViewModel.weatherData?.main.temp ?? 0.0
                            weatherDB.humidity  = Int16(weatheViewModel.weatherData?.main.humidity ?? 0)
                            weatherDB.descrip   = weatheViewModel.weatherData?.weather.first?.description
                            weatherDB.weatherId = Int16(weatheViewModel.weatherData?.weather.first?.id ?? 0)
                            
                            do {
                                try viewContext.save()
                                print("Saved object is \(weatherDB)")
                                weatheViewModel.cityName = ""
                            } catch {
                                
                            }
                        }
                        
                        
                    }) {
                        Text("Get Weather")
                            .padding()
                            .frame(width: 300, height: 50)
                            .foregroundColor(.blue)
                            .background(Color.white)
                            .cornerRadius(10)
                    }
                    Button {
                        locationManager.requestLocation()
                        weatheViewModel.fetchWeatherByLocation(locationManager: locationManager)
                        
                    } label: {
                        Label("Get Weather By Location", systemImage: "location")
                            .foregroundColor(.white)
                    }
                    
                    Spacer()
                    
                    Group{
                        Image(systemName: weatheViewModel.displayWeatherIcon(id: weatheViewModel.weatherData?.weather[0].id ?? 0 ))
                            .resizable()
                            .frame(width: 100, height: 100)
                        Text("Temperature: \(weatheViewModel.weatherData?.main.temp ?? 0.0, specifier: "%.1f") \(weatheViewModel.unitSelection == 0 ? "°C" : "°F")")
                        Text("Description: \(weatheViewModel.weatherData?.weather.first?.description ?? "")")
                        Text("Humidty\(weatheViewModel.weatherData?.main.humidity ?? 0)")
                        Text("Pressure\(weatheViewModel.weatherData?.main.pressure ?? 0 )")
                        Text("Wind Speed\(weatheViewModel.weatherData?.wind.speed ?? 0)")
                    }
                    
                    if let error =  weatheViewModel.error {
                        Text(error)
                            .foregroundColor(.red)
                    }
                    Spacer()
                    Text("Your Search History")
                        .foregroundColor(.white)
                        .bold()
                        .font(.largeTitle)
                        .frame(maxWidth:.infinity, alignment:.center)
                    
                    ForEach(myCoreDataWeather) { cityName in
                        HStack{
                            Button {
                                withAnimation {
                                    weatheViewModel.weatherData?.wind.speed             = cityName.speed
                                    weatheViewModel.weatherData?.main.pressure          = Int(cityName.pressure)
                                    weatheViewModel.weatherData?.weather[0].icon        = cityName.icon ?? ""
                                    weatheViewModel.weatherData?.main.temp              = cityName.temp
                                    weatheViewModel.weatherData?.main.humidity          = Int(cityName.humidity)
                                    weatheViewModel.weatherData?.weather[0].description = cityName.descrip ?? ""
                                    weatheViewModel.weatherData?.weather[0].id          = Int(cityName.weatherId)
                                }
                                
                            } label: {
                                HStack{
                                    Text(cityName.cityName ?? "")
                                    Spacer()
                                    Image(systemName: "doc.on.clipboard")
                                }.foregroundColor(.blue)
                            }
                            
                            Button {
                                do {
                                    viewContext.delete(cityName)
                                    try viewContext.save()
                                } catch {
                                    
                                }
                            } label: {
                                Image(systemName: "trash")
                            }.tint(.red)
                        }
                        .padding(8)
                        .background(Color.white.cornerRadius(5))
                        .padding(.horizontal, 20)
                        
                    }
                }
            }
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environment(\.managedObjectContext, CoreDataManager.shared.container.viewContext)
    }
}

