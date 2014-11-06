//
//  JFButtonTrace.swift
//  writeItoastInswift
//
//  Created by jingfuran on 14/11/6.
//  Copyright (c) 2014年 jingfuran. All rights reserved.
//

import UIKit
let JFLabelTraceVIEWTAG = 234512345
class JFButtonTrace: UIButton {

    var textFont:UIFont?{
        didSet
        {
            var label = self.viewWithTag(JFLabelTraceVIEWTAG) as JFLabelTrace;
            label.font = self.textFont;
        }
    }
    var textColor:UIColor?
        {
        didSet
        {
            var label = self.viewWithTag(JFLabelTraceVIEWTAG) as JFLabelTrace;
            label.textColor = self.textColor;
        }
    }
    var textShadowColor:UIColor?
        {
        didSet
        {
            var label = self.viewWithTag(JFLabelTraceVIEWTAG) as JFLabelTrace;
            label.textShadowColor = self.textShadowColor;
        }
    }
    var textTitle:String?
        {
        didSet
        {
            var label = self.viewWithTag(JFLabelTraceVIEWTAG) as JFLabelTrace;
            label.text = self.textTitle;
        }
        
    }
    
    init(frame: CGRect,shadowColor myShadowColor:UIColor?,textColor mytextClor:UIColor?,title myTitle:String?){
        super.init(frame: frame);
        
        var labelTrace = JFLabelTrace(frame: self.bounds, withShadowColor: myShadowColor, offsetsize: CGSizeMake(1, 1), textColor: mytextClor);
        labelTrace.text = myTitle;
        labelTrace.backgroundColor = UIColor.clearColor();
        labelTrace.textAlignment = NSTextAlignment.Center;
        labelTrace.tag = JFLabelTraceVIEWTAG;
        labelTrace.font = UIFont.systemFontOfSize(17);
        self.addSubview(labelTrace);
    }
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
    }
    
     override func setTitle(title: String?, forState state: UIControlState) {
        
        self.textTitle = title;
        //self
        
    }
    override func setTitleColor(color: UIColor?, forState state: UIControlState) {
        self.textColor = color;
    }
    
    override func titleForState(state: UIControlState) -> String? {
        
        var label = self.viewWithTag(JFLabelTraceVIEWTAG) as JFLabelTrace;
        return label.text;
    }
    
    func titleLabel()->JFLabelTrace
    {
        var label = self.viewWithTag(JFLabelTraceVIEWTAG) as JFLabelTrace;
        return label;
    }
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
