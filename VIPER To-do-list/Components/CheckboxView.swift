//
//  CheckboxView.swift
//  VIPER To-do-list
//
//  Created by @_@ on 21.03.2025.
//

import UIKit

final class CheckboxView: UIControl {
    var isChecked: Bool = true {
        didSet {
            updateAppearance()
        }
    }
    
    var checkedColor: UIColor = .black {
        didSet {
            updateAppearance()
        }
    }
    
    var normalColor: UIColor = .black {
        didSet {
            updateAppearance()
        }
    }
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        return imageView
    }()
    
    override var intrinsicContentSize: CGSize {
        CGSize(width: 24, height: 24)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        addSubview(imageView)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        addGestureRecognizer(tapGesture)

        updateAppearance()
    }
    
    private func updateAppearance() {
        let imageName = isChecked ? "checkmark.circle" : "circle"
        let tintColor = isChecked ? checkedColor : normalColor
        imageView.image = UIImage(systemName: imageName)
        imageView.tintColor = tintColor
    }
    
    @objc private func handleTap() {
        isChecked.toggle()
        sendActions(for: .valueChanged)
    }
}
