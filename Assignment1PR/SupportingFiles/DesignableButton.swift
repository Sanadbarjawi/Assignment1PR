//
//  DesignableButton.swift
//  Assignment1PR
//
//  Created by Sanad Barjawi on 7/15/18.
//  Copyright © 2018 Sanad Barjawi. All rights reserved.
//
import UIKit
//Interface builder ,designable: to design your elemets
@IBDesignable class DesignableButton: UIButton {
    //From IBInstpector section
    @IBInspectable var borderWidth: CGFloat = 0.0{
        didSet {
            self.layer.borderWidth = borderWidth
        }
    }
    @IBInspectable var borderColor: UIColor = UIColor.white{
        didSet{
            self.layer.borderColor = borderColor.cgColor
        }
    }
    @IBInspectable var cornerRadius: CGFloat = 0.0{
        didSet{
            self.layer.cornerRadius = cornerRadius
        }
    }
    @IBInspectable var AdjustFontSizetoFit: Bool = false{
        didSet{
            self.titleLabel?.adjustsFontSizeToFitWidth = AdjustFontSizetoFit
        }
    }
    
    
}
