//
//  HotelsViewController.swift
//  labs-ios-starter
//
//  Created by Bharat Kumar on 10/7/20.
//  Copyright © 2020 Spencer Curtis. All rights reserved.
//

import UIKit
import SwiftUI
class HotelsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, HotelHeaderTableViewCellDelegate {
   
    func toggleSection(_ header: HotelHeaderTableViewCell, section: Int) {
        let collapsed = !sections[section].isExpanded

        // Toggle collapse
        sections[section].isExpanded = collapsed
        header.setCollapsed(collapsed)

        // Adjust the height of the rows inside the section
        tableView.beginUpdates()
        for i in 0 ..< sections[section].names.count {
            let indexPath = IndexPath(item: i, section: 0)
            tableView.reloadRows(at: [indexPath], with: .top)
        }
        tableView.endUpdates()
    }
  
    var sections = [MockHotelNames]()
    
    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sections = [ MockHotelNames(type: "Hotels", names: ["Mariott Hotel", "Hamptin In", "Ibis Hotel"], isExpanded: false)
        ]
        // set a background color so we can easily see the table
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    
    
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
           let headerCell = tableView.dequeueReusableCell(withIdentifier: headerCellIdentifier) as! HotelHeaderTableViewCell

        headerCell.textLabel?.text = sections[section].type
           headerCell.setCollapsed(sections[section].isExpanded)

           headerCell.section = section
           headerCell.delegate = self

           return headerCell
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "HotelCell") else { return UITableViewCell() }
        cell.textLabel?.text = sections[indexPath.section].names[indexPath.row]
        return cell
    }
    
    func toggleSection(header: ExpandableHeaderView, section: Int) {
        // this is the toggle system for expanding the view and collapsing.
        sections[section].isExpanded = !sections[section].isExpanded
    
        tableView.beginUpdates()
        for i in 0 ..< sections[section].names.count {
            tableView.reloadRows(at: [IndexPath(row: i, section: section)], with: .automatic)
        }
        tableView.endUpdates()
    }
}






struct HotelsViewController_Previews: PreviewProvider {
    static var previews: some View {
        /*@START_MENU_TOKEN@*/Text("Hello, World!")/*@END_MENU_TOKEN@*/
    }
}
