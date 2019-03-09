//
//  WeatherTableViewController.swift
//  URLComponents
//
//  Created by Hameed Abdullah on 3/9/19.
//  Copyright © 2019 Hameed Abdullah. All rights reserved.
//

import UIKit

class WeatherTableViewController: UITableViewController {

    var days: [Day] = [Day]()
    
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
                
                
             
                
                let week: [[String: Any]] = dictionary["list"] as! [[String: Any]];
                
                for day in week {   //day is a [String: Any]
                    //dt = 1552150800 seconds senice 1970
                    let dt: Int = day["dt"] as! Int;
                    let date: Date = Date(timeIntervalSince1970: TimeInterval(dt));
                   // let dateString = formatter.string(from: date);
                    let temp: [String: NSNumber] = day["temp"] as! [String: NSNumber];
                    
                    //NSNumber to get in norml number
                    let max: NSNumber = temp["max"]!;
                    
                    //print("\(dateString) \(max.floatValue)° F");
                    
                    self.days.append(Day(date: date, max:max.floatValue))
                }
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                
            }
        }
        
        task.resume();
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return days.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "weatherCell", for: indexPath)

        // Configure the cell...
        let formatter: DateFormatter = DateFormatter();
        formatter.dateStyle = DateFormatter.Style.long;
        
    
        let day: Day = days[indexPath.row]
        cell.textLabel?.text = formatter.string(from: day.date)
        cell.detailTextLabel?.text = "\(day.max) ° F"

        return cell
    }
 

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

