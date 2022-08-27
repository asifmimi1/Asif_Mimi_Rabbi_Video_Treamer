//
//  Extensions.swift
//  Asif_Mimi_Rabbi_Video_Treamer
//
//  Created by Asif Rabbi on 28/8/22.
//

import Foundation
import UIKit

extension NSObject {
    
    class func nib()->UINib {
        return UINib.init(nibName: String(describing: self), bundle: nil)
    }
}
