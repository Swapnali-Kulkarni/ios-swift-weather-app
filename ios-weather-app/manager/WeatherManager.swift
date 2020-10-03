//
//  WeatherManager.swift
//  ios-weather-app
//
//  Created by Swapnali Kulkarni on 21/09/20.
//  Copyright © 2020 Swapnali Kulkarni. All rights reserved.
//

import Foundation
import Alamofire

enum WeatherError: Error, LocalizedError {
    
    case unknown
    case invalidCity
    case custom(description: String)
    
    var errorDescription: String?{
        switch self {
        case .unknown:
            return "Hey, This is an unknown error!"
        case .invalidCity:
            return "Hey, This is invalid city Please try again!"
        case .custom(description: let description):
            return description
        }
    }
}

struct WeatherManager {
    
    private let API_KEY = "8f3020af99d7271e095ad217874b72b9"
    
    //api.openweathermap.org/data/2.5/weather?lat={lat}&lon={lon}&appid={API key}
    
    func fetchWeather(lat: Double, lon: Double, completion: @escaping (Result<WeatherModel, Error>) -> Void) {
        
        let path = "https://api.openweathermap.org/data/2.5/weather?lat=%f&lon=%f&appid=%@&units=metric?"
        let urlString = String(format:  path, lat, lon, API_KEY)
        handleReust(urlString: urlString, completion: completion)
    }
    
    func fetchWeather(byCity city: String, completion: @escaping (Result<WeatherModel, Error>) -> Void) {
           
           let query = city.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? city
           let path = "https://api.openweathermap.org/data/2.5/weather?q=%@&appid=%@&units=metric"
           let urlString = String(format:  path, query, API_KEY)
           handleReust(urlString: urlString, completion: completion)
    }
    
    private func handleReust(urlString:String, completion: @escaping (Result<WeatherModel, Error>) -> Void){
        
        AF.request(urlString).validate().responseDecodable(of: WeatherData.self, queue: .main ,decoder:JSONDecoder())
        {(response)in
            
            switch response.result{
            case .success(let weatherData):
                let model = weatherData.model
                completion(.success(model ))
                
            case .failure(let error):
                
                if let err = self.getWeatherError(error: error, data: response.data){
                    completion(.failure(err))
                }else{
                    completion(.failure(error))
                }
                
            }
        }
    }
    private func getWeatherError(error: AFError, data: Data?) -> Error? {
        
        if error.responseCode == 404,
            let data = data,
            let failure = try?JSONDecoder().decode(weatherDataFailure.self, from: data){
            let message = failure.message
            return WeatherError.custom(description: message)
        }else{
            return nil
        }
    }
}
