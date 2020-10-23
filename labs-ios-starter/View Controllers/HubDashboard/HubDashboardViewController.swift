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

    // MARK: - Properties
    var isAdmin: Bool = false
    var reports: [ProductionReport] = []
    
    let controller = BackendController.shared
    
    // Button
    private let newReportButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("New Production Report", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor(named: "ESB Blue")
        button.heightAnchor.constraint(equalToConstant: 50.0).isActive = true
        button.layer.cornerRadius = 8
        button.addTarget(self, action: #selector(newReport), for: .touchUpInside)
        return button
    }()
    
    private let productionReportsLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Production Reports"
        label.font = UIFont.boldSystemFont(ofSize: 24)
        return label
    }()
    
    // TODO: Implement impact statistics
    private let impactStatisticsLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Impact Statistics"
        label.font = UIFont.boldSystemFont(ofSize: 24)
        return label
    }()
    
    // Views
    // TODO: Implement impact statistics
    lazy var impactStatisticsView = UIView()
    
    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: createCollectionViewLayout())
    
    // Stack Views
    private lazy var statisticsStack: UIStackView = {
        let statisticsStack = UIStackView(arrangedSubviews: [impactStatisticsLabel, impactStatisticsView])
        statisticsStack.alignment = .leading
        statisticsStack.spacing = padding
        statisticsStack.axis = .vertical
        statisticsStack.distribution = .fill
        return statisticsStack
    }()
    
    private lazy var reportStack: UIStackView = {
        let reportStack = UIStackView(arrangedSubviews: [productionReportsLabel, collectionView, newReportButton])
        reportStack.alignment = .fill
        reportStack.spacing = padding
        reportStack.axis = .vertical
        reportStack.distribution = .fill
        return reportStack
    }()
    
    // Data Source
    private var dataSource: UICollectionViewDiffableDataSource<Section, ProductionReport>?
    
    // Constraints
    private let padding: CGFloat = 10
    private let cornerRadius: CGFloat = 8
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchReports()
        collectionView.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if controller.productionReportNeedsUpdate {
            reports = []
            fetchReports()
        }
    }
    
    // MARK: - Actions
    @objc func viewReport() {
        performSegue(withIdentifier: "ViewReportSegue", sender: self)
    }
    @objc func newReport() {
        performSegue(withIdentifier: "NewReportSegue", sender: self)
    }
    
    // MARK: - Methods
    
    func updateViews() {
        if controller.loggedInUser.role == .HUB_ADMIN {
            isAdmin = true
            newReportButton.isHidden = false
        } else {
            isAdmin = false
            newReportButton.isHidden = true
        }
        setUp()
    }
    
    // Collection View
    private func createCollectionViewLayout() -> UICollectionViewLayout {
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
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    // Collection View Data Source
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
                self.reports = self.reports.sorted(by: { $0.date > $1.date })
                
                DispatchQueue.main.async {
                    self.setUpDataSource()
                }
                    self.controller.productionReportNeedsUpdate = false
            }
        }
        updateViews()
    }
    
    // View
    func setUp() {
        view.backgroundColor = .systemGray6
        view.clipsToBounds = true

        view.addSubview(statisticsStack)
        view.addSubview(reportStack)

        statisticsStack.translatesAutoresizingMaskIntoConstraints = false
        reportStack.translatesAutoresizingMaskIntoConstraints = false
        setUpConstraints()
    }
    
   
    func setUpConstraints() {
        view.preservesSuperviewLayoutMargins = true
        let leading = view.safeAreaLayoutGuide.leadingAnchor
        let top = view.safeAreaLayoutGuide.topAnchor
        let bottom = view.safeAreaLayoutGuide.bottomAnchor
        let width = view.safeAreaLayoutGuide.widthAnchor
        let height = view.safeAreaLayoutGuide.heightAnchor

        NSLayoutConstraint.activate([
                                        statisticsStack.topAnchor.constraint(equalTo: top, constant: padding),
                                        statisticsStack.leadingAnchor.constraint(equalTo: leading, constant: padding),
                                        statisticsStack.bottomAnchor.constraint(equalTo: reportStack.topAnchor, constant: -padding),
                                        reportStack.leadingAnchor.constraint(equalTo: leading, constant: padding),
                                        reportStack.bottomAnchor.constraint(equalTo: bottom, constant: -padding),
                                        reportStack.heightAnchor.constraint(equalTo: height, multiplier: 0.7),
            statisticsStack.widthAnchor.constraint(equalTo: width, constant: -20),
            reportStack.widthAnchor.constraint(equalTo: width, constant: -20)
        ])
        setUpCollectionView()
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "NewReportSegue" {
            guard let productionReportVC = segue.destination as? ProductionReportDetailViewController else { return }
            productionReportVC.isAdmin = isAdmin
            productionReportVC.isEditingReport = true
            productionReportVC.isNewReport = true
        } else if segue.identifier == "ViewReportSegue" {
            guard let productionReportVC = segue.destination as? ProductionReportDetailViewController else { return }
            guard let selectedIndexPaths = collectionView.indexPathsForSelectedItems else { return }
            let indexPath = selectedIndexPaths[0]
            productionReportVC.report = reports[indexPath.row]
            productionReportVC.isAdmin = isAdmin
            productionReportVC.isEditingReport = false
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

