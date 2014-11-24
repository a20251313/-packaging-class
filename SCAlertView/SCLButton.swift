//
//  SCLButton.swift
//  SCLAlertView
//
//  Created by jingfuran on 14/11/21.
//  Copyright (c) 2014年 jingfuran. All rights reserved.
//

import UIKit

enum SCLActionType
{
    case None;
    case Selector;
}
class SCLButton: UIButton {

    var actionType = SCLActionType.None;
    var target:AnyObject?;
    var selector:Selector?;
}
