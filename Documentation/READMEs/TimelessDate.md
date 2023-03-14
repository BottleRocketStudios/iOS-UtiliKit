# TimelessDate

A `TimelessDate` is a simple abstraction the removes the time from a Date and uses Calendar for calculations. This is especially useful for calendar and travel use cases as seeing how many days away something is often is more important that the number of hours between them / 24.

``` swift
func numberOfDaysBetween(start: TimelessDate, finish: TimelessDate) -> DateInterval {
    return start.dateIntervalSince(finish)
}

func isOneWeekFrom(checkout: TimelessDate) -> Bool {
    return checkout.dateIntervalSince(TimelessDate()) <= 7
}
```

This struct also removes the imprecise calculations of adding days, hours, minutes, and seconds to a date and replaces them with Calendar calculations.

``` swift
func addOneHourTo(date: Date) -> Date {
    return date.adding(hours: 1)
}
```
