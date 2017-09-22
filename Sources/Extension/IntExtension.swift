//
//  IntExtension.swift
//  smk
//
//  Created by Charles on 28/02/2017.
//  Copyright © 2017 Matrix. All rights reserved.
//

import UIKit

extension Int {
    public func toUIColor() -> UIColor {
        return UIColor(
            red: CGFloat((self & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((self & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(self & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    public func toCGColor() -> CGColor {
        return self.toUIColor().cgColor
    }
}

extension UInt {
    public func toUIColor() -> UIColor {
        return UIColor(
            red: CGFloat((self & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((self & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(self & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    public func toCGColor() -> CGColor {
        return self.toUIColor().cgColor
    }
}

extension Double {
    func format(_ f: String) -> String {
        ///用法 let myDouble = 1.234567  println(myDouble.format(".2") .2代表留2位小数点
        return NSString(format: "%\(f)f" as NSString, self) as String
    }
}
