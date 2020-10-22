//
//  ReportImageCollectionView.swift
//  labs-ios-starter
//
//  Created by Christy Hicks on 10/16/20.
//  Copyright © 2020 Spencer Curtis. All rights reserved.
//

import UIKit

class ReportImageCollectionView: UICollectionView {
    enum Section {
        case main
    }
    
    // MARK: - Properties
    var reportImageStrings: [String] = []
    var reportImageURLs: [URL] = []
    var images: [UIImage] = []
    var report: ProductionReport? {
        didSet {
            addImagesToStringArray()
            convertStringArrayToURLs()
            // Attempt to make it wait to fetch all images before setting up the datasource.
            // It still moves on to set up the data source before fetchImages is complete.
            
//            performSelector(onMainThread: #selector(fetchImages), with: nil, waitUntilDone: true)
            
                // Third message printed shows dummy image: Images: [<UIImage:0x6000025dc510 named(main: ESB Logo) {200, 200}>]
//            print("Images: \(images)")

            setUpDataSource()
        }
    }
    
    // MARK: - Methods
    func convertStringArrayToURLs() {
        for string in reportImageStrings {
            var shortenedString = string
            // Sometimes the results fetched from the API are contained in brackets. Suspect issue with mock data in API.
            if shortenedString.hasPrefix("[") {
                
                shortenedString.removeFirst()
            }
            if shortenedString.hasSuffix("]") {
                shortenedString.removeLast()
            }
            
            guard let url = URL(string: shortenedString) else { return }
            reportImageURLs.append(url)
        }
    }
    
    func addImagesToStringArray() {
        if let soapPhotos = report?.soapPhotos {
            reportImageStrings.append(contentsOf: soapPhotos)
        }
        if let media = report?.media {
            reportImageStrings.append(contentsOf: media)
        }
    }
    
    @objc func fetchImages() {
        for url in reportImageURLs {
            let image = downloadImage(from: url)
            // If the images don't fetch correctly, use a fake image instead, but limit it to only one copy of the fake image.
            if image == UIImage(named: "ESB Logo") {
                images.append(image)
                return
            } else {
                print("Adding image \(image) to images.")
                images.append(image)
            }
        }
    }
    
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    func downloadImage(from url: URL) -> UIImage {
        var image: UIImage?
        getData(from: url) { (data, response, error) in
            guard let data = data, error == nil else {
                NSLog("Error fetching image data from url: \(url).")
                NSLog("Response: \(String(describing: response))")
                NSLog("Error: \(String(describing: error))")
                return
            }
            // Second message printed: "Download Image Returned Data: 81672 bytes"
            print("Download Image Returned Data: \(data)")

            if let newImage = UIImage(data: data) {
                // Fourth message printed
                print("Creating image from data.")
                image = newImage
            } else {
                print("Error converting data into image.")
                print("Data: \(data)")
            }
        }
        let dummyImage = UIImage(named: "ESB Logo")
        // First message printed: "The image is nil".
        print("The image is \(String(describing: image))")
        return image ?? dummyImage!
    }
    
    // MARK: - Data Source
    func setUpDataSource() {
        
        let newDataSource = UICollectionViewDiffableDataSource<Section, UIImage>(collectionView: self) {
            (collectionView, indexPath, image) -> UICollectionViewCell? in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ReportImageCell", for: indexPath) as? ReportImageCollectionViewCell else {
                fatalError("Could not cast cell as \(ReportImageCollectionViewCell.self)")
            }


            // Fifth message printed shows attempt to display dummy image: "Preparing to add image <UIImage:0x6000025dc510 named(main: ESB Logo) {200, 200}> to cell."
            print("Preparing to add image \(String(describing: image)) to cell.")
            // If I instantiate the image view first, it doesn't crash, but it doesn't show the image either.
            //            cell.reportImageView = UIImageView()
            
            // If I don't instantiate the image view first, it crashes at this point, because the image view doesn't exist yet.
            cell.reportImageView.image = image
            
            return cell
        }
        
        var snapshot = NSDiffableDataSourceSnapshot<Section, UIImage>()
        snapshot.appendSections([.main])
        snapshot.appendItems(images)
        newDataSource.apply(snapshot)
        
        self.dataSource = newDataSource
    }
    
    override var numberOfSections: Int {
        return 1
    }
    
    override func numberOfItems(inSection section: Int) -> Int {
        return reportImageURLs.count
    }
    
//     Commented out cellForItem at because my breakpoints in it were never being hit.  Having it here or not seems to make no difference.
    
        override func cellForItem(at indexPath: IndexPath) -> UICollectionViewCell? {
            let cell = dequeueReusableCell(withReuseIdentifier: "ReportImageCell", for: indexPath) as! ReportImageCollectionViewCell
            print("Attempting to download image: \(reportImageURLs[indexPath.row])")
            let image = downloadImage(from: reportImageURLs[indexPath.row])
            cell.reportImageView.image = image
            return cell
        }
}
