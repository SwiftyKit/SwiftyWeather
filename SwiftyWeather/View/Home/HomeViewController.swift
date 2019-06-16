//
//  HomeViewController.swift
//  SwiftyWeather
//
//  Created by lingzhao on 2019/6/15.
//  Copyright © 2019 apple. All rights reserved.
//

import UIKit
import Kingfisher

class HomeViewController: UIViewController {
    
    @IBOutlet weak var iconImage: UIImageView!
    @IBOutlet weak var currentSummaryLabel: UILabel!
    @IBOutlet weak var currentWindLabel: UILabel!
    @IBOutlet weak var currentVisibilityLabel: UILabel!
    @IBOutlet weak var currentHumidityLabel: UILabel!
    @IBOutlet weak var currentTemperatureLabel: UILabel!
    @IBOutlet weak var loadingView: UIView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    let viewModel:HomeViewModel = HomeViewModel()
    var weatherReport: WeatherReport? {
        didSet {
            self.updateUI()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = "Forecast"
        setupUI()
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    //MARK: actions
    
    @objc func rightClick() {
        
        self.startLoading()
        viewModel.fetchWeather(with: Coordinates(latitude: 37.8267, longitude: -122.4233)) {[weak self]  (weatherReport) in
            if let weatherReport = weatherReport {
                self?.weatherReport = weatherReport
            }
            self?.finishLoading()
        }
    }
    
    
    
    
    //MARK: network request
    
    
    //MARK: view update
    
    private func setupUI() {
        let rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "refresh"), style: .plain, target: self, action: #selector(rightClick))
        navigationItem.rightBarButtonItem = rightBarButtonItem
        
        /// register xib
        collectionView.register(UINib(nibName: "ForecastCollectionViewCell", bundle: Bundle.main), forCellWithReuseIdentifier: ForecastCollectionViewCell.cellReuseID)
        
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        //        layout.sectionInset = UIEdgeInsetsMake(-0.1, -0.1, -0.1, -0.1)
        layout.itemSize = CGSize(width: ScreenWidth / 4 - 7, height: collectionView.bounds.height)
        layout.scrollDirection = .horizontal
        collectionView.collectionViewLayout = layout
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    func startLoading() {
        loadingView.isHidden = false
        activityIndicator.startAnimating()
    }
    
    func finishLoading() {
        loadingView.isHidden = true
        activityIndicator.stopAnimating()
        collectionView.flashScrollIndicators()
    }
    
    func updateUI() {
        self.iconImage.kf.setImage(with: weatherReport?.currently?.iconImageURL)
        self.currentTemperatureLabel.text = "\(weatherReport?.currently?.temperature?.roundString ?? "")°"
        self.currentSummaryLabel.text = weatherReport?.currently?.summary ?? ""
        self.currentWindLabel.text = weatherReport?.currently?.windSpeed ?? ""
        self.currentVisibilityLabel.text = weatherReport?.currently?.visibility ?? ""
        self.currentHumidityLabel.text = weatherReport?.currently?.humidity ?? ""
        
        self.collectionView.reloadData()
    }
    

}
 


// MARK: UICollectionViewDelegate UICollectionViewDataSource
extension HomeViewController: UICollectionViewDelegate,UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return weatherReport?.daily?.count ?? 7
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ForecastCollectionViewCell.cellReuseID, for: indexPath) as! ForecastCollectionViewCell
        cell.model = weatherReport?.daily?[indexPath.row]
        cell.layer.borderWidth = 0.5
        cell.layer.borderColor = UIColor(hex: 0x303F9F, transparency: 1.0)?.cgColor
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let dailyWeather = weatherReport?.daily?[indexPath.row] {
            let viewController = DetailViewController(nibName: nil, bundle: nil)
            viewController.dailyWeather = dailyWeather
            self.navigationController?.pushViewController(viewController, animated: true)
        }
    }
}
