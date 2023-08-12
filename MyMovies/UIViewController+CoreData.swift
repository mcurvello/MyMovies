//
//  UIViewController+CoreData.swift
//  MyMovies
//
//  Created by Marcio Curvello on 12/08/23.
//

import UIKit
import CoreData

extension UIViewController {
    
    var context: NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        return appDelegate.persistentContainer.viewContext
    }
}
