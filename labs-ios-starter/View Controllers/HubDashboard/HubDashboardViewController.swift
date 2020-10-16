//
//  HubDashboardViewController.swift
//  labs-ios-starter
//
//  Created by Christy Hicks on 10/6/20.
//  Copyright © 2020 Spencer Curtis. All rights reserved.
//

import UIKit

class HubDashboardViewController: UIViewController {
    enum Section {
        case main
    }
    
    // MARK: - Outlets
//    @IBOutlet var newReportButton: UIButton!
    
    // MARK: - Properties
    var isAdmin: Bool = false
    var reports: [ProductionReport] = []
    
    let controller = BackendController.shared
    
    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
    private var dataSource: UICollectionViewDiffableDataSource<Section, ProductionReport>?
    
    private let padding: CGFloat = 12
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchReports()
        setUpCollectionView()
        collectionView.delegate = self
        
        if controller.loggedInUser.role == .HUB_ADMIN {
            isAdmin = true
//            newReportButton.isHidden = false
        } else {
            isAdmin = false
//            newReportButton.isHidden = true
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if controller.productionReportNeedsUpdate {
            reports = []
            fetchReports()
        }
    }
    
    @objc func viewReport() {
        performSegue(withIdentifier: "ViewReportSegue", sender: self)
    }
    
    
    private func createLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(50))
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: itemSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = padding
        section.contentInsets = .init(top: padding, leading: padding, bottom: padding, trailing: padding)
        
        return UICollectionViewCompositionalLayout(section: section)
    }
    
    private func setUpCollectionView() {
        collectionView.register(ReportCell.self, forCellWithReuseIdentifier: String(describing: ReportCell.self))
        collectionView.backgroundColor = .white
        
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
                                        collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
                                        collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
                                        collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
                                        collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func setUpDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, ProductionReport>(collectionView: collectionView) {
            (collectionView, indexPath, report) -> UICollectionViewCell? in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: ReportCell.self), for: indexPath) as? ReportCell else {
                fatalError("Could not cast cell as \(ReportCell.self)")
            }
            cell.report = report
            return cell
        }
        collectionView.dataSource = dataSource
        
        var snapshot = NSDiffableDataSourceSnapshot<Section, ProductionReport>()
        snapshot.appendSections([.main])
        snapshot.appendItems(reports)
        dataSource?.apply(snapshot)
    }
    
    func fetchReports() {
        if let hubId = controller.loggedInUser.hub?.id {
            controller.productionReportsByHubId(hubId: hubId) { (error) in
                if let error = error {
                    NSLog("\(error): Error occured during initial fetch of production reports.")
                }
                for report in self.controller.productionReports.values {
                    self.reports.append(report)
                }
                DispatchQueue.main.async {
                    self.setUpDataSource()
                }
                    self.controller.productionReportNeedsUpdate = false
            }
        } 
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddProductionReportSegue" {
            guard let productionReportVC = segue.destination as? ProductionReportDetailViewController else { return }
            productionReportVC.isAdmin = isAdmin
            productionReportVC.isEditing = true
            productionReportVC.isNewReport = true
        } else if segue.identifier == "ViewReportSegue" {
            guard let productionReportVC = segue.destination as? ProductionReportDetailViewController else { return }
            guard let selectedIndexPaths = collectionView.indexPathsForSelectedItems else { return }
            let indexPath = selectedIndexPaths[0]
            productionReportVC.report = reports[indexPath.row]
            productionReportVC.isAdmin = isAdmin
            productionReportVC.isEditing = false
            productionReportVC.isNewReport = false
        }
    }
}

extension HubDashboardViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        guard let dataSource = dataSource else { return false }
        
        if collectionView.indexPathsForSelectedItems?.contains(indexPath) ?? false {
            collectionView.deselectItem(at: indexPath, animated: true)
        } else {
            collectionView.selectItem(at: indexPath, animated: true, scrollPosition: [])
        }
        dataSource.refresh()
        
        return false
    }
}

extension UICollectionViewDiffableDataSource {
    func refresh(completion: (() -> Void)? = nil) {
        self.apply(self.snapshot(), animatingDifferences: true, completion: completion)
    }
}

