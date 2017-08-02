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
        // Do any additional setup after loading the view, typically from a nib.
        
        datePickerView.source = DatePickerViewSource { (source) in
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
        datePickerView.endEditing = { [weak self] (date) in
            print(self?.datePickerView.source?.titleFor?(date) ?? "")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

