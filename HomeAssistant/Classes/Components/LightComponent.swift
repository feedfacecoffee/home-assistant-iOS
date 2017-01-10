//
//  LightComponent.swift
//  HomeAssistant
//
//  Created by Robbie Trencheny on 4/5/16.
//  Copyright © 2016 Robbie Trencheny. All rights reserved.
//

import Foundation
import ObjectMapper

class Light: SwitchableEntity {

    var Brightness: Float?
    var ColorTemp: Float?
    var RGBColor: [Int]?
    var XYColor: [Int]?
    var SupportsBrightness: Bool = false
    var SupportsColorTemp: Bool = false
    var SupportsEffect: Bool = false
    var SupportsFlash: Bool = false
    var SupportsRGBColor: Bool = false
    var SupportsTransition: Bool = false
    var SupportsXYColor: Bool = false
    var SupportedFeatures: Int?

    override func mapping(map: Map) {
        super.mapping(map: map)

        Brightness         <- map["attributes.brightness"]
        ColorTemp          <- map["attributes.color_temp"]
        RGBColor           <- map["attributes.rgb_color"]
        XYColor            <- map["attributes.xy_color"]
        SupportedFeatures  <- map["attributes.supported_features"]

        if let supported = self.SupportedFeatures {
            let features = LightSupportedFeatures(rawValue: supported)
            self.SupportsBrightness = features.contains(.Brightness)
            self.SupportsColorTemp = features.contains(.ColorTemp)
            self.SupportsEffect = features.contains(.Effect)
            self.SupportsFlash = features.contains(.Flash)
            self.SupportsRGBColor = features.contains(.RGBColor)
            self.SupportsTransition = features.contains(.Transition)
            self.SupportsXYColor = features.contains(.XYColor)
        }
    }

    override func EntityColor() -> UIColor {
        if self.IsOn! {
            if self.RGBColor != nil {
                let rgb = self.RGBColor
                let red = CGFloat(rgb![0]/255)
                let green = CGFloat(rgb![1]/255)
                let blue = CGFloat(rgb![2]/255)
                return UIColor.init(red: red, green: green, blue: blue, alpha: 1)
            } else {
                return colorWithHexString("#DCC91F", alpha: 1)
            }
        } else {
            return self.DefaultEntityUIColor
        }
    }

    override var ComponentIcon: String {
        return "mdi:lightbulb"
    }
}

struct LightSupportedFeatures: OptionSet {
    let rawValue: Int

    static let Brightness = LightSupportedFeatures(rawValue: 1)
    static let ColorTemp = LightSupportedFeatures(rawValue: 2)
    static let Effect = LightSupportedFeatures(rawValue: 4)
    static let Flash = LightSupportedFeatures(rawValue: 8)
    static let RGBColor = LightSupportedFeatures(rawValue: 16)
    static let Transition = LightSupportedFeatures(rawValue: 32)
    static let XYColor = LightSupportedFeatures(rawValue: 64)
}
