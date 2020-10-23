//
//  Car.swift
//  ForCFT2
//
//  Created by Дмитрий Геращенко on 26.09.2020.
//  Copyright © 2020 Дмитрий Геращенко. All rights reserved.
//

import UIKit
import os.log

class Car: NSObject, NSCoding {
    
    
    var image: UIImage?
    var manufacturer: String
    var model: String
    var bodyType: String
    var year: String
    
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("cars")
    
    struct PropertyKey {
        static let image = "image"
        static let manufacturer = "manufacturer"
        static let model = "model"
        static let bodyType = "bodyType"
        static let year = "year"
    }
    
    init?(image: UIImage?, manufacturer: String, model: String, bodyType: String, year: String) {
    
        guard !manufacturer.isEmpty || !model.isEmpty || !bodyType.isEmpty || (!year.isEmpty && (Int(year) != nil)) else {
            fatalError("Unable to create object!")
        }
            
        self.image = image
        self.manufacturer = manufacturer
        self.model = model
        self.bodyType = bodyType
        self.year = year
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(image, forKey: PropertyKey.image)
        aCoder.encode(manufacturer, forKey: PropertyKey.manufacturer)
        aCoder.encode(model, forKey: PropertyKey.model)
        aCoder.encode(bodyType, forKey: PropertyKey.bodyType)
        aCoder.encode(year, forKey: PropertyKey.year)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        
        guard let manufacturer = aDecoder.decodeObject(forKey: PropertyKey.manufacturer) as? String else {
            os_log("Unable to decode the manufacturer for a Car object.", log: OSLog.default, type: .debug)
            return nil
        }
        
        guard let model = aDecoder.decodeObject(forKey: PropertyKey.model) as? String else {
            os_log("Unable to decode the model for a Car object.", log: OSLog.default, type: .debug)
            return nil
        }
        
        guard let bodytype = aDecoder.decodeObject(forKey: PropertyKey.bodyType) as? String else {
            os_log("Unable to decode the bodyType for a Car object.", log: OSLog.default, type: .debug)
            return nil
        }
        
        guard let year = aDecoder.decodeObject(forKey: PropertyKey.year) as? String else {
            os_log("Unable to decode the year for a Car object.", log: OSLog.default, type: .debug)
            return nil
        }
        
        let image = aDecoder.decodeObject(forKey: PropertyKey.image) as? UIImage
        
        self.init(image: image, manufacturer: manufacturer, model: model, bodyType: bodytype, year: year)
        
    }
}


