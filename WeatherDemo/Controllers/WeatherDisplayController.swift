//
//  WeatherDisplayController.swift
//  WeatherDemo
//
//  Created by Mike Pollard on 24/10/2019.
//  Copyright © 2019 Mike Pollard. All rights reserved.
//

import UIKit

class WeatherDisplayController: UIViewController {
    
    @IBOutlet weak var lblLatitude: UILabel!
    @IBOutlet weak var lblLongitude: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var lblUpdated: UILabel!
    
    @IBOutlet weak var topShadow: UIView!
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var loadingView: UIView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    private let weatherCell = "WeatherDataCell"
    private let weatherController = WeatherController()
    private var weatherDataPackets: [WeatherDataPacket] = []
    
    private var loadingStart: Date?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.weatherController.delegate = self
        
        self.setupTopShadow()
        self.setupLoadingView()
        self.setupTableView()
        self.configureTableView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if weatherDataPackets.count == 0, weatherController.getCoords() == nil {
            self.refresh()
        }
    }
    
    private func setupTopShadow() {
        self.topShadow.layer.shadowColor = UIColor.black.cgColor
        self.topShadow.layer.shadowRadius = 5.0
        self.topShadow.layer.shadowOpacity = 1.0
        self.topShadow.layer.shadowOffset = CGSize.zero
        self.topShadow.layer.masksToBounds = false
    }
    
    private func setupLoadingView() {
        self.loadingView.layer.borderColor = UIColor.black.cgColor
        self.loadingView.layer.borderWidth = 1.0
        
        self.loadingView.layer.cornerRadius = 10.0
    }
    
    private func setupTableView() {
        self.tableView.layer.borderColor = UIColor.black.cgColor
        self.tableView.layer.borderWidth = 1.0
        
        self.tableView.layer.shadowColor = UIColor.black.cgColor
        self.tableView.layer.shadowRadius = 5.0
        self.tableView.layer.shadowOpacity = 1.0
        self.tableView.layer.shadowOffset = CGSize.zero
        self.tableView.layer.masksToBounds = false
        
        self.tableView.layer.cornerRadius = 10.0
    }
    
    private func configureTableView() {
        self.updateTableViewHeight(animate: false)
        self.tableView.register(UINib(nibName: self.weatherCell, bundle: .main), forCellReuseIdentifier: self.weatherCell)
        self.tableView.dataSource = self
        self.tableView.delegate = self
    }
    
    private func setCoords() {
        let locationFormatter = LocationFormatter()
        (lblLatitude.text,lblLongitude.text) = self.weatherDataPackets.count > 0 ? locationFormatter.formatCoords(coords: self.weatherController.getCoords()) : ("","")
    }
    
    private func setUpdated(updated: Date?) {
        let locationFormatter = LocationFormatter()
        lblUpdated.text = self.weatherDataPackets.count > 0 ? locationFormatter.formatDate(date: updated) : "There is no valid weather data"
    }
    
    private func updateTableViewHeight(animate: Bool) {
        self.tableViewHeight.constant = CGFloat(self.weatherDataPackets.count) * self.tableView.rowHeight
        
        if animate {
            UIView.animate(withDuration: 0.3) {
                self.view.layoutIfNeeded()
            }
        }
    }
    
    private func showLoadingIndictor() {
        guard self.loadingView.alpha != 1.0 else { return }
        self.activityIndicator.startAnimating()
        UIView.animate(withDuration: 0.3) {
            self.contentView.alpha = 0.0
            self.loadingView.alpha = 1.0
        }
        self.loadingStart = Date()
    }
    
    private func hideLoadingIndicator() {
        DispatchQueue.global().async {
            if let loadingStart = self.loadingStart {
                while Date().timeIntervalSince(loadingStart) < 1 {
                    usleep(100)
                }
            }
            self.loadingStart = nil
            DispatchQueue.main.async {
                guard self.loadingView.alpha != 0.0 else { return }
                UIView.animate(withDuration: 0.3, animations: {
                    self.contentView.alpha = 1.0
                    self.loadingView.alpha = 0.0
                }) { (_) in
                    self.activityIndicator.stopAnimating()
                }
            }
        }
    }
    
    @IBAction func refresh() {
        self.showLoadingIndictor()
        self.weatherController.update()
    }
}


extension WeatherDisplayController: WeatherControllerDelegte {
    func newWeatherData(weatherData: [WeatherDataPacket], updated: Date?) {
        self.weatherDataPackets = weatherData
        DispatchQueue.main.async {
            self.hideLoadingIndicator()
            self.setCoords()
            self.setUpdated(updated: updated)
            self.updateTableViewHeight(animate: true)
            self.tableView.reloadData()
        }
    }
}


extension WeatherDisplayController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.weatherDataPackets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.weatherCell, for: indexPath)
        (cell as? WeatherDataCell)?.setup(data: self.weatherDataPackets[indexPath.row])
        return cell
    }
}
