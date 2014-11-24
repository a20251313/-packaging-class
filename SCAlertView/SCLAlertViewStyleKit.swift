//
//  SCLAlertViewStyleKit.swift
//  SCLAlertView
//
//  Created by jingfuran on 14/11/21.
//  Copyright (c) 2014年 jingfuran. All rights reserved.
//

import UIKit

var kimageOfCheckmark:UIImage? = nil;
var kimageOfCross:UIImage? = nil;
var kimageOfNotice:UIImage? = nil;
var kimageOfWarning:UIImage? = nil;
var kimageOfInfo:UIImage? = nil;
var kimageOfEdit:UIImage? = nil;


class SCLAlertViewStyleKit: NSObject {

    class func drawCheckmark()
    {
        
        var checkmarkShapePath = UIBezierPath();
        checkmarkShapePath.moveToPoint(CGPointMake(73.25, 14.05));
        checkmarkShapePath.addCurveToPoint(CGPointMake(64.51, 13.86), controlPoint1: CGPointMake(70.98, 11.44) , controlPoint2: CGPointMake(66.78, 11.26));
        checkmarkShapePath.addLineToPoint(CGPointMake(27.46, 52));
        checkmarkShapePath.addLineToPoint(CGPointMake(15.75, 39.54));
        checkmarkShapePath.addCurveToPoint(CGPointMake(6.84, 39.54), controlPoint1: CGPointMake(13.48, 36.93), controlPoint2: CGPointMake(9.28, 36.93));
         checkmarkShapePath.addCurveToPoint(CGPointMake(6.84, 49.02), controlPoint1: CGPointMake(4.39, 42.14) , controlPoint2: CGPointMake(4.39, 46.42));
        checkmarkShapePath.addLineToPoint(CGPointMake(22.91, 66.14));
        checkmarkShapePath.addCurveToPoint(CGPointMake(27.28, 68), controlPoint1: CGPointMake(24.14, 67.44), controlPoint2: CGPointMake(25.71, 68));
        checkmarkShapePath.addCurveToPoint(CGPointMake(31.65, 66.14), controlPoint1: CGPointMake(28.86, 68), controlPoint2: CGPointMake(30.43, 67.26));
        checkmarkShapePath.addLineToPoint(CGPointMake(73.08, 23.35));
        checkmarkShapePath.addCurveToPoint(CGPointMake(73.25, 14.05), controlPoint1: CGPointMake(75.52, 20.75), controlPoint2: CGPointMake(75.7, 16.65));
        checkmarkShapePath.closePath();
        checkmarkShapePath.miterLimit = 4;
        UIColor.whiteColor().setFill();
        checkmarkShapePath.fill();
    }
    
    
    class func drawCross()
    {
        var crossShapePath = UIBezierPath();
        crossShapePath.moveToPoint(CGPointMake(10, 70));
        crossShapePath.addLineToPoint(CGPointMake(70, 10));
        crossShapePath.moveToPoint(CGPointMake(10, 10));
        crossShapePath.addLineToPoint(CGPointMake(70, 70));
        crossShapePath.lineCapStyle = kCGLineCapRound;
        crossShapePath.lineJoinStyle = kCGLineJoinRound;
        UIColor.whiteColor().setStroke();
        crossShapePath.lineWidth = 4;
        crossShapePath.stroke();
    }
    
    class func drawNotice()
    {
        
        var noticeShapePath = UIBezierPath();
        noticeShapePath.moveToPoint(CGPointMake(72, 48.54));
        noticeShapePath.addLineToPoint(CGPointMake(72, 39.9));
        noticeShapePath.addCurveToPoint(CGPointMake(66.38, 34.01), controlPoint1: CGPointMake(72, 36.76), controlPoint2: CGPointMake(69.48, 34.01));
        noticeShapePath.addCurveToPoint(CGPointMake(61.53, 35.97), controlPoint1: CGPointMake(64.82, 34.01), controlPoint2: CGPointMake(62.69, 34.8));
        noticeShapePath.addCurveToPoint(CGPointMake(60.36, 35.78), controlPoint1: CGPointMake(61.33, 35.97), controlPoint2: CGPointMake(62.3, 35.78));
        noticeShapePath.addLineToPoint(CGPointMake(60.36, 33.22));
        noticeShapePath.addCurveToPoint(CGPointMake(54.16, 26.16), controlPoint1: CGPointMake(60.36, 29.3), controlPoint2: CGPointMake(57.65, 26.16));
        noticeShapePath.addCurveToPoint(CGPointMake(48.73, 29.89), controlPoint1: CGPointMake(51.64, 26.16), controlPoint2: CGPointMake(50.67, 27.73));
        noticeShapePath.addLineToPoint(CGPointMake(48.73, 28.71));
        noticeShapePath.addCurveToPoint(CGPointMake(43.49, 21.64), controlPoint1: CGPointMake(48.73, 24.78), controlPoint2: CGPointMake(46.98, 21.64));
        noticeShapePath.addCurveToPoint(CGPointMake(39.03, 25.37), controlPoint1: CGPointMake(40.97, 21.64), controlPoint2: CGPointMake(39.03, 23.01));
        noticeShapePath.addLineToPoint(CGPointMake(39.03, 9.07));
        noticeShapePath.addCurveToPoint(CGPointMake(32.24, 2), controlPoint1: CGPointMake(39.03, 5.14), controlPoint2: CGPointMake(35.73, 2));
        noticeShapePath.addCurveToPoint(CGPointMake(25.45, 9.07), controlPoint1: CGPointMake(28.56, 2), controlPoint2: CGPointMake(25.45, 5.14));
        noticeShapePath.addLineToPoint(CGPointMake(25.45, 41.47));
        noticeShapePath.addCurveToPoint(CGPointMake(24.29, 43.44), controlPoint1:  CGPointMake(25.45, 42.45), controlPoint2: CGPointMake(24.68, 43.04));
        noticeShapePath.addCurveToPoint(CGPointMake(9.55, 43.04), controlPoint1: CGPointMake(16.73, 40.88), controlPoint2: CGPointMake(11.88, 40.69));
        noticeShapePath.addCurveToPoint(CGPointMake(8, 46.58), controlPoint1: CGPointMake(8.58, 43.83), controlPoint2: CGPointMake(8, 45.2));
        noticeShapePath.addCurveToPoint(CGPointMake(14.4, 55.81), controlPoint1: CGPointMake(8.19, 50.31), controlPoint2: CGPointMake(12.07, 53.84));
        noticeShapePath.addLineToPoint(CGPointMake(27.2, 69.56));
        noticeShapePath.addCurveToPoint(CGPointMake(42.91, 77.8), controlPoint1: CGPointMake(30.5, 74.47), controlPoint2: CGPointMake(35.73, 77.21));
        noticeShapePath.addCurveToPoint(CGPointMake(43.88, 77.8), controlPoint1: CGPointMake(43.3, 77.8), controlPoint2: CGPointMake(43.68, 77.8));
        noticeShapePath.addCurveToPoint(CGPointMake(47.18, 78), controlPoint1: CGPointMake(45.04, 77.8), controlPoint2: CGPointMake(46.01, 78));
        noticeShapePath.addLineToPoint(CGPointMake(48.34, 78));
        noticeShapePath.addLineToPoint(CGPointMake(48.34, 78));
        noticeShapePath.addCurveToPoint(CGPointMake(71.61, 52.08), controlPoint1: CGPointMake(56.48, 78), controlPoint2: CGPointMake(69.87, 75.05));
        noticeShapePath.addCurveToPoint(CGPointMake(72, 48.54), controlPoint1: CGPointMake(71.81, 51.29), controlPoint2: CGPointMake(72, 49.72));
        noticeShapePath.closePath();
        noticeShapePath.miterLimit  = 4;
        UIColor.whiteColor().setFill();
        noticeShapePath.fill();
      
    }
    
    class func drawWarning()
    {
        var greyColor = UIColor(red: 0.236, green: 0.236, blue: 0.236, alpha: 1);
        var warningCirclePath = UIBezierPath();
        warningCirclePath.moveToPoint(CGPointMake(40.94, 63.39));
        warningCirclePath.addCurveToPoint(CGPointMake(36.03, 65.55), controlPoint1: CGPointMake(39.06, 63.39), controlPoint2: CGPointMake(37.36, 64.18));
        warningCirclePath.addCurveToPoint(CGPointMake(34.14, 70.45) , controlPoint1: CGPointMake(34.9, 66.92), controlPoint2: CGPointMake(37.36, 64.18));
        warningCirclePath.addCurveToPoint(CGPointMake(36.22, 75.54), controlPoint1: CGPointMake(34.14, 72.41), controlPoint2: CGPointMake(34.9, 74.17));
        warningCirclePath.addCurveToPoint(CGPointMake(40.94, 77.5), controlPoint1: CGPointMake(37.54, 76.91), controlPoint2: CGPointMake(39.06, 77.5));
        warningCirclePath.addCurveToPoint(CGPointMake(45.86, 75.35), controlPoint1: CGPointMake(42.83, 77.5), controlPoint2: CGPointMake(44.53, 76.72));
        warningCirclePath.addCurveToPoint(CGPointMake(47.93, 70.45), controlPoint1: CGPointMake(47.18, 74.17), controlPoint2: CGPointMake(47.93, 72.41));
        warningCirclePath.addCurveToPoint(CGPointMake(45.86, 65.35), controlPoint1: CGPointMake(47.93, 68.49), controlPoint2: CGPointMake(47.18, 66.72));
        warningCirclePath.addCurveToPoint(CGPointMake(40.94, 63.39), controlPoint1: CGPointMake(44.53, 64.18), controlPoint2: CGPointMake(42.83, 63.39));
        warningCirclePath.closePath();
        warningCirclePath.miterLimit = 4;
        greyColor.setFill();
        warningCirclePath.fill();
        
        
        var shapePath = UIBezierPath();
        shapePath.moveToPoint(CGPointMake(46.23, 4.26));
        shapePath.addCurveToPoint(CGPointMake(40.94, 2.5), controlPoint1: CGPointMake(44.91, 3.09), controlPoint2: CGPointMake(43.02, 2.5));
        shapePath.addCurveToPoint(CGPointMake(34.71, 4.26), controlPoint1: CGPointMake(38.68, 2.5), controlPoint2: CGPointMake(36.03, 3.09));
        shapePath.addCurveToPoint(CGPointMake(31.5, 8.77) , controlPoint1: CGPointMake(33.01, 5.44) , controlPoint2: CGPointMake(31.5, 7.01));
        shapePath.addLineToPoint(CGPointMake(31.5, 19.36));
        shapePath.addLineToPoint(CGPointMake(34.71, 54.44));
        shapePath.addCurveToPoint(CGPointMake(40.38, 58.16), controlPoint1: CGPointMake(34.9, 56.2), controlPoint2: CGPointMake(36.41, 58.16));
        shapePath.addCurveToPoint(CGPointMake(45.67, 54.44), controlPoint1: CGPointMake(44.34, 58.16), controlPoint2: CGPointMake(45.67, 56.01));
        shapePath.addLineToPoint(CGPointMake(48.5, 19.36));
        shapePath.addLineToPoint(CGPointMake(48.5, 8.77));
        shapePath.addCurveToPoint(CGPointMake(46.23, 4.26), controlPoint1: CGPointMake(48.5, 7.01), controlPoint2: CGPointMake(47.74, 5.44));
        shapePath.closePath();
        shapePath.miterLimit = 4;
        greyColor.setFill();
        shapePath.fill();
     
    }
    
    class func drawInfo()
    {
        var     color = UIColor(red: 1, green: 1, blue: 1, alpha: 1);
        var     infoPath = UIBezierPath();
        infoPath.moveToPoint(CGPointMake(45.66, 15.96));
        infoPath.addCurveToPoint(CGPointMake(45.66, 5.22), controlPoint1: CGPointMake(48.78, 12.99), controlPoint2: CGPointMake(48.78, 8.19));
        infoPath.addCurveToPoint(CGPointMake(34.34, 5.22), controlPoint1: CGPointMake(42.53, 2.26), controlPoint2: CGPointMake(37.47, 2.26));
        infoPath.addCurveToPoint(CGPointMake(34.34, 15.96), controlPoint1: CGPointMake(31.22, 8.19), controlPoint2: CGPointMake(31.22, 12.99));
        infoPath.addCurveToPoint(CGPointMake(45.66, 15.96), controlPoint1: CGPointMake(37.47, 18.92), controlPoint2: CGPointMake(42.53, 18.92));
        infoPath.closePath();
        
        infoPath.moveToPoint(CGPointMake(48, 69.41));
        infoPath.addCurveToPoint(CGPointMake(40, 77), controlPoint1: CGPointMake(48, 73.58), controlPoint2: CGPointMake(44.4, 77));
        infoPath.addLineToPoint(CGPointMake(40, 77));
        infoPath.addCurveToPoint(CGPointMake(32, 69.41), controlPoint1: CGPointMake(35.6, 77), controlPoint2: CGPointMake(32, 73.58));
        infoPath.addLineToPoint(CGPointMake(32, 35.26));
        infoPath.addCurveToPoint(CGPointMake(40, 27.67), controlPoint1: CGPointMake(32, 31.08), controlPoint2: CGPointMake(35.6, 27.67));
        infoPath.addLineToPoint(CGPointMake(40, 27.67));
        infoPath.addCurveToPoint(CGPointMake(48, 35.26), controlPoint1: CGPointMake(44.4, 27.67), controlPoint2: CGPointMake(48, 31.08));
        infoPath.addLineToPoint(CGPointMake(48, 69.41));
        infoPath.closePath();
        color.setFill();
        infoPath.fill();

    }
    
    class func drawEdit()
    {
        
        let color = UIColor(red: 1, green: 1, blue: 1, alpha: 1);
        let editPath = UIBezierPath();
        editPath.moveToPoint(CGPointMake(71, 2.7));
        editPath.addCurveToPoint(CGPointMake(71.9, 15.2), controlPoint1: CGPointMake(74.7, 5.9), controlPoint2: CGPointMake(75.1, 11.6));
        editPath.addLineToPoint(CGPointMake(64.5, 23.7));
        editPath.addLineToPoint(CGPointMake(49.9, 11.1));
        editPath.addLineToPoint(CGPointMake(57.3, 2.6));
        editPath.addCurveToPoint(CGPointMake(69.7, 1.7), controlPoint1: CGPointMake(60.4, -1.1), controlPoint2: CGPointMake(66.1, -1.5));
        editPath.addLineToPoint(CGPointMake(71, 2.7));
        editPath.addLineToPoint(CGPointMake(71, 2.7));
        editPath.closePath();
        
        editPath.moveToPoint(CGPointMake(47.8, 13.5));
        editPath.addLineToPoint(CGPointMake(13.4, 53.1));
        editPath.addLineToPoint(CGPointMake(15.7, 55.1));
        editPath.addLineToPoint(CGPointMake(50.1, 15.5));
        editPath.addLineToPoint(CGPointMake(47.8, 13.5));
        editPath.addLineToPoint(CGPointMake(47.8, 13.5));
        editPath.closePath();
        
        editPath.moveToPoint(CGPointMake(17.7, 56.7));
        editPath.addLineToPoint(CGPointMake(23.8, 62.2));
        editPath.addLineToPoint(CGPointMake(58.2, 22.6));
        editPath.addLineToPoint(CGPointMake(52, 17.1));
        editPath.addLineToPoint(CGPointMake(17.7, 56.7));
        editPath.addLineToPoint(CGPointMake(17.7, 56.7));
        editPath.closePath();
        
        
        editPath.moveToPoint(CGPointMake(25.8, 63.8));
        editPath.addLineToPoint(CGPointMake(60.1, 24.2));
        editPath.addLineToPoint(CGPointMake(62.3, 26.1));
        editPath.addLineToPoint(CGPointMake(28.1, 65.7));
        editPath.addLineToPoint(CGPointMake(25.8, 63.8));
        editPath.addLineToPoint(CGPointMake(25.8, 63.8));
        editPath.closePath();
        
        
        editPath.moveToPoint(CGPointMake(25.9, 68.1));
        editPath.addLineToPoint(CGPointMake(4.2, 79.5));
        editPath.addLineToPoint(CGPointMake(11.3, 55.5));
        editPath.addLineToPoint(CGPointMake(25.9, 68.1));
        editPath.closePath();
        editPath.miterLimit = 4;
        editPath.usesEvenOddFillRule = true;
        color.setFill();
        editPath.fill();
        
    }
    
    class func imageOfCheckmark()->UIImage
    {
        if let image = kimageOfCheckmark
        {
            return image;
        }
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(80, 80), false, 0);
        SCLAlertViewStyleKit.drawCheckmark();
        let image = UIGraphicsGetImageFromCurrentImageContext();
        kimageOfCheckmark = image;
        return image;
    }
    
    class func imageOfCross()->UIImage
    {
        if let image = kimageOfCross
        {
            return image;
        }
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(80, 80), false, 0);
        SCLAlertViewStyleKit.drawCross();
        let image = UIGraphicsGetImageFromCurrentImageContext();
        kimageOfCross = image;
        return image;
    }
    
    class func imageOfNotice()->UIImage
    {
        if let image = kimageOfNotice
        {
            return image;
        }
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(80, 80), false, 0);
        SCLAlertViewStyleKit.drawNotice();
        let image = UIGraphicsGetImageFromCurrentImageContext();
        kimageOfNotice = image;
        return image;
    }
    
    class func imageOfWarning()->UIImage
    {
        if let image = kimageOfWarning
        {
            return image;
        }
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(80, 80), false, 0);
        SCLAlertViewStyleKit.drawWarning();
        let image = UIGraphicsGetImageFromCurrentImageContext();
        kimageOfWarning = image;
        return image;
    }
    class func imageOfInfo()->UIImage
    {
        if let image = kimageOfInfo
        {
            return image;
        }
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(80, 80), false, 0);
        SCLAlertViewStyleKit.drawInfo();
        let image = UIGraphicsGetImageFromCurrentImageContext();
        kimageOfInfo = image;
        return image;
    }
    
    class func imageOfEdit()->UIImage
    {
        if let image = kimageOfEdit
        {
            return image;
        }
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(80, 80), false, 0);
        SCLAlertViewStyleKit.drawEdit();
        let image = UIGraphicsGetImageFromCurrentImageContext();
        kimageOfEdit = image;
        return image;
    }
    
    
}
