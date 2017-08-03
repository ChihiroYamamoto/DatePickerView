//
//  ViewController.swift
//  DatePickerView
//
//  Created by Tomoki Koga on 2017/07/25.
//  Copyright © 2017年 tomoponzoo. All rights reserved.
//

import UIKit
import DatePickerView

class ViewController: UIViewController {
    @IBOutlet weak var datePickerView: DatePickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        datePickerView.source = DatePickerViewSource { (source) in
            source.date = Date()
            source.titleFor = { (date) in
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy/M/d"
                formatter.timeZone = TimeZone.current
                formatter.locale = Locale(identifier: "en_US_POSIX")
                return formatter.string(from: date)
            }
            source.dateChanged = { (date) in
                print(source.titleFor?(date) ?? "")
            }
        }
        datePickerView.endEditing = { (date) in
            // Returns the date at the end of editing.
        }
        datePickerView.reloadData()
    }
}
