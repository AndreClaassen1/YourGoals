import Foundation


/// This class provides an easy way, to manipulate the current time to "testable time". 
/// Every access to the system date goes over here
public class TimeCapsule {

    private static var testableTime:Date? = nil
    private static var testableTimeLocale:Locale? = nil

    public init() {
    }
    
    public func setTestableTimeValue(_ testTime:Date, testLocale:Locale? = nil) -> Void {
        TimeCapsule.testableTime = testTime
        TimeCapsule.testableTimeLocale = testLocale ?? Locale.current
    }
    
    public func resetTestableTime() -> Void {
        TimeCapsule.testableTime = nil
        TimeCapsule.testableTimeLocale = nil
    }
 
    public func setTestableYear(_ year:Int, month:Int, day:Int) -> Void {
        let calendar = Calendar(identifier: Calendar.Identifier.gregorian)
        var components = DateComponents()
        components.year = year
        components.month = month
        components.day = day
        setTestableTimeValue(calendar.date(from: components)!)
    }
    
    public func setTestableTime(_ year:Int, month:Int, day:Int, hour:Int = 12, minute:Int = 0, second:Int = 0) -> Void {
        let calendar = Calendar(identifier: Calendar.Identifier.gregorian)
        var components = DateComponents()
        components.year = year
        components.month = month
        components.day = day
        components.hour = hour
        components.minute = minute
        components.second = second
        setTestableTimeValue(calendar.date(from: components)!)
    }
    
    /// current date and time
    public var currentDateTime:Date {
        if TimeCapsule.testableTime != nil {
            return TimeCapsule.testableTime!
        }
        return Date()
    }
    
    public var currentLocale:Locale {
        if TimeCapsule.testableTimeLocale != nil {
            return TimeCapsule.testableTimeLocale!
        }
        
        return Locale.current
    }
}
