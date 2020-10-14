//
//  ReportCell.swift
//  labs-ios-starter
//
//  Created by Christy Hicks on 10/14/20.
//  Copyright © 2020 Spencer Curtis. All rights reserved.
//

import UIKit

class ReportCell: UICollectionViewCell {
    var report: ProductionReport? { didSet { updateContent() } }
    override var isSelected: Bool { didSet { updateAppearance() } }
    
    private let dateLabel: UILabel = {
        let dateLabel = UILabel()
        dateLabel.font = .preferredFont(forTextStyle: .headline)
        return dateLabel
    }()
    
    private let barsProducedLabel = UILabel()
    private let soapmakersWorkedLabel = UILabel()
    private let soapmakerHoursLabel =  UILabel()
    
    private let disclosureIndicator: UIImageView = {
        let disclosureIndicator = UIImageView()
        disclosureIndicator.image = UIImage(systemName: "chevron.down")
        disclosureIndicator.contentMode = .scaleAspectFit
        disclosureIndicator.preferredSymbolConfiguration = .init(textStyle: .body, scale: .small)
        return disclosureIndicator
    }()
    
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
        soapmakerHoursLabel
       ])
        labelStack.axis = .vertical
        labelStack.spacing = padding
        return labelStack
    }()
    
    private var closedConstraint: NSLayoutConstraint?
    private var openConstraint: NSLayoutConstraint?
    
    private let padding: CGFloat = 8
    private let cornerRadius: CGFloat = 8
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUp()
    }
    
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
        
        openConstraint =
            soapmakerHoursLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -padding)
        openConstraint?.priority = .defaultLow
    }
    
    private func updateContent() {
        guard let report = report else { return }
        dateLabel.text = String(describing: report.date)
        barsProducedLabel.text = "Bars Produced: \(String(describing: report.barsProduced))"
        soapmakersWorkedLabel.text = "Soapmakers Worked: \(String(describing: report.soapmakersWorked))"
        soapmakerHoursLabel.text = "Soapmaker Hours: \(String(describing: report.soapmakerHours))"
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
