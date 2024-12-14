//
//  Double + Ext..swift
//  SwiftUICrypto
//
//  Created by Алексей Колыченков on 08.07.2024.
//

import Foundation

extension Double {
    
    ///форматирование числа Double в валюту
    ///```
    ///Convert 1234.56 to $1,234.56
    ///Convert 12.3456 to $12.3456
    ///Convert 0.123456 to $0.123456
    ///```
    private var currencyFormatter6: NumberFormatter {
        let numberFormatter = NumberFormatter()
        numberFormatter.usesGroupingSeparator = true
        numberFormatter.numberStyle = .currency
        numberFormatter.locale = .current // <- default value
        numberFormatter.currencyCode = "usd" // <- change currency
        numberFormatter.currencySymbol = "$" // <- change currency symbol
        ///кол-во цифр после дробной точки
        numberFormatter.minimumFractionDigits = 2
        numberFormatter.maximumFractionDigits = 6
        return numberFormatter
    }
    
    ///форматирование числа Double в валюту as String
    ///```
    ///Convert 1234.56 to "$1,234.56"
    ///Convert 12.3456 to "$12.3456"
    ///Convert 0.123456 to "$0.123456"
    ///```
    func asCurrencyWith6Decimals() -> String {
        let number = NSNumber(value: self)
        return currencyFormatter6.string(from: number) ?? "$0.00"
    }
    
    ///Convert Double into String representation
    ///```
    ///Convert 1.23456 to "1.23"
    ///```
    func asNumberString() -> String {
        return String(format: "%.2f", self) //% - само число, 2f - форматируем его чтобы оно было с двумя знаками после запятой
    }
    
    ///Convert Double into String representation with percent symbol
    ///```
    ///Convert 1.23456 to "1.23%"
    ///```
    func asPercentString() -> String {
        asNumberString() + "%"
    }
    
    /// Convert a Double to a String with K, M, Bn, Tr abbreviations.
       /// ```
       /// Convert 12 to 12.00
       /// Convert 1234 to 1.23K
       /// Convert 123456 to 123.45K
       /// Convert 12345678 to 12.34M
       /// Convert 1234567890 to 1.23Bn
       /// Convert 123456789012 to 123.45Bn
       /// Convert 12345678901234 to 12.34Tr
       /// ```
       func formattedWithAbbreviations() -> String {
           let num = abs(Double(self))
           let sign = (self < 0) ? "-" : ""

           switch num {
           case 1_000_000_000_000...:
               let formatted = num / 1_000_000_000_000
               let stringFormatted = formatted.asNumberString()
               return "\(sign)\(stringFormatted)Tr"
           case 1_000_000_000...:
               let formatted = num / 1_000_000_000
               let stringFormatted = formatted.asNumberString()
               return "\(sign)\(stringFormatted)Bn"
           case 1_000_000...:
               let formatted = num / 1_000_000
               let stringFormatted = formatted.asNumberString()
               return "\(sign)\(stringFormatted)M"
           case 1_000...:
               let formatted = num / 1_000
               let stringFormatted = formatted.asNumberString()
               return "\(sign)\(stringFormatted)K"
           case 0...:
               return self.asNumberString()

           default:
               return "\(sign)\(self)"
           }
       }

    
}
