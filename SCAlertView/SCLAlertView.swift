//
//  SCLAlertView.swift
//  SCLAlertView
//
//  Created by jingfuran on 14/11/21.
//  Copyright (c) 2014年 jingfuran. All rights reserved.
//

import Foundation
import AVFoundation
import UIKit
enum SCLAlertViewStyle:Int
{
    case Success;
    case Error;
    case Notice;
    case Warning;
    case Info;
    case Edit;
    
}

let kDefaultShadowOpacity:CGFloat = 0.7;
let kCircleHeight:CGFloat = 56;
let kCircleTopPosition:CGFloat = -12;
let kCircleBackgroundTopPosition:CGFloat = -15;
let kCircleHeightBackground:CGFloat = 62;
let kCircleIconHeight:CGFloat = 20;
let kWindowWidth:CGFloat = 240;
var kWindowHeight:CGFloat = 178;
var kTextHeight:CGFloat = 90;
let kDefaultFont = "HelveticaNeue";
let kButtonFont =  "HelveticaNeue-Bold";

class SCLAlertView: UIViewController {
    
    var inputs:Array<UITextField>!;
    var buttons:Array<UIButton>!;
    var circleIconImageView:UIImageView!;
    var rootViewController:UIViewController?;
    var circleView:UIView!;
    var shadowView:UIView!;
    var contentView:UIView!;
    var circleViewBackground:UIView!;
    var audioPlayer:AVAudioPlayer?;
    var durationTimer:NSTimer?;
    var gestureRecognier:UITapGestureRecognizer?;
    var attributedFormatBlock:NSAttributedString?;
    var shouldDismissOnTapOutside:Bool = false{
        didSet{
            if shouldDismissOnTapOutside
            {
                self.gestureRecognier = UITapGestureRecognizer(target: self, action: "handleTap:");
                self.shadowView.addGestureRecognizer(gestureRecognier!);
            }
        }
    }
    var labelTitle:UILabel!;
    var viewText:UITextView!;
    var soundURL:NSURL?
        {
        didSet
        {
            var error:NSError? = nil;
            audioPlayer = AVAudioPlayer(contentsOfURL: soundURL, error: &error);
            if(error != nil)
            {
                println("soundURL:\(soundURL) error:\(error)");
            }
        }
    }
    override init()
    {
        super.init(nibName: nil, bundle: nil);
        inputs = Array();
        buttons = Array();
        shouldDismissOnTapOutside = false;
        
        labelTitle = UILabel();
        viewText = UITextView();
        shadowView = UIView();
        contentView = UIView();
        circleView = UIView();
        circleViewBackground = UIView();
        circleIconImageView = UIImageView();
        kWindowHeight = 178;
        kTextHeight = 90;
        
        self.view.addSubview(contentView);
        self.view.addSubview(circleViewBackground);
        self.view.addSubview(circleView);
        self.circleView.addSubview(self.circleIconImageView);
        contentView.addSubview(labelTitle);
        contentView.addSubview(viewText);
        contentView.layer.cornerRadius = 5;
        contentView.layer.masksToBounds = true;
        contentView.layer.borderWidth = 0.5;
        circleViewBackground.backgroundColor = UIColor.whiteColor();
        
        labelTitle.numberOfLines = 1;
        labelTitle.textAlignment = NSTextAlignment.Center;
        labelTitle.font = UIFont(name: kDefaultFont, size: 20);
        
        viewText.editable =  false;
        viewText.allowsEditingTextAttributes = true;
        viewText.textAlignment = NSTextAlignment.Center;
        viewText.font = UIFont(name: kDefaultFont, size: 14);
        
        self.shadowView = UIView(frame: UIScreen.mainScreen().bounds);
        self.shadowView.autoresizingMask = UIViewAutoresizing.FlexibleHeight | UIViewAutoresizing.FlexibleWidth;
        self.shadowView.backgroundColor = UIColor.blackColor();
        
        contentView.backgroundColor = UIColor.whiteColor();
        labelTitle.textColor = UIColor(rred: 0x4d, ggreen: 0x4d, bblue: 0x4d);
        viewText.textColor = UIColor(rred: 0x4d, ggreen: 0x4d, bblue: 0x4d);
        contentView.layer.borderColor = UIColor(rred: 0xcc, ggreen: 0xcc, bblue: 0xcc).CGColor;
        
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews();
        var sz = UIScreen.mainScreen().bounds.size;
        var sysyVersion:NSString = UIDevice.currentDevice().systemVersion;
        if(sysyVersion.floatValue < 8.0)
        {
            if UIInterfaceOrientationIsLandscape(UIApplication.sharedApplication().statusBarOrientation)
            {
                var ssz = sz;
                sz = CGSizeMake(ssz.height, ssz.width);
            }
        }
        
        var newFrame = self.shadowView.frame;
        newFrame.size = sz;
        self.shadowView.frame = newFrame;
        
        var r = CGRectZero;
        if (self.view.superview != nil)
        {
             r = CGRectMake((sz.width-kWindowWidth)/2, (sz.height-kWindowHeight)/2, kWindowWidth, kWindowHeight);
        } else
        {
            // View is not visible, position outside screen bounds
            r = CGRectMake((sz.width-kWindowWidth)/2, -kWindowHeight, kWindowWidth, kWindowHeight);
        }
        
        self.view.frame = r;
        contentView.frame = CGRectMake(0.0, kCircleHeight / 4, kWindowWidth, kWindowHeight);
        circleViewBackground.frame = CGRectMake(kWindowWidth / 2 - kCircleHeightBackground / 2, kCircleBackgroundTopPosition, kCircleHeightBackground, kCircleHeightBackground);
        circleViewBackground.layer.cornerRadius = circleViewBackground.frame.size.height / 2;
        circleView.frame = CGRectMake(kWindowWidth / 2 - kCircleHeight / 2, kCircleTopPosition, kCircleHeight, kCircleHeight);
        circleView.layer.cornerRadius = self.circleView.frame.size.height / 2;
        circleIconImageView.frame = CGRectMake(kCircleHeight / 2 - kCircleIconHeight / 2, kCircleHeight / 2 - kCircleIconHeight / 2, kCircleIconHeight, kCircleIconHeight);
        labelTitle.frame = CGRectMake(12.0, kCircleHeight / 2 + 12.0, kWindowWidth - 24.0, 40.0);
        viewText.frame = CGRectMake(12.0, 74.0, kWindowWidth - 24.0, kTextHeight);
        
        
        if(labelTitle.text == nil)
        {
            viewText.frame = CGRectMake(12.0, kCircleHeight, kWindowWidth - 24.0, kTextHeight);
        }
        
        var y = 74.0 + kTextHeight + 14.0;
        
        for textField in inputs
        {
            textField.frame = CGRectMake(12.0, y, kWindowWidth - 24.0, 30.0);
            textField.layer.cornerRadius = 3;
            y += 40.0;
        }
        
        for btn in buttons
        {
            btn.frame = CGRectMake(12.0, y, kWindowWidth - 24, 35.0);
            btn.layer.cornerRadius = 3;
            y += 45.0;
        }
    }
    
    func handleTap(gesture:UITapGestureRecognizer!)
    {
        if (shouldDismissOnTapOutside)
        {
            self.hideView();
        }
        
    }
    func addTextField(title:String?)->UITextField
    {
        kWindowHeight += 40;
        var txt = UITextField();
        txt.borderStyle = UITextBorderStyle.RoundedRect;
        txt.font = UIFont(name: kDefaultFont, size: 14);
        txt.autocapitalizationType = UITextAutocapitalizationType.Words;
        txt.clearButtonMode  = UITextFieldViewMode.WhileEditing;
        txt.layer.masksToBounds = true;
        txt.layer.borderWidth = 1;
        
        if title != nil
        {
            txt.placeholder = title;
        }
        contentView.addSubview(txt);
        inputs.append(txt);
        return txt;
    }
    func addButton(title:String?)->SCLButton
    {
        kWindowHeight += 45;
        var btn = SCLButton();
        btn.layer.masksToBounds = true;
        btn.setTitle(title, forState: UIControlState.Normal);
        btn.titleLabel?.font = UIFont(name: kDefaultFont, size: 14);
        contentView.addSubview(btn);
        buttons.append(btn);
        return btn;
    }
    func addButton(title:String?,target:(AnyObject?),selector:Selector)->SCLButton
    {
        var btn = self.addButton(title);
        btn.actionType = SCLActionType.Selector;
        btn.selector = selector;
        btn.target = target;
        btn.addTarget(self, action: "buttonTapped:", forControlEvents: UIControlEvents.TouchUpInside);
        return btn;
    }
    
    func buttonTapped(btn:SCLButton!)
    {
        if(btn.actionType == SCLActionType.Selector)
        {
            var ctrl = UIControl();
            ctrl.sendAction(btn.selector!, to: btn.target, forEvent: nil);
        }else
        {
            println("Unknown type block");
        }
        
        self.hideView();
    }
    func hideView()
    {
        UIView.animateWithDuration(0.2,animations: {
            self.shadowView.alpha = 0;
            self.view.alpha = 0}, completion:{ (complete:Bool) in
                self.shadowView.removeFromSuperview();
                self.view.removeFromSuperview();
                self.removeFromParentViewController();
                }
            )

    }
    
    func showTitle(vc:UIViewController,title:NSString?,subTitile:String?,duration:NSTimeInterval,completeText:String?,style:SCLAlertViewStyle)->SCLAlertViewResponder
    {
        self.view.alpha = 0;
        self.rootViewController = vc;
        self.shadowView.frame = vc.view.bounds;
        self.rootViewController?.view.addSubview(self.shadowView);
        self.rootViewController?.view.addSubview(self.view);
        var viewcolor = UIColor.clearColor();
        var iconImage:UIImage? = nil;
        switch style
        {
        case .Success:
            viewcolor = UIColor(rred: 0x22, ggreen: 0xb5, bblue: 0x73);
            iconImage = SCLAlertViewStyleKit.imageOfCheckmark();
        case .Error:
            viewcolor = UIColor(rred: 0xc1, ggreen: 0x27, bblue: 0x2d);
            iconImage = SCLAlertViewStyleKit.imageOfCross();
        case .Notice:
            viewcolor = UIColor(rred: 0x72, ggreen: 0x73, bblue: 0x75);
            iconImage = SCLAlertViewStyleKit.imageOfNotice();
        case .Warning:
            viewcolor = UIColor(rred: 0xff, ggreen: 0xd1, bblue: 0x10);
            iconImage = SCLAlertViewStyleKit.imageOfWarning();
        case .Info:
            viewcolor = UIColor(rred: 0x28, ggreen: 0x66, bblue: 0xbf);
            iconImage = SCLAlertViewStyleKit.imageOfInfo();
        case .Edit:
            viewcolor = UIColor(rred: 0xa4, ggreen: 0x29, bblue: 0xff);
            iconImage = SCLAlertViewStyleKit.imageOfEdit();
            
        }
        
        
        self.labelTitle.text = title;
      
        if(subTitile != nil)
        {
            if let tempString = subTitile
            {
                if(attributedFormatBlock == nil)
                {
                    viewText.text = subTitile;
                }else
                {
                    viewText.attributedText = NSAttributedString(string: subTitile!);
                }
                var str:NSString = tempString;
                var sz = CGSizeMake(kWindowWidth - 24.0, 90.0);
                var attr = NSDictionary(objectsAndKeys: self.viewText.font,NSFontAttributeName);
                var r  = str.boundingRectWithSize(sz, options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: attr, context: nil);
                var ht = ceil(r.size.height)+10;
                if (ht < kTextHeight)
                {
                    kWindowHeight -= (kTextHeight - ht);
                    kTextHeight = ht;
                }
                
                
            }
           
            
        }
        
        if (soundURL != nil)
        {
            if(audioPlayer == nil)
            {
                println("you need set your soundFile correct");
            }else
            {
                audioPlayer?.play();
            }
        }
        
        if(completeText != nil)
        {
            self.addButton(completeText, target: self, selector: "hideView");
        }
        self.circleView.backgroundColor = viewcolor;
        self.circleIconImageView.image = iconImage;
        for textField in  inputs
        {
            textField.layer.borderColor = viewcolor.CGColor;
        }
        for btn in buttons
        {
            btn.backgroundColor = viewcolor;
            if style == .Warning
            {
                btn.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal);
            }
        }
        
        if(duration > 0)
        {
            durationTimer?.invalidate();
            durationTimer = NSTimer.scheduledTimerWithTimeInterval(duration, target: self, selector: "hideView", userInfo: nil, repeats: false);
        }
        
        UIView.animateWithDuration(0.2, animations: {
            self.shadowView.alpha = kDefaultShadowOpacity;
            
            //New Frame
            var frame = self.view.frame;
            if let ypoint = self.rootViewController?.view.center.y
            {
                frame.origin.y = ypoint - 100.0;
            }
         
            self.view.frame = frame;
            
            self.view.alpha = 1.0;
            }, completion: {(complete:Bool) in
                UIView.animateWithDuration(0.2, animations: {
                    if let center = self.rootViewController?.view.center
                    {
                        self.view.center = center;
                    }
                    
                })})
        
        return SCLAlertViewResponder(alertView: self);
        
    }
    
    func showSucces(vc:UIViewController,title:String?,subTitle:String?,closeButton:String?,duration:NSTimeInterval)
    {
        self.showTitle(vc, title: title, subTitile: subTitle, duration: duration, completeText: closeButton, style: SCLAlertViewStyle.Success);
    }
    
    func showError(vc:UIViewController,title:String?,subTitle:String?,closeButton:String?,duration:NSTimeInterval)
    {
        self.showTitle(vc, title: title, subTitile: subTitle, duration: duration, completeText: closeButton, style: SCLAlertViewStyle.Error);
    }
    func showNotice(vc:UIViewController,title:String?,subTitle:String?,closeButton:String?,duration:NSTimeInterval)
    {
        self.showTitle(vc, title: title, subTitile: subTitle, duration: duration, completeText: closeButton, style: SCLAlertViewStyle.Notice);
    }
    func showWarning(vc:UIViewController,title:String?,subTitle:String?,closeButton:String?,duration:NSTimeInterval)
    {
        self.showTitle(vc, title: title, subTitile: subTitle, duration: duration, completeText: closeButton, style: SCLAlertViewStyle.Warning);
    }
    func showInfo(vc:UIViewController,title:String?,subTitle:String?,closeButton:String?,duration:NSTimeInterval)
    {
        self.showTitle(vc, title: title, subTitile: subTitle, duration: duration, completeText: closeButton, style: SCLAlertViewStyle.Info);
    }
    func showEdit(vc:UIViewController,title:String?,subTitle:String?,closeButton:String?,duration:NSTimeInterval)
    {
        self.showTitle(vc, title: title, subTitile: subTitle, duration: duration, completeText: closeButton, style: SCLAlertViewStyle.Edit);
    }
   required init(coder aDecoder: NSCoder) {
   
        super.init();
    
        inputs = Array();
        buttons = Array();
        shouldDismissOnTapOutside = false;
    
        labelTitle = UILabel();
        viewText = UITextView();
        shadowView = UIView();
        contentView = UIView();
        circleView = UIView();
        circleViewBackground = UIView();
        circleIconImageView = UIImageView();
    }
}