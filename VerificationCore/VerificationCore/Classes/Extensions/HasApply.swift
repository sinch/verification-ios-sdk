//
//  HasApply.swift
//  VerificationCore
//
//  Created by Aleksander Wojcik on 09/07/2020.
//  Copyright © 2020 Aleksander Wojcik. All rights reserved.
//

/** Protocol used for making Swift classes be able to use `apply` function.
 
 The concept is a copy of Kotlin's [apply](https://kotlinlang.org/api/latest/jvm/stdlib/kotlin/apply.html) function.
 
 */
public protocol HasApply { }

public extension HasApply {
    
    /// Calls the specified function block with this value as its receiver and returns this value.
    /// - Parameter closure: Closure applied to given object.
    /// - Returns: `This` object
    func apply(closure:(Self) -> ()) -> Self {
        closure(self)
        return self
    }
    
}

extension NSObject: HasApply { }
extension URLRequest: HasApply { }
