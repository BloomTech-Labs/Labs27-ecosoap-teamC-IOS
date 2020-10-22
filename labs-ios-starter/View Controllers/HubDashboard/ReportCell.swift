//
//  ReportCell.swift
//  labs-ios-starter
//
//  Created by Christy Hicks on 10/14/20.
//  Copyright © 2020 Spencer Curtis. All rights reserved.
//

import UIKit

class ReportCell: UICollectionViewCell {
    // MARK: - Properties
    var report: ProductionReport? { didSet { updateContent() } }
    override var isSelected: Bool { didSet { updateAppearance() } }
    
    // Labels
    private let dateLabel: UILabel = {
        let dateLabel = UILabel()
        dateLabel.font = .preferredFont(forTextStyle: .headline)
        return dateLabel
    }()
    
    private let barsProducedLabel = UILabel()
    private let soapmakersWorkedLabel = UILabel()
    private let soapmakerHoursLabel =  UILabel()
    
    // Button
    private let viewReportButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("View Report", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor(named: "ESB Blue")
        button.heightAnchor.constraint(equalToConstant: 50.0).isActive = true
        button.layer.cornerRadius = 8
        button.addTarget(self, action: #selector(viewReport), for: .touchUpInside)
        return button
    }()
    
    // Chevron
    private let disclosureIndicator: UIImageView = {
        let disclosureIndicator = UIImageView()
        disclosureIndicator.image = UIImage(systemName: "chevron.down")
        disclosureIndicator.contentMode = .scaleAspectFit
        disclosureIndicator.preferredSymbolConfiguration = .init(textStyle: .body, scale: .small)
        return disclosureIndicator
    }()
    
    // Stack Views
    private lazy var rootStack: UIStackView = {
        let rootStack = UIStackView(arrangedSubviews: [labelStack, disclosureIndicator])
        rootStack.alignment = .top
        rootStack.distribution = .fillProportionally
        return rootStack
    }()
    
    private lazy var labelStack: UIStackView = {
       let labelStack = UIStackView(arrangedSubviews: [
       dateLabel,
        barsProducedLabel,
        soapmakersWorkedLabel,
        soapmakerHoursLabel,
        viewReportButton
       ])
        labelStack.axis = .vertical
        labelStack.spacing = padding
        return labelStack
    }()
    
    // Constraints
    private var closedConstraint: NSLayoutConstraint?
    private var openConstraint: NSLayoutConstraint?
    
    private let padding: CGFloat = 8
    private let cornerRadius: CGFloat = 8
    
    // MARK: - Actions
    @objc func viewReport() {
    }
    
    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUp()
    }
    
    // MARK: - Methods
    private func setUp() {
        backgroundColor = .systemGray6
        clipsToBounds = true
        layer.cornerRadius = cornerRadius
        
        contentView.addSubview(rootStack)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        rootStack.translatesAutoresizingMaskIntoConstraints = false
        setUpConstraints()
        updateAppearance()
    }
    
    private func setUpConstraints() {
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: topAnchor),
            contentView.leadingAnchor.constraint(equalTo: leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: bottomAnchor),
            rootStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: padding),
            rootStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            rootStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
        ])
        
        closedConstraint =
            dateLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -padding)
        closedConstraint?.priority = .defaultLow
        
        if BackendController.shared.loggedInUser.role == .HUB_ADMIN {
        openConstraint =
            viewReportButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -padding)
        } else {
            openConstraint = soapmakerHoursLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -padding)
        }
        openConstraint?.priority = .defaultLow
    }
    
    private func updateContent() {
        guard let report = report else { return }
        
        let dateString = report.date.asShortDateString()
        dateLabel.text = dateString
        
        if let barsProduced = report.barsProduced {
        barsProducedLabel.text = "Bars Produced: \(barsProduced)"
        } else {
            barsProducedLabel.text = "Bars Produced: 0"
        }
        
        if let soapmakersWorked = report.soapmakersWorked {
        soapmakersWorkedLabel.text = "Soapmakers Worked: \(soapmakersWorked)"
        } else {
            soapmakersWorkedLabel.text = "Soapmakers Worked: 0"
        }
        
        if let soapmakerHours = report.soapmakerHours {
            soapmakerHoursLabel.text = "Soapmaker Hours: \(soapmakerHours)"
        } else {
            soapmakerHoursLabel.text = "Soapmaker Hours: 0"
        }
        
            viewReportButton.titleLabel?.text = "View Report Details"
    }
    
    private func updateAppearance() {
        closedConstraint?.isActive = !isSelected
        openConstraint?.isActive = isSelected
        
        UIView.animate(withDuration: 0.3) {
            let upsideDown = CGAffineTransform(rotationAngle: .pi * 0.999 )
            self.disclosureIndicator.transform = self.isSelected ? upsideDown :.identity
        }
    }
}
