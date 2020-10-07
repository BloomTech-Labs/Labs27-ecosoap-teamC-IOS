//
//  HubDashboardViewController.swift
//  labs-ios-starter
//
//  Created by Christy Hicks on 10/6/20.
//  Copyright © 2020 Spencer Curtis. All rights reserved.
//

import UIKit

class HubDashboardViewController: UIViewController {
    // MARK: - Outlets
    @IBOutlet var newReportButton: UIButton!
    
    // MARK: - Properties
    var isAdmin: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if isAdmin {
            newReportButton.isHidden = false
        } else {
            newReportButton.isHidden = true
        }
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddProductionReportSegue" {
            guard let productionReportVC = segue.destination as? ProductionReportDetailViewController else { return }
            productionReportVC.isAdmin = isAdmin
            productionReportVC.isEditing = true
            productionReportVC.isNewReport = true
        }
    }
}
