//
//  ProductionReportDetailViewController.swift
//  labs-ios-starter
//
//  Created by Christy Hicks on 10/6/20.
//  Copyright © 2020 Spencer Curtis. All rights reserved.
//

import UIKit

class ProductionReportDetailViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet var reportImagesCollectionView: ProductionReportImagesCollectionView!
    @IBOutlet var editButton: UIBarButtonItem!
    @IBOutlet var deleteButton: UIBarButtonItem!
    @IBOutlet var datePicker: UIDatePicker!
    @IBOutlet var barsProducedTextField: UITextField!
    @IBOutlet var soapmakersWorkedTextField: UITextField!
    @IBOutlet var soapmakerHoursTextfield: UITextField!
    @IBOutlet var addSoapPhotoButton: UIButton!
    @IBOutlet var addMediaButton: UIButton!
    @IBOutlet var submitButton: UIButton!
    
    // MARK: - Properties
    var isAdmin: Bool = false
    var isNewReport: Bool = false
    var isEditingReport: Bool = false
    var report: ProductionReport?
    
    // MARK: Views
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
    }
    
    func updateViews() {
        if isAdmin {
            editButton.isEnabled = true
            deleteButton.isEnabled = true
            
            if isEditingReport {
                enableTextEntry()
                showButtons()
                if isNewReport {
                    submitButton.titleLabel?.text = "Submit"
                } else {
                    submitButton.titleLabel?.text = "Save Changes"
                }
            } else {
                disableTextEntry()
                hideButtons()
            }
        } else {
            editButton.isEnabled = false
            deleteButton.isEnabled = false
            hideButtons()
        }
        
        if report == report {
            displayReport()
        }
    }
    
    func disableTextEntry() {
        barsProducedTextField.isEnabled = false
        soapmakersWorkedTextField.isEnabled = false
        soapmakerHoursTextfield.isEnabled = false
        datePicker.isEnabled = false
    }
    
    func enableTextEntry() {
        barsProducedTextField.isEnabled = true
        soapmakersWorkedTextField.isEnabled = true
        soapmakerHoursTextfield.isEnabled = true
        datePicker.isEnabled = true
    }
    
    func hideButtons() {
        submitButton.isHidden = true
        addSoapPhotoButton.isHidden = true
        addMediaButton.isHidden = true
    }
    
    func showButtons() {
        submitButton.isHidden = false
        addSoapPhotoButton.isHidden = false
        addMediaButton.isHidden = false
    }
    
    func displayReport() {
        guard let report = report else { return }
        
        // TODO: Add images to collection view
        datePicker.date = report.date
        barsProducedTextField.text = String(report.barsProduced ?? 0)
        soapmakersWorkedTextField.text = String(report.soapmakersWorked ?? 0)
        soapmakerHoursTextfield.text = String(report.soapmakerHours ?? 0)
    }
    
    @IBAction func editReport(_ sender: UIBarButtonItem) {
        isNewReport = false
        isEditingReport = true
        updateViews()
    }
    
    @IBAction func deleteReport(_ sender: UIBarButtonItem) {
    }
    @IBAction func dateChosen(_ sender: UIDatePicker) {
        report?.date = datePicker.date
    }
    @IBAction func addSoapPhoto(_ sender: UIButton) {
    }
    @IBAction func addMedia(_ sender: UIButton) {
    }
    @IBAction func submitReport(_ sender: UIButton) {
    }
}
