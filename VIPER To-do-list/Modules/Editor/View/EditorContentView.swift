//
//  EditorContentView.swift
//  VIPER To-do-list
//
//  Created by @_@ on 24.03.2025.
//

import UIKit

final class EditorContentView: UIScrollView {
    var titleText: String? {
        get {
            titleTextView.text
        } set {
            titleTextView.text = newValue
        }
    }
    
    var date: String {
        get {
            dateLabel.text ?? ""
        } set {
            dateLabel.text = newValue
        }
    }
    
    var descriptionText: String? {
        get {
            descriptionTextView.text
        } set {
            descriptionTextView.text = newValue
        }
    }
    
    private lazy var titleTextView: PlaceholderableTextView = {
        let textView = PlaceholderableTextView()
        textView.placeholder = "Задача"
        textView.font = .systemFont(ofSize: 34, weight: .bold)
        textView.isScrollEnabled = false
        
        return textView
    }()
    
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.layer.opacity = 0.5
        
        return label
    }()
    
    private lazy var descriptionTextView: PlaceholderableTextView = {
        let textView = PlaceholderableTextView()
        textView.placeholder = "Описание задачи"
        textView.font = .systemFont(ofSize: 16)
        textView.isScrollEnabled = false
        
        return textView
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        backgroundColor = .systemBackground
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard)))
        
        setupLayout()
    }
    
    private func setupLayout() {
        addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            stackView.widthAnchor.constraint(equalTo: widthAnchor)
        ])
        
        stackView.addArrangedSubview(titleTextView)
        stackView.addArrangedSubview(dateLabel)
        stackView.addArrangedSubview(descriptionTextView)
        stackView.setCustomSpacing(8, after: titleTextView)
        stackView.setCustomSpacing(16, after: dateLabel)
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = UIEdgeInsets(top: 8, left: 20, bottom: 8, right: 20)
    }
    
    @objc
    private func dismissKeyboard() {
        titleTextView.resignFirstResponder()
        descriptionTextView.resignFirstResponder()
    }
}
