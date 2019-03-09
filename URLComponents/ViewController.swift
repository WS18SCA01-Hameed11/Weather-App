//
//  ViewController.swift
//  URLComponents
//
//  Created by Hameed Abdullah on 3/9/19.
//  Copyright © 2019 Hameed Abdullah. All rights reserved.
//

import UIKit

//Modify a URL with URLComponents, pp. 843–845
class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let string: String = "https://api.nasa.gov/planetary/apod";
        
        guard let baseURL: URL = URL(string: string) else {
            fatalError("could not create URL from string \"\(string)\"");
        }
        print("baseURL = \(baseURL)");
        
        let query: [String: String] = [
            "api_key": "DEMO_KEY",
            "date":    "2019-03-01"
        ];
        
        
        //withQueries takes dictionary
        guard let url: URL = baseURL.withQueries(query) else {
            fatalError("could not add queries to base URL");
        }
        print("    url = \(url)");
        
        let task: URLSessionDataTask = URLSession.shared.dataTask(with: url) {(data: Data?, response: URLResponse?, error: Error?) in
            
            if let error: Error = error {
                print("error = \(error)");
            }
            
            if let data: Data = data {
                let dictionary: [String: Any];
                do {
                    try dictionary = JSONSerialization.jsonObject(with: data) as! [String: Any];
                } catch {
                    fatalError("could not create dictionary: \(error)");
                }
                
                print("The \(dictionary.count) items in the dictionary:");
                dictionary.forEach {print("\t\($0.key): \($0.value)");}
            }
        }
        
        task.resume();
    }


}


//2   - advanced json
//Openweathermap
//https://openweathermap.org/
class ViewController2: UIViewController {
    
    var dates: [Day] = [Day]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let string: String = "http://api.openweathermap.org/data/2.5/forecast/daily";
        
        guard let baseURL: URL = URL(string: string) else {
            fatalError("could not create URL from string \"\(string)\"");
        }
        print("baseURL = \(baseURL)");
        
        let query: [String: String] = [
            "q": "10028,US",     //New York City
            "cnt": "7",          //number of days
            "units": "imperial", //fahrenheit, not celsius
            "mode": "json",      //vs. xml or html
            "APPID": "532d313d6a9ec4ea93eb89696983e369"
        ];
        
        
        //withQueries takes dictionary
        guard let url: URL = baseURL.withQueries(query) else {
            fatalError("could not add queries to base URL");
        }
        print("    url = \(url)");
        
        let task: URLSessionDataTask = URLSession.shared.dataTask(with: url) {(data: Data?, response: URLResponse?, error: Error?) in
            
            if let error: Error = error {
                print("error = \(error)");
            }
            
            if let data: Data = data {
                let dictionary: [String: Any];
                do {
                    try dictionary = JSONSerialization.jsonObject(with: data) as! [String: Any];
                } catch {
                    fatalError("could not create dictionary: \(error)");
                }
                
                print("dictionary.count \(dictionary.count)")
                dictionary.forEach {print("\t\($0.key): \($0.value)");}
                
                
                let formatter: DateFormatter = DateFormatter();
                formatter.dateStyle = DateFormatter.Style.long;
                
                let week: [[String: Any]] = dictionary["list"] as! [[String: Any]];
                
                for day in week {   //day is a [String: Any]
                    //dt = 1552150800 seconds senice 1970
                    let dt: Int = day["dt"] as! Int;
                    let date: Date = Date(timeIntervalSince1970: TimeInterval(dt));
                    let dateString = formatter.string(from: date);
                    let temp: [String: NSNumber] = day["temp"] as! [String: NSNumber];
                    
                    //NSNumber to get in norml number
                    let max: NSNumber = temp["max"]!;
                    
                    print("\(dateString) \(max.floatValue)° F");
                    
                }
            }
        }
        
        task.resume();
    }
    
    
}

extension URL {
    func withQueries(_ queries: [String: String]) -> URL? {
        
        //self url itself
        guard var components: URLComponents = URLComponents(url: self, resolvingAgainstBaseURL: true) else {
            fatalError("could not create URLComponents for URL \(self)");
        }
        components.queryItems = queries.map {URLQueryItem(name: $0.key, value: $0.value)}
        return components.url;
    }
}


// call tableView.reload call inside a main thread
