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
class HotelsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, HotelHeaderTableViewCellDelegate, ChartViewDelegate {
   
 
    
    @IBOutlet weak var lineChartView: LineChartView!
    
    
    
    func toggleSection(_ header: HotelHeaderTableViewCell, section: Int) {
        let collapsed = !sections[section].isExpanded

        // Toggle collapse
        sections[section].isExpanded = collapsed
        header.setCollapsed(collapsed)

        // Adjust the height of the rows inside the section
        firsttableView.beginUpdates()
        for i in 0 ..< sections[section].names.count {
            let indexPath = IndexPath(item: i, section: 0)
            firsttableView.reloadRows(at: [indexPath], with: .top)
        }
        firsttableView.endUpdates()
    }
  
    var sections = [MockHotelNames]()
    var toggleArrow: Bool?
    
    @IBOutlet weak var firsttableView: UITableView!
    @IBOutlet weak var propertiesTableView: UITableView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sections = [ MockHotelNames(type: "Hotels", names: ["Mariott Hotel", "Hamptin In", "Ibis Hotel"], isExpanded: false)
        ]
        setData()
        // Line Chart Implementation
        lineChartView.rightAxis.enabled = false
//        let yAxis = lineChartView.leftAxis
//        yAxis.labelFont = .boldSystemFont(ofSize: 8)
//        yAxis.setLabelCount(6, force: false)
//        yAxis.labelTextColor = .white
//        yAxis.axisLineColor = .white
//        yAxis.labelPosition = .outsideChart
//        lineChartView.xAxis.labelPosition = .bottom
        lineChartView.animate(xAxisDuration: 2.5)
        // Ends
        firsttableView.delegate = self
        firsttableView.dataSource = self
        propertiesTableView.delegate = self
        propertiesTableView.dataSource = self
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
        let set1 = LineChartDataSet(entries: yValue, label: "Impact Statistics")
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
    
    let yValue: [ChartDataEntry] = [
        ChartDataEntry(x: 0.0, y: 10.0),
        ChartDataEntry(x: 1.0, y: 5.0),
        ChartDataEntry(x: 2.0, y: 7.0),
        ChartDataEntry(x: 3.0, y: 5.0),
        ChartDataEntry(x: 4.0, y: 10.0),
        ChartDataEntry(x: 5.0, y: 6.0),
        ChartDataEntry(x: 6.0, y: 5.0),
        ChartDataEntry(x: 7.0, y: 7.0),
        ChartDataEntry(x: 8.0, y: 8.0),
        ChartDataEntry(x: 9.0, y: 12.0),
        ChartDataEntry(x: 10.0, y: 13.0),
        ChartDataEntry(x: 11.0, y: 5.0),
        ChartDataEntry(x: 12.0, y: 7.0),
        ChartDataEntry(x: 13.0, y: 3.0),
        ChartDataEntry(x: 14.0, y: 15.0),
        ChartDataEntry(x: 15.0, y: 6.0),
        ChartDataEntry(x: 16.0, y: 6.0),
        ChartDataEntry(x: 17.0, y: 7.0),
        ChartDataEntry(x: 18.0, y: 3.0),
        ChartDataEntry(x: 19.0, y: 10.0),
        ChartDataEntry(x: 20.0, y: 12.0),
         ChartDataEntry(x: 21.0, y: 15.0),
        ChartDataEntry(x: 22.0, y: 17.0),
        ChartDataEntry(x: 23.0, y: 15.0),
        ChartDataEntry(x: 24.0, y: 10.0),
        ChartDataEntry(x: 25.0, y: 10.0),
        ChartDataEntry(x: 26.0, y: 10.0),
        ChartDataEntry(x: 27.0, y: 17.0),
  
    ]
    
    // TableView Section
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].names.count
        
       
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return sections[(indexPath as NSIndexPath).section].isExpanded ? 0 : 44.0
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerCellIdentifier = "HotelCell"
           let headerCell = tableView.dequeueReusableCell(withIdentifier: headerCellIdentifier) as? HotelHeaderTableViewCell

        headerCell?.textLabel?.text = sections[section].type
        headerCell?.textLabel?.font = UIFont(name: "Euphemia UCAS", size: 20)
        headerCell?.setCollapsed(sections[section].isExpanded)
        headerCell?.imageView?.image = disclosureIndicator.image
        if headerCell?.isSelected == true  {
            self.toggleArrow?.toggle()
            headerCell?.imageView?.image = disclosureIndicator.image ?? disclosureIndicatorDown.image
        }
        headerCell?.section = section
        headerCell?.delegate = self

           return headerCell
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == firsttableView,
            let cell = tableView.dequeueReusableCell(withIdentifier: "HotelCell") as? HotelHeaderTableViewCell {
         cell.textLabel?.text = sections[indexPath.section].names[indexPath.row]
            cell.textLabel?.font = UIFont(name: "Euphemia UCAS", size: 17)
        return cell
    }
    if tableView == propertiesTableView,
            let cell = tableView.dequeueReusableCell(withIdentifier: "PropertiesCell") as? PropertiesTableViewCell {
        cell.textLabel?.text = sections[indexPath.section].names[indexPath.row]
        cell.textLabel?.font = UIFont(name: "Euphemia UCAS", size: 17)
        
        return cell
        }
        return UITableViewCell()
    }
    
    func toggleSection(header: ExpandableHeaderView, section: Int) {
        // this is the toggle system for expanding the view and collapsing.
        sections[section].isExpanded = !sections[section].isExpanded
    
        firsttableView.beginUpdates()
        for i in 0 ..< sections[section].names.count {
            firsttableView.reloadRows(at: [IndexPath(row: i, section: section)], with: .automatic)
        }
        firsttableView.endUpdates()
    }
}



