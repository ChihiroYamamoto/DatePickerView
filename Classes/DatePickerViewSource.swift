//
//  DatePickerViewSource.swift
//  DatePickerView
//
//  Created by Tomoki Koga on 2017/08/01.
//  Copyright © 2017年 tomoponzoo. All rights reserved.
//

import Foundation

open class DatePickerViewSource {
    open var mode: UIDatePickerMode = .date
    open var locale: Locale? = Locale.current
    open var minuteInterval: Int = 1
    open var date: Date?
    open var minimumDate: Date?
    open var maximumDate: Date?
    
    open var titleFor: ((Date) -> String?)?
    open var attributedTitleFor: ((Date) -> NSAttributedString?)?
    open var dateChanged: ((Date) -> Void)?
    
    public init(_ closure: ((DatePickerViewSource) -> Void)) {
        closure(self)
    }
}

extension DatePickerViewSource {
    
    func updateDate(_ date: Date) {
        self.date = date
        dateChanged?(date)
    }
}
