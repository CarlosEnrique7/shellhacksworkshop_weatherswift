//
//  ViewController.swift
//  shellhacksworkshopswift
//
//  Created by Carlos Chavez on 9/8/22.
//

import UIKit

class ViewController: UIViewController {
    // get your API key and insert it here. You can get a free one at: https://home.openweathermap.org/users/sign_up
    let APIKEY = "ENTER_YOUR_API_KEY_HERE"
    var icon = ""
    var cityName = "Miami"
    var weather = [[String:Any]]()
    
    @IBOutlet weak var desc: UILabel!
    @IBOutlet weak var weatherImage: UIImageView!
    @IBOutlet weak var citySearch: UITextField!
    @IBOutlet weak var nameOfCity: UILabel!
    @IBOutlet weak var temp: UILabel!
    @IBOutlet weak var low: UILabel!
    @IBOutlet weak var high: UILabel!
    
    
    override func viewWillAppear(_ animated: Bool) {
        // connecting to our API
        APICall()
        
    }
    
    func APICall() {
        // This is the GET request to fetch from our weather API
        let url = URL(string: "https://api.openweathermap.org/data/2.5/weather?q=\(cityName.replacingOccurrences(of: " ", with: "+"))&appid=\(APIKEY)&units=imperial")!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: request) { (data, response, error) in
             // This will run when the network request returns
             if let error = error {
                    print(error.localizedDescription)
             } else if let data = data {
                    let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! NSDictionary
                 
                 // print the json response dictionary
                 print(dataDictionary)
                 
                 // Below here we actually get the relevant data and attach it to our outlets
                    
                 // Get the array of the weather data we want to parse
                 let weatherData = dataDictionary["weather"] as! [[String:Any]]
                 // set the outlet data for the items in this object
                 self.desc.text = weatherData[0]["description"] as? String
                 self.icon = (weatherData[0]["icon"] as? String)!
                    
                 // Get the array of the main weather data we want to parse
                 self.weatherImage.image = UIImage(named: self.icon)
                 let mainData = dataDictionary["main"] as? [String:Any]
                 
                 // formatter will be used to get rid of decimals from the weather data
                 let formatter = NumberFormatter()
                 formatter.minimumFractionDigits = 0
                 formatter.maximumFractionDigits = 0

                 // set the outlet data for temperature from the relevant object
                 self.temp.text = String(describing: formatter.string(from: mainData!["temp"] as! NSNumber)! + "°")
                 self.low.text = String(describing: formatter.string(from: mainData!["temp_min"] as! NSNumber)! + "°")
                 self.high.text = String(describing: formatter.string(from: mainData!["temp_max"] as! NSNumber)! + "°")
             }
        }
        task.resume()
    }
    

    @IBAction func searchNewCity(_ sender: Any) {
        // change the name of the city and the cityName var before making a new API request
        cityName = citySearch.text!.lowercased()
        nameOfCity.text = citySearch.text!.capitalized
        // make the new API request
        APICall()
    }
}

