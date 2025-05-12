//
//  PlaceholderableTextView.swift
//  VIPER To-do-list
//
//  Created by @_@ on 23.03.2025.
//

/*
 
 В консоле появляется ошибка:
 
    Error: this application, or a library it uses, has passed an invalid numeric value
    (NaN, or not-a-number) to CoreGraphics API and this value is being ignored.
    Please fix this problem.
 
 Проявляется при лонгтапе текста в UITextView (приближение для точной установки курсора),
 код ниже не связан с ней.
 Apple с 2023 баг не починили ¯\_(ツ)_/¯:
    
    https://developer.apple.com/forums/thread/738726
 
 */

import UIKit

class PlaceholderableTextView: UITextView {
    var placeholder: String? {
        didSet {
            placeholderIsSet = false
            setPlaceholder()
        }
    }
    var placeholderOpacity: Float = 0.7 {
        didSet {
            placeholderIsSet = false
            setPlaceholder()
        }
    }
    
    override var text: String! {
        get {
            if isOutsideCall && placeholderIsSet { //} && super.text == placeholder {
                return nil
            } else {
                return super.text
            }
        }
        
        set {
            super.text = newValue

            if isOutsideCall {
                placeholderIsSet = false
                setPlaceholder()
                
                if !placeholderIsSet {
                    layer.opacity = 1
                }
            }
        }
    }
    
    private(set) var placeholderIsSet: Bool = false
    private var isOutsideCall: Bool = false
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        
        setupObservers()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setupObservers()
    }
    
    private func setupObservers() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(removePlaceholder),
            name: Self.textDidBeginEditingNotification,
            object: self
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(setPlaceholder),
            name: Self.textDidEndEditingNotification,
            object: self
        )
    }
    
    @objc
    private func removePlaceholder() {
        isOutsideCall = false
        defer { isOutsideCall = true }
        
        if text == placeholder && placeholderIsSet {
            text = ""
            layer.opacity = 1
            placeholderIsSet = false
        }
    }
    
    @objc
    private func setPlaceholder() {
        isOutsideCall = false
        defer { isOutsideCall = true }
        
        if (text?.isEmpty ?? true) && !placeholderIsSet {
            text = placeholder
            layer.opacity = placeholderOpacity
            placeholderIsSet = true
        }
    }
}
