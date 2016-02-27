import Foundation

extension NSDate {
    var humanReadableTimeSinceNow: String {
        let oneHour = 60.0 * 60.0
        let interval = abs(timeIntervalSinceNow)
        if interval < oneHour {
            let minutesSinceNow = Int(interval / 60.0)
            return "\(minutesSinceNow)m"
        } else if interval < (24 * oneHour) {
            let hoursSinceNow = Int(interval / oneHour)
            return "\(hoursSinceNow)h"
        } else {
            let daysSinceNow = Int(interval / (24 * oneHour))
            return "\(daysSinceNow)d"
        }
    }
    
    var isToday: Bool {
        let calendar = NSCalendar.currentCalendar()
        let flags = NSCalendarUnit.Day.union(.Month).union(.Year)
        let todayComponents: NSDateComponents = calendar.components(flags, fromDate: NSDate())
        let dateComponents: NSDateComponents = calendar.components(flags, fromDate: self)
        return (todayComponents.day == dateComponents.day && todayComponents.month == dateComponents.month && todayComponents.year == dateComponents.year)
    }
}
