//
//  DragImg.swift
//  MyLittleMonster
//
//  Created by Mehdi Chennoufi on 12/03/2016.
//  Copyright © 2016 Mehdi Chennoufi. All rights reserved.
//

import Foundation
import UIKit

class DragImg: UIImageView {
    
    // === THIS FILE DEFINED THE MOVES OF THE HEART AND THE FOOD IMAGE
    
    // First i saved the original position (x,y) in a variable
    var originalPosition: CGPoint!
    var dropTarget: UIView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // Touches Functions
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        originalPosition = self.center
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let position = touch.location(in: self.superview)
            self.center = CGPoint(x: position.x, y: position.y)
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if let touch = touches.first, let target = dropTarget {
            
            let position = touch.location(in: self.superview?.superview)
            
            if target.frame.contains(position) {
                
                NotificationCenter.default.post(Notification(name: Notification.Name(rawValue: "onTargetDropped"), object: nil))
            }
        }
        
        self.center = originalPosition
    }
}
