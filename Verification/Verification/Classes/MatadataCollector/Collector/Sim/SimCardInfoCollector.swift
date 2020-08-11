//
//  SimCardInfoCollector.swift
//  Verification
//
//  Created by Aleksander Wojcik on 23/07/2020.
//  Copyright © 2020 Sinch. All rights reserved.
//

import CoreTelephony

/// Metadata collector responsible for collecting metadata about sim cards installed on device.
class SimCardInfoCollector: MetadataCollector {
    typealias CollectedType = SimCardsInfoHolder
    
    private let telephonyInfo = CTTelephonyNetworkInfo()
    
    func collect() -> SimCardsInfoHolder {
        let simCardInfo = telephonyInfo.serviceSubscriberCellularProviders?.values.map {
            SimCardInfo(simInfo: $0.simInfo)
            } ?? []
        return SimCardsInfoHolder(info: simCardInfo)
    }
}

fileprivate extension CTCarrier {
    
    /// Maps iOS UiKit CTCarrier info objects to SimMetadata instances used by SDK.
    var simInfo: SimMetadata {
        return SimMetadata(countryId: self.isoCountryCode, name: self.carrierName,
                       mnc: self.mobileNetworkCode, mcc: self.mobileCountryCode)
    }
    
}
