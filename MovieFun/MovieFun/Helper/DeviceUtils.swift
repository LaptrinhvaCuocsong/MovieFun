//
//  DeviceUtils.swift
//  MovieFun
//
//  Created by nguyen manh hung on 10/16/19.
//  Copyright © 2019 nguyen manh hung. All rights reserved.
//

import Foundation
import UIKit

enum Device {
    case UNKNOWN
    case IPHONE_SE
    case IPHONE_8
    case IPHONE_8_PLUS
    case IPHONE_X
    case IPHONE_XS
    case IPHONE_XR
    case IPHONE_XS_MAX
    case IPHONE_X_FAMILY
}


struct DeviceUtils {
    
    static let nativeHeight = UIScreen.main.nativeBounds.height
    static let nativeScale = UIScreen.main.nativeScale
    
    static var isIphoneSE: Bool = {
        if nativeHeight == 1136.0 {
            return true
        }
        return false
    }()
    
    static var isIphone8: Bool = {
        if nativeHeight == 1334.0 {
            return true
        }
        return false
    }()
    
    static var isIphone8Plus: Bool = {
        if nativeHeight == 1920.0 || nativeScale == 2.608 {
            return true
        }
        return false
    }()
    
    static var isIphoneX: Bool = {
        if nativeHeight == 2436.0 {
            return true
        }
        return false
    }()
    
    static var isIphoneXS: Bool = {
        if nativeHeight == 2436.0 {
            return true
        }
        return false
    }()
    
    static var isIphoneXR: Bool = {
        if nativeHeight == 1792.0 {
            return true
        }
        return false
    }()
    
    static var isIphoneXSMAX: Bool = {
        if nativeHeight == 2688.0 {
            return true
        }
        return false
    }()
    
    static var isIphoneFamily: Bool = {
        if DeviceUtils.isIphoneX || DeviceUtils.isIphoneXR || DeviceUtils.isIphoneXS || DeviceUtils.isIphoneXSMAX || nativeScale == 3.0 {
            return true
        }
        return false
    }()
    
}
