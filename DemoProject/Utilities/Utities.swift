//
//  Utities.swift
//  DemoProject
//
//  Created by Ankush Sharma on 27/03/22.
//

import Foundation
import UIKit


public class UtilityFunctions {
    
    
    public class func printToConsole(message : Any) {
        #if DEBUG
            print(message)
        #endif
    }
    
    public class func debugPrintToConsole(message : Any) {
        #if DEBUG
            debugPrint(message)
        #endif
    }
    
    class func showAlert(message : String?){
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        UIApplication.topViewController()?.present(alert, animated: true)
    }
}



