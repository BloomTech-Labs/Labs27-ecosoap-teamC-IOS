//
//  HotelHeaderTableViewCell.swift
//  labs-ios-starter
//
//  Created by Bharat Kumar on 10/12/20.
//  Copyright © 2020 Spencer Curtis. All rights reserved.
//

import UIKit

protocol HotelHeaderTableViewCellDelegate {
    func toggleSection(_ header: HotelHeaderTableViewCell, section: Int)
}
class HotelHeaderTableViewCell: UITableViewCell {

    var delegate: HotelHeaderTableViewCellDelegate?
    var section: Int = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(HotelHeaderTableViewCell.tapHeader(_:))))
    }
    
    var property: Property? {
           didSet {
               updateViews()
           }
       }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @objc func tapHeader(_ gestureRecognizer: UITapGestureRecognizer) {
        guard let cell = gestureRecognizer.view as? HotelHeaderTableViewCell else {
            return
        }
        delegate?.toggleSection(self, section: cell.section)
    }
    
    func setCollapsed(_ collapsed: Bool) {
        // Animate the arrow rotation (see Extensions.swf)
        // arrowLabel.rotate(collapsed ? 0.0 : CGFloat(M_PI_2))
    }
    
    private func updateViews() {
        guard let property = property else { return }
        self.textLabel?.text = property.name
    }

}
