//
//  ViewController.swift
//  ios-weather-app
//
//  Created by Swapnali Kulkarni on 21/09/20.
//  Copyright © 2020 Swapnali Kulkarni. All rights reserved.
//

import UIKit
import SkeletonView

protocol WeatherViewControllerDelegate: class {
    func didUpdateWeatherFromSearch(model: WeatherModel)
}


class WeatherViewController: UIViewController {

    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var conditionLabel: UILabel!
    private let weatherManager = WeatherManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showAnimation()
        fetchWeather()
    }

    private func fetchWeather() {
        
        weatherManager.fetchWeather(byCity: "Mumbai") { [weak self](result) in
            guard let this = self else { return }
            switch(result){
            case .success(let model):
                this.updateView(with: model)
            case .failure(let error):
                print("Error: \(error.localizedDescription)")
            }
        }
    }
    
    private func updateView(with model:  WeatherModel){
        
        conditionImageView.hideSkeleton()
        temperatureLabel.hideSkeleton()
        conditionLabel.hideSkeleton()
        
        temperatureLabel.text = model.temp.toString().appending("°C")
        conditionLabel.text = model.conditionDescription
        navigationItem.title = model.countryName
        conditionImageView.image = UIImage(named: model.conditionImage)
    }
    
    private func showAnimation() {
        conditionImageView.showAnimatedGradientSkeleton()
        temperatureLabel.showAnimatedGradientSkeleton()
        conditionLabel.showAnimatedGradientSkeleton()
        
    }
    
    @IBAction func addCityButtonTapped(_ sender: Any) {
        performSegue(withIdentifier: "showAddCity", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showAddCity"{
            if let destination = segue.destination as? AddCityViewController{
                destination.delegate = self
            }
        }
    }
    
    @IBAction func locationButtonTapped(_ sender: Any) {
    }
}

extension WeatherViewController: WeatherViewControllerDelegate {
    func didUpdateWeatherFromSearch(model: WeatherModel) {
        presentedViewController?.dismiss(animated: true, completion: { [weak self] in
            guard let this = self else { return }
            this.updateView(with: model)
        })
    }
}
