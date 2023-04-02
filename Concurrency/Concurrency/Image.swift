//
//  Image.swift
//  Concurrency
//
//  Created by Rita Marrano on 27/03/23.
//

import Foundation
import UIKit
import CoreData


struct IMage: Identifiable {
    let id = UUID()
    let image: UIImage
}


@objc(Photo)
class Photo: NSManagedObject {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Photo> {
        return NSFetchRequest<Photo>(entityName: "Photo")
    }
    
    @NSManaged public var content: UIImage?
}

extension Photo : Identifiable {
    
}
