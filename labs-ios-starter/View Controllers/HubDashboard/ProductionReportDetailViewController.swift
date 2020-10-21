//
//  ProductionReportDetailViewController.swift
//  labs-ios-starter
//
//  Created by Christy Hicks on 10/6/20.
//  Copyright © 2020 Spencer Curtis. All rights reserved.
//

import UIKit

class ProductionReportDetailViewController: UIViewController, UICollectionViewDelegate {
    
    // MARK: - Outlets
    @IBOutlet var reportImagesCollectionView: ReportImageCollectionView!
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
    var controller = BackendController.shared
    let gray = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 1)
    
    
    // MARK: Views
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
        reportImagesCollectionView.delegate = self
    }
    
    func updateViews() {
        let cornerRadius: CGFloat = 8
        addSoapPhotoButton.layer.cornerRadius = cornerRadius
        addMediaButton.layer.cornerRadius = cornerRadius
        submitButton.layer.cornerRadius = cornerRadius
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
        barsProducedTextField.textColor = gray
        soapmakersWorkedTextField.isEnabled = false
        soapmakersWorkedTextField.textColor = gray
        soapmakerHoursTextfield.isEnabled = false
        soapmakerHoursTextfield.textColor = gray
        datePicker.isEnabled = false
    }
    
    func enableTextEntry() {
        barsProducedTextField.isEnabled = true
        barsProducedTextField.textColor = .label
        soapmakersWorkedTextField.isEnabled = true
        soapmakersWorkedTextField.textColor = .label
        soapmakerHoursTextfield.isEnabled = true
        soapmakerHoursTextfield.textColor = .label
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
        
        reportImagesCollectionView.report = report
        datePicker.date = report.date
        barsProducedTextField.text = String(report.barsProduced ?? 0)
        soapmakersWorkedTextField.text = String(report.soapmakersWorked ?? 0)
        soapmakerHoursTextfield.text = String(report.soapmakerHours ?? 0)
    }
    
    
    // MARK: - Actions
    @IBAction func editReport(_ sender: UIBarButtonItem) {
        isNewReport = false
        isEditingReport = true
        updateViews()
    }
    
    @IBAction func deleteReport(_ sender: UIBarButtonItem) {
        deleteReport()
    }
    
    @IBAction func dateChosen(_ sender: UIDatePicker) {
        report?.date = datePicker.date
    }
    @IBAction func addSoapPhoto(_ sender: UIButton) {
    }
    @IBAction func addMedia(_ sender: UIButton) {
    }
    @IBAction func submitReport(_ sender: UIButton) {
        let date = datePicker.date
        let barsProduced = Int(barsProducedTextField.text ?? "0")
        let soapmakersWorked = Int(soapmakersWorkedTextField.text ?? "0")
        let soapmakerHours = Int(soapmakerHoursTextfield.text ?? "0")
        // TODO: Implement photos
        let soapPhotos = ["http://www.fillmurray.com/1024/768"]
        let media = ["http://www.fillmurray.com/1100/600",
                     "http://www.fillmurray.com/800/800"]
        saveReport(date: date, barsProduced: barsProduced, soapmakersWorked: soapmakersWorked, soapmakerHours: soapmakerHours, soapPhotos: soapPhotos, media: media)
        controller.productionReportNeedsUpdate = true
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Methods
    func saveReport(date: Date,
                    barsProduced: Int?,
                    soapmakersWorked: Int?,
                    soapmakerHours: Int?,
                    soapPhotos: [String]?,
                    media: [String]?) {
        if isNewReport {
            if let hubId = controller.loggedInUser.hub?.id {
                let input = CreateProductionReportInput(hubId: hubId, date: date, barsProduced: barsProduced, soapmakersWorked: soapmakersWorked, soapmakerHours: soapmakerHours, soapPhotos: soapPhotos, media: media)
                controller.createProductionReport(input: input) { (error) in
                    if let error = error {
                        NSLog("\(error): Error occured during creation of production report.")
                    }
                }
            } else {
                NSLog("Error unwrapping hub id when attempting to create production report.")
            }
        } else {
            if let id = report?.id {
                let input = UpdateProductionReportInput(id: id, date: date, barsProduced: barsProduced, soapmakersWorked: soapmakersWorked, soapmakerHours: soapmakerHours, soapPhotos: soapPhotos, media: media)
                
                controller.updateProductionReport(input: input) { (error) in
                    if let error = error {
                        NSLog("\(error): Error occured while updating production report.")
                    }
                }
            } else {
                NSLog("Error unwrapping production report id when attempting to update report.")
            }
        }
    }
    
    func deleteReport() {
        if let id = report?.id {
            let input = DeleteProductionReportInput(id: id)
            
            controller.productionReports.removeValue(forKey: id)
            controller.deleteProductionReport(input: input) { (error) in
                if let error = error {
                    NSLog("\(error): Error occured while deleting production report.")
                }
            }
        } else {
            NSLog("Can't delete a production report that doesn't exist.")
        }
        controller.productionReportNeedsUpdate = true
        navigationController?.popViewController(animated: true)
    }
}
