//
//  WeatherModel.swift
//  WWAPI
//
//  Created by Sara Sd on 03/02/1445 AH.
//

import Foundation
import SwiftUI

struct WeatherData: Codable {
    var main: Main
    var weather: [Weather]
    var wind: Wind
    
}

struct Main: Codable {
    var temp: Double
    var humidity: Int
    var pressure: Int
}

struct Weather: Codable {
    var main: String
    var description: String
    var icon: String
    var id: Int
    
}
struct Wind: Codable {
    var speed: Double
    
}

struct BackgroundView: View {
    var top:Color
    var bottom:Color
    var body: some View {
        LinearGradient(colors: [top,bottom], startPoint: .topLeading, endPoint: .bottomTrailing)
            .edgesIgnoringSafeArea(.all)
    }
}

struct WeatherDayView: View {
    var dayofWeek: String
    var imageName: String
    
    var body: some View {
        VStack {
            Text(dayofWeek)
                .font(.system(size: 16, weight: .medium, design: .default))
                .foregroundColor(.white)
            
            Image(systemName: imageName).renderingMode(.original).resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 40, height: 40)
                .foregroundColor(.white)
        }
    }
}

struct MainWeather: View {
    var image: String
    var temp: String
    
    var body: some View {
        VStack(spacing: 8){
            Image(image).renderingMode(.original).resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 180, height: 180)
            
            Text("\(temp)")
                .font(.system(size: 70, weight: .medium))
                .foregroundColor(.white)
        }
    }
}


