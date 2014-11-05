//
//  iTosat.Swift
//  writeItoastInswift
//
//  Created by jingfuran on 14/11/5.
//  Copyright (c) 2014年 jingfuran. All rights reserved.
//

import UIKit

var shareSetting:iToastSettings?

enum iToastGravity:Int
{
    case 	iToastGravityTop = 1000001;
    case    iToastGravityBottom;
    case    iToastGravityCenter
}

enum iToastDuration:Int {
   case     iToastDurationLong = 10000;
   case     iToastDurationShort = 1000;
   case     iToastDurationNormal = 3000;
}

enum iToastType:Int{
   case     iToastTypeInfo = -100000
   case     iToastTypeNotice
   case     iToastTypeWarning
   case     iToastTypeError
}


class iToastSettings: NSObject,NSCopying {
    var duration:Int;
    var gravtity:iToastGravity;
    var postition:CGPoint;
    var images:Dictionary<NSString,UIImage>;
    var positionIsSet:Bool;
    
    override init() {
        self.duration = 1;
        self.gravtity = iToastGravity.iToastGravityCenter;
        self.postition =  CGPointZero;
        self.positionIsSet = false;
        self.images = Dictionary(minimumCapacity: 4);
        super.init();
        
    }
     func copyWithZone(zone: NSZone) -> AnyObject {
        var copy = iToastSettings();
        copy.gravtity = self.gravtity;
        copy.duration = self.duration;
        copy.postition = self.postition;
        var keys = self.images.keys
        for  key in keys
        {
            
            var type:iToastType = iToastType(rawValue: key.integerValue)!;
            copy.setImage(images[key], forType:type);
        }
        return copy;
    }
    class func getSharedSettings()->iToastSettings
    {
        
        if(shareSetting == nil)
        {
            shareSetting = iToastSettings();
            shareSetting?.gravtity = iToastGravity.iToastGravityCenter;
            shareSetting?.duration = iToastDuration.iToastDurationShort.rawValue;
        }
        
        return shareSetting!;
    }
    func setImage(image:UIImage?,forType type:iToastType)
    {
      
        if(image != nil)
        {
            var key = "\(type.rawValue)";
            images[key] = image;
        }
        
    }
}

class iToast: NSObject {

    var _setting:iToastSettings?;
    var offsetLeft:Int;
    var offsetTop:Int;
    var timer:NSTimer?;
    var view:UIView?
    var text:NSString;
    var overlayWindow:UIWindow?
    
    init(text:NSString)
    {
        self.text = text;
        offsetLeft = 1;
        offsetTop = 1;
        super.init();
    }
    func changeInterface(note:NSNotification)
    {
        var dicInfo = note.userInfo! as NSDictionary;
        var type = dicInfo.valueForKey(UIApplicationStatusBarOrientationUserInfoKey)?.integerValue;
        if(type == 4)
        {
            var trans:CGFloat = CGFloat(-M_PI_2*3);
            view?.transform = CGAffineTransformMakeRotation(trans);
            overlayWindow?.transform = CGAffineTransformMakeRotation(trans);
        }else
        {
            var trans:CGFloat = CGFloat(M_PI_2*3);
            view?.transform = CGAffineTransformMakeRotation(trans);
            overlayWindow?.transform = CGAffineTransformMakeRotation(trans);
            
        }
    
    }
    class func makeText(text:String)->iToast
    {
        var toast = iToast(text: text);
        return toast;
    }
    
    func setDuration(duration:Int)->iToast
    {
        self.theSetting().duration = duration;
        return self;
    }
    func setGravity(gravity:iToastGravity)->iToast
    {
        self.theSetting().gravtity = gravity;
        return self;
    }
    func setGravity(gravity:iToastGravity,offsetLeft myoffsetLet:Int,offsetTop myoffsetTop:Int)->iToast
    {
        self.theSetting().gravtity = gravity;
        offsetLeft = myoffsetLet;
        offsetTop = myoffsetTop;
        return self;
    }
    
    func setPosition(position:CGPoint)->iToast
    {
        self.theSetting().postition = position;
        return self;
    }
    
    func theSetting()->iToastSettings
    {
        if(_setting == nil)
        {
            _setting = iToastSettings.getSharedSettings();
        }
        return _setting!;
    }
    
    func hideToast(timer:NSTimer!)
    {
        UIView.beginAnimations(nil, context:nil);
        view?.alpha = 0;
        UIView.commitAnimations();
        
        var timer2 = NSTimer(timeInterval: 0.1, target: self, selector: "removeToast:", userInfo: nil, repeats: false);
        NSRunLoop.currentRunLoop().addTimer(timer2, forMode: NSDefaultRunLoopMode);
    }
    func removeToast(theTimer:NSTimer)
    {
        view?.removeFromSuperview();
        
    }
    func addobserverForBarOrientationNotification()
    {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIApplicationDidChangeStatusBarOrientationNotification, object: nil);
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "changeInterface:", name: UIApplicationDidChangeStatusBarOrientationNotification, object: nil);
    }
    func show()
    {
        var theSettings = _setting;
        if(theSettings == nil)
        {
            theSettings = iToastSettings.getSharedSettings();
        }
        var font = UIFont.systemFontOfSize(16);
        
        var dic = NSDictionary(objectsAndKeys: font,NSFontAttributeName);
        var textsize = self.text.boundingRectWithSize(CGSizeMake(280, 60), options: NSStringDrawingOptions.UsesFontLeading, attributes: dic, context: nil).size;
        var label = UILabel(frame: CGRectMake(0, 0, textsize.width, textsize.height));
        label.backgroundColor = UIColor.clearColor();
        label.font = font;
        label.text = text;
        label.numberOfLines = 0;
        label.shadowColor = UIColor.darkGrayColor();
        label.shadowOffset = CGSizeMake(1, 1);
        
        var button:UIButton = UIButton();
        button.frame = CGRectMake(0, 400, textsize.width+10, textsize.height+10);
        label.center = CGPointMake(button.frame.size.width/2, button.frame.size.height/2);
        button.addSubview(label);
        button.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.7);
        button.layer.cornerRadius = 2;
        
        let array = UIApplication.sharedApplication().windows as NSArray;
        var window = array.firstObject as UIWindow;
        
        var point = CGPointZero;

        let gra = theSettings?.gravtity;
        
        if(gra == iToastGravity.iToastGravityTop)
        {
            point = CGPointMake(window.frame.size.width/2, 45);
        }else if(gra == iToastGravity.iToastGravityCenter)
        {
            point = CGPointMake(window.frame.size.width/2, window.frame.size.height/2);
        }else if(gra == iToastGravity.iToastGravityBottom)
        {
            point = CGPointMake(window.frame.size.width/2, window.frame.size.height-45);
        }
        point = CGPointMake(point.x+CGFloat(offsetLeft), point.y+CGFloat(offsetTop));
        button.center = point;
        var timer1 = NSTimer(timeInterval: 2, target: self, selector: "hideToast:", userInfo: nil, repeats: false);
        NSRunLoop.currentRunLoop().addTimer(timer1, forMode: NSDefaultRunLoopMode);
        window.addSubview(button);
        view = button;

    }
    
    deinit
    {
        NSNotificationCenter.defaultCenter().removeObserver(self);
    }
    
   
}
