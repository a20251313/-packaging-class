//
//  SCLAlertViewResponder.swift
//  SCLAlertView
//
//  Created by jingfuran on 14/11/21.
//  Copyright (c) 2014年 jingfuran. All rights reserved.
//

import UIKit

class SCLAlertViewResponder: NSObject {
    var  alertView:SCLAlertView!;
    init(alertView:SCLAlertView!)
    {
        self.alertView = alertView;
    }
    func setTitletitle(title:String?)
    {
        self.alertView.labelTitle?.text = title;
    }
    func setSubTitle(subTitle:String?)
    {
        self.alertView.viewText.text = subTitle;
    }
    func close()
    {
        
    }
}
