//
//  HapticManager.swift
//  SwiftUICrypto
//
//  Created by Алексей Колыченков on 19.12.2024.
//

import Foundation
import SwiftUI

final class HapticManager {
    
    ///Генератор обратно связи/отдачи
    static private let generator = UINotificationFeedbackGenerator()
    
    static func notify(type: UINotificationFeedbackGenerator.FeedbackType) {
        generator.notificationOccurred(type)
    }
}
