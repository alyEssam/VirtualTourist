//
//  HelperMethods.swift
//  VirtualTourist
//
//  Created by Aly Essam on 10/13/19.
//  Copyright © 2019 Aly Essam. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    
    
    // Mark: -- Alert Method
    /***************************************************************/
        
     func raiseAlertView(withTitle: String, withMessage: String) {
            
          let alertController = UIAlertController(title: withTitle, message: withMessage, preferredStyle: .alert)
          alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
          present(alertController, animated: true)
        }
}
