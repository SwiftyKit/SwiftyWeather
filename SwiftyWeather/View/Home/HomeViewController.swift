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
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var currentSummaryLabel: UILabel!
    @IBOutlet weak var currentWindLabel: UILabel!
    @IBOutlet weak var currentVisibilityLabel: UILabel!
    @IBOutlet weak var currentHumidityLabel: UILabel!
    @IBOutlet weak var currentTemperatureLabel: UILabel!
    @IBOutlet weak var loadingView: UIView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var loadingLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    private lazy var currentLocation: ForecastLocation = {
        let location = ForecastLocation()
        location.delegate = self
        return location
    }()
    var weatherReport: WeatherReport? {
        didSet {
            self.updateUI()
        }
    }
    let viewModel:HomeViewModel = HomeViewModel()
    
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
        currentLocation.startLocation()
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
        loadingLabel.text = "Retrieving weather data..."
        activityIndicator.startAnimating()
    }
    
    func finishLoading() {
        loadingView.isHidden = true
        activityIndicator.stopAnimating()
    }
    
    func updateUI() {
        self.iconImage.kf.setImage(with: weatherReport?.currently?.iconImageURL)
        self.currentTemperatureLabel.text = "\(weatherReport?.currently?.temperature?.roundString ?? "")°"
        self.currentSummaryLabel.text = weatherReport?.currently?.summary ?? ""
        self.currentWindLabel.text = weatherReport?.currently?.windSpeed ?? ""
        self.currentVisibilityLabel.text = weatherReport?.currently?.visibility ?? ""
        self.currentHumidityLabel.text = weatherReport?.currently?.humidity ?? ""
        self.locationLabel.text = weatherReport?.timezone ?? ""
        self.collectionView.reloadData()
    }
    

}
 


// MARK: UICollectionViewDelegate UICollectionViewDataSource
extension HomeViewController: UICollectionViewDelegate,UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return weatherReport?.daily?.count ?? 0
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

// MARK: - lsLocationDelegate

extension HomeViewController: ForecastLocationDelegate {
    func locationDidDenied() {
        //Don't allow
        loadingView.isHidden = false
        loadingLabel.text = "Unable to access your location.  Please enable location services in Settings."
        activityIndicator.stopAnimating()
        
    }
    func locationDidAuthorized() {
        //Allow, Refresh weather list to show current user location's weather.
        self.startLoading()
    }
    func locationDidFound(longitude: String, latitude: String) {
        guard let latitude = Double(latitude), let longitude = Double(longitude) else { return }
        
        let coordinate = Coordinates(latitude: latitude, longitude: longitude)
        //let coordinate = Coordinates(latitude: 37.8267, longitude: -122.4233)  //for test
        viewModel.fetchWeather(with: coordinate) {[weak self]  (weatherReport) in
            if let weatherReport = weatherReport {
                self?.weatherReport = weatherReport
            }
            self?.finishLoading()
        }
        
    }
    func locationDidGeocode(city: String, state: String) {
        loadingLabel.text = "\(state),\(city)"
    }
}

