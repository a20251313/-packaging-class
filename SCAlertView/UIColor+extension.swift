//
//  UIColor+extension.swift
//  BizfocusOA_swift
//
//  Created by jingfuran on 14/11/19.
//  Copyright (c) 2014年 jingfuran. All rights reserved.
//

import Foundation
import UIKit

extension UIColor{
    convenience init(rred:CGFloat,ggreen:CGFloat,bblue:CGFloat)
    {
        self.init(red: rred/255.0, green: ggreen/255.0, blue: bblue/255.0, alpha: 1);
    }
    
    convenience init(rred:CGFloat,ggreen:CGFloat,bblue:CGFloat,aapha:CGFloat)
    {
        self.init(red: rred/255.0, green: ggreen/255.0, blue: bblue/255.0, alpha: aapha);
    }
}
