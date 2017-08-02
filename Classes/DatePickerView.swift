//
//  DatePickerView.swift
//  DatePickerView
//
//  Created by Tomoki Koga on 2017/07/25.
//  Copyright © 2017年 tomoponzoo. All rights reserved.
//

import UIKit

open class DatePickerView: UITextField {
    @IBInspectable open var top: CGFloat = 0
    @IBInspectable open var left: CGFloat = 0
    @IBInspectable open var bottom: CGFloat = 0
    @IBInspectable open var right: CGFloat = 0
    
    @IBInspectable open var normalBorderColor: UIColor? = nil
    @IBInspectable open var highlightBorderColor: UIColor? = nil
    
    @IBInspectable open var normalBackgroundImage: UIImage? = nil
    @IBInspectable open var highlightBackgroundImage: UIImage? = nil
    
    public var beginEditing: (() -> Void)?
    public var endEditing: ((Date) -> Void)?
    
    fileprivate var datePicker: UIDatePicker!
    fileprivate var toolbar: Toolbar!

    public var source: DatePickerViewSource? {
        didSet {
            setupDatePicker()
            updateTitle()
        }
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

// MARK: - Public
extension DatePickerView {
    
    public var date: Date {
        get {
            return datePicker.date
        }
        set {
            datePicker.date = date
            source?.date = date
        }
    }
}

// MARK: - Override UITextField
extension DatePickerView {
    
    open override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }
    
    open override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        // 長押しで表示されるメニューを非表示
        UIMenuController.shared.isMenuVisible = false
        return false
    }
    
    open override func textRect(forBounds bounds: CGRect) -> CGRect {
        return textFieldRect(forBounds: bounds)
    }
    
    open override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return textFieldRect(forBounds: bounds)
    }
    
    open override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return textFieldRect(forBounds: bounds)
    }
    
    open override func leftViewRect(forBounds bounds: CGRect) -> CGRect {
        guard let leftViewBounds = leftView?.bounds else {
            return .zero
        }
        
        let y = bounds.height / 2.0 - leftViewBounds.height / 2.0
        return CGRect(
            x: bounds.minX + left,
            y: y < 0 ? 0 : y,
            width: leftViewBounds.width,
            height: leftViewBounds.height
        )
    }
    
    open override func rightViewRect(forBounds bounds: CGRect) -> CGRect {
        guard let rightViewBounds = rightView?.bounds else {
            return .zero
        }
        
        let y = bounds.height / 2.0 - rightViewBounds.height / 2.0
        return CGRect(
            x: bounds.maxX - right - rightViewBounds.width,
            y: y < 0 ? 0 : y,
            width: rightViewBounds.width,
            height: rightViewBounds.height
        )
    }
}

// MARK: - Event
extension DatePickerView {
    
    /// TextFieldの編集開始イベントをハンドル
    ///
    /// - Parameter sender: TextField
    @objc fileprivate func editingDidBegin(_ sender: Any) {
        beginEditing?()
        setStyle(true)
    }
    
    /// TextFieldの編集終了イベントをハンドル
    ///
    /// - Parameter sender: TextField
    @objc fileprivate func editingDidEnd(_ sender: Any) {
        endEditing?(date)
        setStyle(false)
    }
    
    /// DatePickerの値変更イベントをハンドル
    ///
    /// - Parameter sender: DatePicker
    @objc fileprivate func valueChanged(_ sender: Any) {
        source?.updateDate(date)
        updateTitle()
    }
}

// MARK: - Private
extension DatePickerView {
    
    fileprivate func setupView() {
        // DatePicker初期化
        datePicker = UIDatePicker()
        inputView = datePicker
        
        // DatePickerの値変更を監視
        datePicker.addTarget(self, action: #selector(valueChanged(_:)), for: .valueChanged)
        
        // Toolbar初期化
        toolbar = Toolbar(frame: CGRect(x: 0, y: 0, width: Screen.width, height: 44))
        toolbar.tapCompletion = { [weak self] () in
            self?.resignFirstResponder()
        }
        inputAccessoryView = toolbar
        
        // スタイル初期化
        setStyle(false)
        
        // TextFieldの編集開始・終了を監視
        addTarget(self, action: #selector(editingDidBegin(_:)), for: .editingDidBegin)
        addTarget(self, action: #selector(editingDidEnd(_:)), for: .editingDidEnd)
    }
    
    fileprivate func setupDatePicker() {
        guard let source = source else { return }
        
        datePicker.datePickerMode = source.mode
        datePicker.locale = source.locale
        datePicker.date = source.date
        datePicker.minuteInterval = source.minuteInterval
        datePicker.minimumDate = source.minimumDate
        datePicker.maximumDate = source.maximumDate
    }
    
    fileprivate func setStyle(_ isEditing: Bool) {
        if isEditing {
            if let highlightBorderColor = highlightBorderColor {
                layer.borderColor = highlightBorderColor.cgColor
            }
            
            if let highlightBackgroundImage = highlightBackgroundImage {
                background = highlightBackgroundImage
            }
        } else {
            if let normalBorderColor = normalBorderColor {
                layer.borderColor = normalBorderColor.cgColor
            }
            
            if let normalBackgroundImage = normalBackgroundImage {
                background = normalBackgroundImage
            }
        }
    }
    
    fileprivate func updateTitle() {
        text = source?.titleFor?(date)
    }
    
    fileprivate func textFieldRect(forBounds bounds: CGRect) -> CGRect {
        let leftViewBounds = leftView?.bounds ?? .zero
        let rightViewBounds = rightView?.bounds ?? .zero
        
        let leftPadding = leftViewBounds.width > 0 ? left : 0
        let rightPadding = rightViewBounds.width > 0 ? right : 0
        return CGRect(
            x: bounds.minX + left + leftViewBounds.width + leftPadding,
            y: bounds.minY + top,
            width: bounds.width - left - right - leftViewBounds.width - leftPadding - rightViewBounds.width - rightPadding,
            height: bounds.height - top - bottom
        )
    }

    fileprivate struct Screen {
        
        static var size: CGSize {
            return UIApplication.shared.keyWindow?.bounds.size ?? UIScreen.main.bounds.size
        }
        
        static var width: CGFloat {
            return size.width
        }
        
        static var height: CGFloat {
            return size.height
        }
    }
}

/// Custom toolbar
fileprivate class Toolbar: UIToolbar {
    
    fileprivate var tapCompletion: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }
}

// MARK: - Private
extension Toolbar {
    
    fileprivate func setupView() {
        let flexibleSpaceItem = UIBarButtonItem(
            barButtonSystemItem: .flexibleSpace,
            target: nil,
            action: nil
        )
        let completionButtonItem = UIBarButtonItem(
            title: "完了",
            style: .plain,
            target: self,
            action: #selector(tapCompletionButton(_:))
        )
        
        items = [flexibleSpaceItem, completionButtonItem]
    }
}

extension Toolbar {
    
    @objc fileprivate func tapCompletionButton(_ sender: Any) {
        tapCompletion?()
    }
}
