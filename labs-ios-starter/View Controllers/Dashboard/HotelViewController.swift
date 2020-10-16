//
//  HotelsViewController.swift
//  labs-ios-starter
//
//  Created by Bharat Kumar on 10/7/20.
//  Copyright © 2020 Spencer Curtis. All rights reserved.
//

import UIKit
import SwiftUI
import Charts
import TinyConstraints
class HotelsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, ChartViewDelegate {
    
    
    var impactStats = [ImpactStats]()
    @IBOutlet weak var propertyTextField: UITextField!
    @IBOutlet weak var lineChartView: LineChartView!
    @IBOutlet weak var propertiesTableView: UITableView!
    
    let controller = BackendController.shared
    var toggleArrow: Bool?
    private let propertyPicker = UIPickerView()
    private var propertyPickerData: [[String]]?
    private var properties: [Property] = []
    private var selectedProperty: Property? {
        didSet {
            updateViews()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchAll()
        grabProperties()
        setUpViews()
        controller.propertiesByUserId(id: controller.loggedInUser.id) { (error) in
            if error != nil {
                NSLog("Error in getting the properties")
                return
            } else {
                DispatchQueue.main.async {
                    self.propertiesTableView.reloadData()
                }
            }
        }
        
        updateViews()
        setData()
        // Line Chart Implementation
        lineChartView.rightAxis.enabled = false
        lineChartView.delegate = self
        lineChartView.xAxis.enabled = true
        lineChartView.xAxis.labelPosition = .bottom
        lineChartView.rightAxis.drawLabelsEnabled = false
        //        let yAxis = lineChartView.leftAxis
        //        yAxis.labelFont = .boldSystemFont(ofSize: 8)
        //        yAxis.setLabelCount(6, force: false)
        //        yAxis.labelTextColor = .white
        //        yAxis.axisLineColor = .white
        //        yAxis.labelPosition = .outsideChart
        //        lineChartView.xAxis.labelPosition = .bottom
        lineChartView.animate(xAxisDuration: 2.5)
        
        // Ends
        propertiesTableView.delegate = self
        propertiesTableView.dataSource = self
    }
    func setUpViews() {
        propertyPicker.delegate = self
        propertyPicker.dataSource = self
        propertyTextField.layer.cornerRadius = 8
        propertyTextField.setupTextField()
        propertyTextField.inputView = propertyPicker
        self.hideKeyboardWhenViewTapped()
    }
    
    //    func toggleSection(_ header: HotelHeaderTableViewCell, section: Int) {
    //        let collapsed = !(properties[section].isExpanded ?? true)
    //
    //        // Toggle collapse
    //        properties[section].isExpanded = collapsed
    //        header.setCollapsed(collapsed)
    //
    //        // Adjust the height of the rows inside the section
    //        firsttableView.beginUpdates()
    //        for i in 0 ..< properties[section].name.count {
    //            let indexPath = IndexPath(item: i, section: 0)
    //            firsttableView.reloadRows(at: [indexPath], with: .top)
    //        }
    //        firsttableView.endUpdates()
    //    }
    
    
    
    private func fetchAll() {
        controller.initialFetch(userId: controller.loggedInUser.id) { (error) in
            self.grabProperties()
            if let error = error {
                NSLog("\(error): Error occured during initial fetch")
            }
            if let user = self.controller.users[self.controller.loggedInUser.id] {
                self.controller.loggedInUser = user
                print(self.controller.loggedInUser)
            }
            print("\(self.controller.users)")
            print("\(self.controller.properties)")
            print("\(self.controller.pickups)")
            //            print("\(self.controller.payments)")
            print("\(self.controller.hubs)")
            print("\(self.controller.pickupCartons)")
            print("\(self.controller.hospitalityContracts)")
            
        }
    }
    
    private func grabProperties() {
        var propertyNames: [String] = []
        for property in controller.properties.values {
            propertyNames.append(property.name)
            properties.append(property)
        }
        let data: [[String]] = [propertyNames]
        propertyPickerData = data
        
        guard propertyNames.count > 0, properties.count > 0 else { return }
        DispatchQueue.main.async {
            self.propertyTextField.text = propertyNames[0]
            self.selectedProperty = self.properties[0]
        }
        
    }
    
    private func updateViews() {
        guard let selectedProperty = selectedProperty else { return }
        controller.impactStatsByPropertyId(id: selectedProperty.id) { (error) in
            if let error = error {
                print("Error fetching stats \(error)")
            }
            
            DispatchQueue.main.async {
                self.lineChartView.reloadInputViews()
            }
        }
    }
    
    private func overallBreakDown() -> (Int, Int, Int, Int) {
        guard let selectedProperty = selectedProperty else { return (0,0,0,0) }
        let bottlesRecycled = selectedProperty.impact?.bottlesRecycled ?? 0
        let soapRecycled = selectedProperty.impact?.soapRecycled ?? 0
        let paperRecycled = selectedProperty.impact?.paperRecycled ?? 0
        let linensRecycled = selectedProperty.impact?.linensRecycled ?? 0
        
        let total = bottlesRecycled + soapRecycled + paperRecycled + linensRecycled
        let soapPercentage = (Double(soapRecycled) / Double(total)) * 100
        let bottlesPercentage = (Double(bottlesRecycled) / Double(total)) * 100
        let paperPercentage = (Double(paperRecycled) / Double(total)) * 100
        let linensPercentage = (Double(linensRecycled) / Double(total)) * 100
        return (Int(soapPercentage), Int(linensPercentage), Int(bottlesPercentage), Int(paperPercentage))
    }
    
    
    
    private let disclosureIndicator: UIImageView = {
        let disclosureIndicator = UIImageView()
        disclosureIndicator.image = UIImage(systemName: "chevron.down")
        disclosureIndicator.contentMode = .scaleAspectFit
        disclosureIndicator.preferredSymbolConfiguration = .init(textStyle: .body, scale: .small)
        return disclosureIndicator
    }()
    
    private let disclosureIndicatorDown: UIImageView = {
        let disclosureIndicatorDown = UIImageView()
        disclosureIndicatorDown.image = UIImage(systemName: "chevron.up")
        disclosureIndicatorDown.contentMode = .scaleAspectFit
        disclosureIndicatorDown.preferredSymbolConfiguration = .init(textStyle: .body, scale: .small)
        return disclosureIndicatorDown
    }()
    
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        print(entry)
    }
    
    func setData() {
        var dataEntries: [ChartDataEntry] = []
        let dataPoints = ["Soap", "Bottles", "Paper", "Linen"]
        let values = [overallBreakDown().0, overallBreakDown().1
            ,overallBreakDown().2, overallBreakDown().3]
        for i in 0..<dataPoints.count {
            let dataEntry = ChartDataEntry(x: Double(values[i]), y: Double(i))
            dataEntries.append(dataEntry)
        }
        let set1 = LineChartDataSet(entries: dataEntries, label: "Impact Statistics")
        set1.mode = .cubicBezier
        set1.lineWidth = 3
        set1.setColor(UIColor(named: "ESB Blue")!)
        set1.drawCirclesEnabled = false
        set1.fill = Fill(color: UIColor(named: "ESB Blue")!)
        set1.fillAlpha = 0.8
        set1.drawFilledEnabled = true
        set1.drawHorizontalHighlightIndicatorEnabled = false
        
        let data = LineChartData(dataSet: set1)
        data.setDrawValues(false)
        lineChartView.data = data
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        switch segue.identifier {
        case "addNewPropertySegue":
            if let createPropertyVC = segue.destination as? PropertyDetailViewController {
                createPropertyVC.controller = controller
                createPropertyVC.hideAll = true 
                
            }
        case "ShowPropertyDetailPushSegue":
            //            guard let propertyDetailVC = segue.destination as? PropertyDetailViewController else { return }
            //            guard let selectedIndexPath = propertiesTableView.indexPathForSelectedRow else { return }
            //            propertyDetailVC.property = properties[selectedIndexPath.row]
            if let savedPropertyVC = segue.destination as? PropertyDetailViewController {
                savedPropertyVC.controller = controller
                savedPropertyVC.navigationItem.rightBarButtonItem = nil
                if let selectedIndex = propertiesTableView.indexPathForSelectedRow {
                    savedPropertyVC.property = properties[selectedIndex.row]
                }
                
            }
        default:
            break
        }
        
    }
    
    
    // TableView Section
    
    
    //    func numberOfSections(in tableView: UITableView) -> Int {
    //        return sections.count
    //    }
    //
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return properties.count
        
    }
    //    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    //        return 44
    //    }
    //
    
    //    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    //
    //        return properties[(indexPath as NSIndexPath).section].isExpanded ?? true ? 0 : 44.0
    //    }
    //
    //    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
    //        return 1
    //    }
    //
    //    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    //        let headerCellIdentifier = "HotelCell"
    //           let headerCell = tableView.dequeueReusableCell(withIdentifier: headerCellIdentifier) as? HotelHeaderTableViewCell
    //
    //        headerCell?.textLabel?.text = "Hotels"
    //        headerCell?.textLabel?.font = UIFont(name: "Euphemia UCAS", size: 20)
    //        headerCell?.setCollapsed(properties[section].isExpanded ?? true)
    //        headerCell?.imageView?.image = disclosureIndicator.image
    //        if headerCell?.isSelected == true  {
    //            self.toggleArrow?.toggle()
    //            headerCell?.imageView?.image = disclosureIndicator.image ?? disclosureIndicatorDown.image
    //        }
    //        headerCell?.section = section
    //        headerCell?.delegate = self
    //
    //           return headerCell
    //    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == propertiesTableView,
            let cell = tableView.dequeueReusableCell(withIdentifier: "PropertiesCell") as? PropertiesTableViewCell {
            grabProperties()
            let property = properties[indexPath.row]
            cell.property = property
            
            return cell
        }
        return UITableViewCell()
    }
    
}


extension HotelsViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        guard let propertyPickerData = propertyPickerData else { return 0 }
        return propertyPickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        guard let propertyPickerData = propertyPickerData else { return 0 }
        return propertyPickerData[component].count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        guard let propertyPickerData = propertyPickerData else { return nil }
        
        let componentArray = propertyPickerData[component]
        let title = componentArray[row]
        
        return title
    }
    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return pickerView.bounds.width - 40
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedProperty = properties[row]
    }
}

