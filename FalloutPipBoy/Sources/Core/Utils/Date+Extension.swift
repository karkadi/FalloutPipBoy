import Foundation

extension Date {
    /// Returns a string representation of the time in "HH:mm:ss" format (e.g., "14:30:45")
    var timeString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss"
        return formatter.string(from: self)
    }
    
    /// Returns the day of month as a three-digit string with leading zeros (e.g., "001", "015", "123")
      var dayOfMonth: String {
          let calendar = Calendar.current
          let day = calendar.component(.day, from: self)
          return String(format: "%03d", day)
      }
    
    /// Returns the month as a two-digit string (e.g., "01" for January, "12" for December)
    var monthString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM"
        return formatter.string(from: self)
    }
    
    /// Returns the day of week as a three-letter abbreviation (e.g., "Mon", "Tue", "Wed")
    var dayOfWeekString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE"
        return formatter.string(from: self)
    }
    
    // MARK: - Alternative methods that take locale into account
    
    /// Returns the day of week as a three-letter abbreviation using the current locale
    var localizedDayOfWeek: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE"
        formatter.locale = Locale.current
        return formatter.string(from: self)
    }
    
    /// Returns the month as a two-digit string using the current locale
    var localizedMonthString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM"
        formatter.locale = Locale.current
        return formatter.string(from: self)
    }
}
