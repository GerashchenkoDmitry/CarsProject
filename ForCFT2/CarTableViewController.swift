//
//  ViewController.swift
//  ForCFT2
//
//  Created by Дмитрий Геращенко on 25.09.2020.
//  Copyright © 2020 Дмитрий Геращенко. All rights reserved.
//

import UIKit
import os.log

class CarTableViewController: UITableViewController {
    
    var cars = [Car]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Cars"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.leftBarButtonItem = editButtonItem
        
        let savedCars = loadCars()
        
        if savedCars?.count ?? 0 > 0 {
            cars = savedCars ?? [Car]()
        } else {
            loadSampleData()
        }
    }
    
    //MARK: Table view data source
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            cars.remove(at: indexPath.row)
            saveCars()
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            
        }
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        true
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        cars.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Car", for: indexPath) as? CarTableViewCell else {  fatalError("The dequeving cell in not an instance of CarTableViewCell") }
        let car = cars[indexPath.row]
        cell.carImage.image = car.image
        cell.manufacturerLabel.text = "Manufacturer: \(car.manufacturer)"
        cell.modelLabel.text = "Model: \(car.model)"
        cell.yearLabel.text = "Year: \(String(car.year))"
        return cell
    }
    
    //MARK: Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        switch segue.identifier {
            case "AddCar":
                os_log("Adding a new car.", log: OSLog.default, type: .debug)
            case "ShowDetail":
                
            guard let carDetailViewController = segue.destination as? DetailViewController else {
                fatalError("Unexpected segue destination \(segue.destination).")
            }
                
            guard let selectedCarCell = sender as? CarTableViewCell else {
                fatalError("Unexpected sender: \(sender ?? "").")
            }
            
            guard let indexPath = tableView.indexPath(for: selectedCarCell) else {
                fatalError("the selected cell is not being displayed by the table.")
                }
            
            let selectedCar = cars[indexPath.row]
            carDetailViewController.selectedCar = selectedCar
            
            default:
                fatalError("Unexpected segue Identifier: \(segue.identifier ?? "").")
            }
    }
    
    //MARK: Actions
    
    @IBAction func unwindToCarsList(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.source as? NewCarViewController, let car = sourceViewController.car {
            
            let newIndexPath = IndexPath(row: cars.count, section: 0)
            cars.append(car)
            tableView.insertRows(at: [newIndexPath], with: .automatic)
        } else if let sourceViewController = sender.source as? EditCarViewController, let car = sourceViewController.editingCar {
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                cars[selectedIndexPath.row] = car
                tableView.reloadRows(at: [selectedIndexPath], with: .none)
            }
        }
        saveCars()
    }
        
    private func loadSampleData() {
        
        let photo1 = UIImage(named: "toyota")
        let photo2 = UIImage(named: "honda")
        let photo3 = UIImage(named: "isuzu")
        
        guard let car1 = Car(image: photo1, manufacturer: "Toyota", model: "FJCruiser", bodyType: "truck", year: "2008") else { fatalError("Unable to create car1")}
        guard let car2 = Car(image: photo2, manufacturer: "Honda", model: "Civic", bodyType: "hatch", year: "1987") else { fatalError("Unable to create car2")}
        guard let car3 = Car(image: photo3, manufacturer: "Isuzu", model: "Vehicross", bodyType: "SUV", year: "2003") else { fatalError("Unable to create car3")}
       
        cars += [car1, car2, car3]
        print(cars.count)
    }
    
    private func saveCars() {
        let fullPath = getDocumentsDirectory().appendingPathComponent("cars")

            do {
                let data = try NSKeyedArchiver.archivedData(withRootObject: cars, requiringSecureCoding: false)
                try data.write(to: fullPath)
                os_log("Cars successfully saved.", log: OSLog.default, type: .debug)
            } catch {
                os_log("Failed to save cars...", log: OSLog.default, type: .error)
            }
        }

        func getDocumentsDirectory() -> URL {
            let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
            return paths[0]
        }

        private func loadCars() -> [Car]? {
            let fullPath = getDocumentsDirectory().appendingPathComponent("cars")
            if let nsData = NSData(contentsOf: fullPath) {
                do {

                    let data = Data(referencing:nsData)

                    if let loadedCars = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? Array<Car> {
                        return loadedCars
                    }
                } catch {
                    print("Couldn't read file.")
                    return nil
                }
            }
        return nil
    }

}

