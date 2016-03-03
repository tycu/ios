import Foundation

extension NSDate {
    var humanReadableTimeSinceNow: String {
        let oneHour = 60.0 * 60.0
        let oneDay = 24 * oneHour
        let interval = abs(timeIntervalSinceNow)
        if interval < oneHour {
            let minutesSinceNow = Int(interval / 60.0)
            return "\(minutesSinceNow)m"
        } else if interval < (24 * oneHour) {
            let hoursSinceNow = Int(interval / oneHour)
            return "\(hoursSinceNow)h"
        } else if interval < (14 * oneDay) {
            let daysSinceNow = Int(interval / (24 * oneHour))
            return "\(daysSinceNow)d"
        } else {
            let weeksSinceNow = Int(interval / (7 * oneDay))
            return "\(weeksSinceNow)w"
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
