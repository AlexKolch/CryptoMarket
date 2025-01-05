//
//  String + Ext..swift
//  SwiftUICrypto
//
//  Created by Алексей Колыченков on 31.12.2024.
//

import Foundation

extension String {
    
    var removingHTMLcode: String {
        return self.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
    }
}
