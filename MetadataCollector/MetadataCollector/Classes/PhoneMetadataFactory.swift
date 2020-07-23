//
//  PhoneMetadataFactory.swift
//  MetadataCollector
//
//  Created by Aleksander Wojcik on 22/07/2020.
//  Copyright © 2020 Sinch. All rights reserved.
//

public protocol PhoneMetadataFactory {
    func create() -> PhoneMetadata
}
