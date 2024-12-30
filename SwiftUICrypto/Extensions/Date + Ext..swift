//
//  Date + Ext..swift
//  SwiftUICrypto
//
//  Created by Алексей Колыченков on 30.12.2024.
//

import Foundation

extension Date {
    
    //"2021-03-13T20:49:26.606Z"
    init(coinDate: String) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ" //такой формат приходит
        let date = formatter.date(from: coinDate) ?? Date()
        self.init(timeInterval: 0, since: date)
    }
    
    private var shortFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter
    }
    
    func asShortDateString() -> String {
        shortFormatter.string(from: self)
    }
}
