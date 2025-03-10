//
//  AppFont.swift
//  SeniKita
//
//  Created by Ricky Primayuda Putra on 16/02/25.
//

import SwiftUI

struct AppFont {

    struct Raleway {
        static let headerLarge = Font.custom("Raleway-ExtraBold", size: 40)
        static let headerMedium = Font.custom("Raleway-ExtraBold", size: 30)
        static let titleLarge = Font.custom("Raleway-Bold", size: 32)
        static let titleMedium = Font.custom("Raleway-ExtraBold", size: 22)
        static let subtitle = Font.custom("Raleway-Bold", size: 16)
        static let bodyLarge = Font.custom("Raleway-Medium", size: 18)
        static let bodyMedium = Font.custom("Raleway-Regular", size: 17)
        static let footnoteLarge = Font.custom("Raleway-Regular", size: 16)
        static let footnoteSmall = Font.custom("Raleway-Regular", size: 13)
    }

    struct Crimson {
        static let headerLarge = Font.custom("CrimsonPro-ExtraBold", size: 40)
        static let headerMedium = Font.custom("CrimsonPro-ExtraBold", size: 30)
        static let titleLarge = Font.custom("CrimsonPro-Bold", size: 32)
        static let titleMedium = Font.custom("CrimsonPro-ExtraBold", size: 22)
        static let subtitle = Font.custom("CrimsonPro-Bold", size: 16)
        static let bodyLarge = Font.custom("CrimsonPro-Regular", size: 18)
        static let bodyMedium = Font.custom("CrimsonPro-Regular", size: 17)
        static let footnoteLarge = Font.custom("CrimsonPro-Regular", size: 16)
        static let footnoteSmall = Font.custom("CrimsonPro-Regular", size: 13)
    }
    
    struct Nunito {
        static let headerLarge = Font.custom("Nunito-ExtraBold", size: 40)
        static let headerMedium = Font.custom("Nunito-ExtraBold", size: 30)
        static let titleLarge = Font.custom("Nunito-Bold", size: 32)
        static let titleMedium = Font.custom("Nunito-ExtraBold", size: 22)
        static let subtitle = Font.custom("Nunito-Bold", size: 16)
        static let bodyLarge = Font.custom("Nunito-Regular", size: 18)
        static let bodyMedium = Font.custom("Nunito-Regular", size: 17)
        static let footnoteLarge = Font.custom("Nunito-Regular", size: 16)
        static let footnoteSmall = Font.custom("Nunito-Regular", size: 13)
    }

    static func customFont(_ family: FontFamily, weight: FontWeight, size: CGFloat) -> Font {
        let fontName = "\(family.rawValue)-\(weight.rawValue)"
        return Font.custom(fontName, size: size)
    }
}

enum FontFamily: String {
    case raleway = "Raleway"
    case crimson = "CrimsonPro"
    case nunito = "Nunito"
}

enum FontWeight: String {
    case black = "Black"
    case extraBold = "ExtraBold"
    case bold = "Bold"
    case semiBold = "SemiBold"
    case medium = "Medium"
    case regular = "Regular"
    case light = "Light"
    case extraLight = "ExtraLight"
    case thin = "Thin"
}
