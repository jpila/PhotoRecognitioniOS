//
//  RoundView.swift
//  PhotoIdentifier
//
//  Created by JOSE PILAPIL on 2017-07-13.
//  Copyright © 2017 JOSE PILAPIL. All rights reserved.
//

import UIKit

class RoundView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    override func awakeFromNib() {
        super .awakeFromNib()
        
        layer.cornerRadius = self.frame.width / 2
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = self.frame.width / 2
        clipsToBounds = true
        contentMode = .scaleAspectFit
    }
}
