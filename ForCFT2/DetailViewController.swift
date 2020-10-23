//
//  DetailViewController.swift
//  ForCFT2
//
//  Created by Дмитрий Геращенко on 26.09.2020.
//  Copyright © 2020 Дмитрий Геращенко. All rights reserved.
//

import UIKit
import os.log

class DetailViewController: UIViewController {
    
    var selectedCar: Car?
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var manufacturerLabel: UILabel!
    @IBOutlet weak var modelLabel: UILabel!
    @IBOutlet weak var bodyTypeLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    
    @IBOutlet weak var editButton: UIBarButtonItem!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let car = selectedCar {
            navigationItem.title = "\(car.manufacturer) \(car.model)"
            imageView.image = car.image
            manufacturerLabel.text = "Manufacturer: \(car.manufacturer)"
            modelLabel.text = "Model: \(car.model)"
            bodyTypeLabel.text = "Body type: \(car.bodyType)"
            yearLabel.text = "Year: \(car.year)"
        }
        navigationItem.largeTitleDisplayMode = .never
    }
    
    
    // MARK: - Navigation
     
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        if segue.destination is EditCarViewController {
            let editCarVC = segue.destination as? EditCarViewController
            editCarVC?.editingCar = selectedCar
        }
    }
    
    @IBAction func editCarButtonTapped(_ sender: UIBarButtonItem) {
        
//        performSegue(withIdentifier: "Edit Car", sender: sender)
//        let editCarVC = EditCarViewController()
//        editCarVC.editingCar = selectedCar
        
    }
    

}
