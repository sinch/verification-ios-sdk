//
//  MethodButton.swift
//  VerificationSample
//
//  Created by Aleksander Wojcik on 21/07/2020.
//  Copyright © 2020 Aleksander Wojcik. All rights reserved.
//

import UIKit

@IBDesignable
class MethodButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initialize()
    }
    
    override var isSelected: Bool {
        didSet {
            updateSelectedState()
        }
    }
    
    private func initialize() {
        tintColor = .clear
        layer.borderWidth = 0.5
        
        setTitleColor(.textGray, for: .normal)
        setTitleColor(.white, for: .selected)
        
        updateSelectedState()
    }
    
    private func updateSelectedState() {
        self.backgroundColor = isSelected ? .sinchPurple : .white
        self.layer.borderColor = isSelected ? UIColor.sinchPurple.cgColor : UIColor.textGray.cgColor
    }
}
