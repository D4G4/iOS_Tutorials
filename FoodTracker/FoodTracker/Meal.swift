//
//  Meal.swift
//  FoodTracker
//
//  Created by Daksh Gargas on 26/12/18.
//  Copyright © 2018 Daksh Gargs. All rights reserved.
//

import UIKit
import os.log

class Meal: NSObject, NSCoding {
    
    //MARK: Properties
    
    var name: String
    var photo: UIImage?
    var rating: Int
    
    struct PropertyKey {
        static let name = "name"
        static let photo = "photo"
        static let rating = "rating"
    }
    
    //MARK: Initialization
    
    /*Failable initializer*/
    init?(name: String, photo: UIImage?, rating: Int) {
        //  The name must not be empty
        guard !name.isEmpty else {
            return nil
        }
        
        //  The rating must be between 0 and 5 inclusively
        guard (rating >= 0) && (rating <= 5) else {
            return nil
        }
        
        self.name = name
        self.photo = photo
        self.rating = rating 
    }
    
    //  MARK: NSCoding
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: PropertyKey.name)
        aCoder.encode(photo, forKey: PropertyKey.photo)
        aCoder.encode(rating, forKey: PropertyKey.rating)
    }
    
    // convenience -> Means this is secondary initializer, and that it must call a designated initializer from the same calss
    required convenience init?(coder aDecoder: NSCoder) {
        // The name is required. If we cannot decode a name string, the initializer should fail
        
        // (as?) -> Unwrapping and downcasting
        guard let name = aDecoder.decodeObject(forKey: PropertyKey.name) as? String else {
            os_log("Unable to decode the name for a Meal object.", log: OSLog.default, type: .debug)
            return nil
        }
        
        let photo = aDecoder.decodeObject(forKey: PropertyKey.photo) as? UIImage
        let rating = aDecoder.decodeInteger(forKey: PropertyKey.rating)
        
        self.init(name: name, photo: photo, rating: rating)
    }
    
    // MARK: Archiving Paths
    /// You need a persistent path on the file system where data will be saved and loaded, so you know where to look for
    static let DocumentsDirectory: URL = FileManager().urls(for: FileManager.SearchPathDirectory.documentDirectory, in: FileManager.SearchPathDomainMask.userDomainMask).first!
    
    static let ArchiveURL: URL = DocumentsDirectory.appendingPathComponent("meals")
    
}
