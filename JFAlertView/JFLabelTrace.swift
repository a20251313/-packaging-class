//
//  JFLabelTrace.swift
//  writeItoastInswift
//
//  Created by jingfuran on 14/11/6.
//  Copyright (c) 2014年 jingfuran. All rights reserved.
//

import UIKit

class JFLabelTrace: UILabel {

    var textShadowColor:UIColor?;
    init(frame:CGRect,withShadowColor myshadowColor:UIColor?,offsetsize offset:CGSize,textColor mytextColor:UIColor?)
    {
        super.init(frame: frame);
        super.shadowColor = myshadowColor;
        super.shadowOffset = offset;
        super.textColor = mytextColor;
        super.backgroundColor = UIColor.clearColor();
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setTextShadowColor(mytextshadowColor:UIColor)
    {
        self.shadowColor = mytextshadowColor;
    }
    
    override func drawTextInRect(rect: CGRect) {
        var myshadowOffet = self.shadowOffset;
        var mytextcolor = self.textColor;
        var c = UIGraphicsGetCurrentContext();
        CGContextSetLineWidth(c, 1);
        CGContextSetLineJoin(c, kCGLineJoinRound);
        CGContextSetTextDrawingMode(c, kCGTextStroke);
        self.textColor = self.shadowColor;
        super.drawTextInRect(rect);
        
        CGContextSetTextDrawingMode(c, kCGTextFill);
        self.textColor = mytextcolor;
        self.shadowOffset = CGSizeMake(0, 0);
        super.drawTextInRect(rect);
        self.shadowOffset = myshadowOffet;
        
        
    }


}
