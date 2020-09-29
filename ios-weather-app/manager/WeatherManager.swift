//
//  WeatherManager.swift
//  ios-weather-app
//
//  Created by Swapnali Kulkarni on 21/09/20.
//  Copyright © 2020 Swapnali Kulkarni. All rights reserved.
//

import Foundation
import Alamofire

struct WeatherManager {
    
    private let API_KEY = "8f3020af99d7271e095ad217874b72b9"
    
    func fetchWeather(byCity city: String, completion: @escaping (Result<WeatherModel, Error>) -> Void) {
        
        let query = city.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? city
        let path = "https://api.openweathermap.org/data/2.5/weather?q=%@&appid=%@&units=metric"
        let urlString = String(format:  path, query, API_KEY)
        
        AF.request(urlString).responseDecodable(of: WeatherData.self, queue: .main ,decoder:JSONDecoder())
        {(response)in 
            
            switch response.result{
            case .success(let weatherData):
                let model = weatherData.model
                completion(.success(model ))
                
            case .failure(let error): 
                completion(.failure(error))
            }
        }
    }
}
