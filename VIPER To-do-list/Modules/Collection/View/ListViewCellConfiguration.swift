//
//  TodoListCellConfiguration.swift
//  VIPER To-do-list
//
//  Created by @_@ on 21.03.2025.
//

import UIKit

final class ListViewCellConfiguration: UIContentConfiguration {
    
    let presentable: ListViewPresentable
    let checkboxValueChanged: (Bool) -> ()
    
    static let reuseId: String = "ListViewCell"
    
    init(presentable: ListViewPresentable, checkboxDidToggle: @escaping (Bool) -> ()) {
        self.presentable = presentable
        self.checkboxValueChanged = checkboxDidToggle
    }
    
    func makeContentView() -> any UIView & UIContentView {
        ListViewCellContentView(configuration: self)
    }
    
    func updated(for state: any UIConfigurationState) -> Self {
        return self
    }
}

final class ListViewCellContentView: UIStackView, UIContentView {
    var configuration: UIContentConfiguration {
        didSet {
            applyConfiguration()
        }
    }
    
    private var checkboxValueChanged: ((Bool) -> ())?
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.numberOfLines = 2
        label.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        
        return label
    }()
    
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.layer.opacity = 0.5
        label.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        
        return label
    }()
    
    private lazy var checkbox: CheckboxView = {
        let checkbox = CheckboxView()
        checkbox.checkedColor = .systemYellow
        checkbox.normalColor = .label.withAlphaComponent(0.5)
        
        let action = UIAction(handler: { [weak self] _ in
            guard let checkboxValueChanged = self?.checkboxValueChanged else {
                return
            }
            checkboxValueChanged(checkbox.isChecked)
        })
        checkbox.addAction(action, for: .valueChanged)
        
        return checkbox
    }()
    
    private lazy var textStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .leading
        stack.spacing = 6
        stack.addArrangedSubview(titleLabel)
        stack.addArrangedSubview(descriptionLabel)
        stack.addArrangedSubview(dateLabel)
        
        return stack
    }()
    
    init(configuration: ListViewCellConfiguration) {
        self.configuration = configuration
        
        super.init(frame: .zero)
        
        setup()
        applyConfiguration()
    }
    
    @available(*, unavailable)
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        axis = .horizontal
        alignment = .top
        spacing = 8
        addArrangedSubview(checkbox)
        addArrangedSubview(textStack)
        isLayoutMarginsRelativeArrangement = true
        layoutMargins = UIEdgeInsets(top: 12, left: 20, bottom: 12, right: 20)
    }
    
    private func applyConfiguration() {
        guard let configuration = configuration as? ListViewCellConfiguration else {
            return
        }
        
        // Title
        
        let attributedText = NSAttributedString(
            string: configuration.presentable.title,
            attributes: [
                .strikethroughStyle: configuration.presentable.checkmarked ? NSUnderlineStyle.single.rawValue : [],
                .font: UIFont.systemFont(ofSize: 16, weight: .semibold),
            ]
        )
        titleLabel.layer.opacity = configuration.presentable.checkmarked ? 0.5 : 1
        titleLabel.attributedText = attributedText
        
        // Description
        
        if let description = configuration.presentable.description {
            descriptionLabel.text = description
            descriptionLabel.layer.opacity = configuration.presentable.checkmarked ? 0.5 : 1
            descriptionLabel.isHidden = false
        } else {
            descriptionLabel.isHidden = true
        }
        
        // Date label
        
        dateLabel.text = configuration.presentable.date
        
        // Checkbox
    
        checkbox.isChecked = configuration.presentable.checkmarked
        checkboxValueChanged = configuration.checkboxValueChanged
    }
}
