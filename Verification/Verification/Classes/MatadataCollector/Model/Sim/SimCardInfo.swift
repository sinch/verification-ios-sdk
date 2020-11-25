//
//  SimCardInfo.swift
//  Verification
//
//  Created by Aleksander Wojcik on 23/07/2020.
//  Copyright © 2020 Sinch. All rights reserved.
//

/// Class holding metadata about currently used sim card and operator of network the phone is connected to. To better understand the differences between properties of these fields check [this](https://stackoverflow.com/questions/38726068/android-mcc-and-mnc) SO question.
///
/// On iOS it not possible to get the operator metadata so currently the class holds only SimMetadata object.
struct SimCardInfo: Encodable {
    
    let simInfo: SimMetadata
    
    enum CodingKeys: String, CodingKey {
           case simInfo = "sim"
       }
}
