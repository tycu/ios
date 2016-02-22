import Foundation

extension NSDate {
    var humanReadableTimeSinceNow: String {
        let oneHour = 60.0 * 60.0
        let interval = abs(timeIntervalSinceNow)
        if interval < oneHour {
            let minutesSinceNow = Int(interval / 60.0)
            return "\(minutesSinceNow)m"
        } else if timeIntervalSinceNow < (24 * oneHour) {
            let hoursSinceNow = Int(interval / oneHour)
            return "\(hoursSinceNow)h"
        } else {
            let daysSinceNow = Int(interval / (24 * oneHour))
            return "\(daysSinceNow)"
        }
    }
}
