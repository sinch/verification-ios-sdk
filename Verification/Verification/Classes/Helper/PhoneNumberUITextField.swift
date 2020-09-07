//
//  PhoneNumberFormatter.swift
//  Verification
//
//  Created by Aleksander Wojcik on 07/09/2020.
//  Copyright © 2020 Sinch. All rights reserved.
//

import UIKit
import PhoneNumberKit

/// UITextField implementation that automatically parses phone number based on given country ISO code while typing.
public class PhoneNumberUITextField: UITextField {
    
    // MARK: Properties
    
    private lazy var partialFormatter: PartialFormatter = {
        return PartialFormatter()
    }()
    
    private lazy var phoneKit: PhoneNumberKit = {
        return PhoneNumberKit()
    }()
    
    public var countryIso = SinchPhoneNumberUtils.defaultCountryIso {
        didSet {
            partialFormatter.defaultRegion = countryIso
            updateDisplayedText()
        }
    }
    
    public var e164Number: String? {
        do {
            let phoneNumber =  try phoneKit.parse(self.text ?? "", withRegion: self.countryIso, ignoreType: false)
            return phoneKit.format(phoneNumber, toType: .e164, withPrefix: true)
        } catch {
            print("Phone number parsing failed with \(error.localizedDescription)")
            return nil
        }
    }
        
    // MARK: Initialization
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        initialize()
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    private func initialize() {
        self.addTarget(self, action: #selector(numberDidChanged), for: .editingChanged)
    }
    
    // MARK: Private logic
    
    private func updateDisplayedText() {
        self.text = partialFormatter.formatPartial(self.text ?? "")
    }
    
    @objc private func numberDidChanged() {
        self.updateDisplayedText()
    }
    
}
