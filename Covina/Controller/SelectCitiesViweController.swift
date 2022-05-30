//
//  SelectCitiesViweController.swift
//  Covina
//
//  Created by Dimas on 26/07/21.
//

import UIKit

class SelectCitiesViweController: UIViewController, UITableViewDataSource, UITableViewDelegate {
	
	@IBOutlet weak var citiesTableView: UITableView!
	@IBOutlet weak var citiesTableViewHeight: NSLayoutConstraint!
	@IBOutlet weak var scrollView: UIScrollView!
	
	var cities = [City]()
	var provinceName = ""
	var provinceId = ""
	
	override func viewDidLoad() {
        super.viewDidLoad()
		
		citiesTableView.dataSource = self
		citiesTableView.delegate = self
		
		citiesTableView.register(UINib(nibName: "CustomTableViewCell", bundle: nil), forCellReuseIdentifier: "customTableViewCell")
		citiesTableView.alwaysBounceVertical = false
		citiesTableView.allowsSelection = true
		
		self.navigationItem.title = provinceName
		addRefreshControl(to: scrollView)
		navigationController?.navigationBar.layer.borderWidth = 0
    }
	
	override func viewDidAppear(_ animated: Bool) {
		getCities()
		if cities.count > 4 {
			citiesTableViewHeight.constant = CGFloat((Double(cities.count) * 124.0) + 8)
		}
		
	}
	
	func addRefreshControl(to scrollView: UIScrollView) {
		scrollView.refreshControl = UIRefreshControl()
		scrollView.refreshControl?.addTarget(self, action: #selector(didScrollToRefresh), for: .valueChanged)
	}
	
	@objc func didScrollToRefresh() {
		getCities()
		
		DispatchQueue.main.async {
			self.scrollView.refreshControl?.endRefreshing()
		}
	}

	// MARK: - Fetching Data
	func parseCities(json: Data) {
		let decoder = JSONDecoder()
		
		if let jsonCities = try? decoder.decode(Cities.self, from: json) {
			cities = jsonCities.cities
			cities.sort{$0.name < $1.name}
		}
	}

	func getCities() {
		let urlString = "https://rs-bed-covid-api.vercel.app/api/get-cities?provinceid=\(provinceId)"
		if let url = URL(string: urlString) {
			if let data = try? Data(contentsOf: url) {
				parseCities(json: data)
				citiesTableView.reloadData()
			}
		}
	}
	
	// MARK: - UITableViewDataSource
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		cities.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		if let cell = tableView.dequeueReusableCell(withIdentifier: "customTableViewCell", for: indexPath) as? CustomTableViewCell {
			let city = cities[indexPath.row]
			cell.locationLabel.text = city.name
			if let image = UIImage(named: "Location Pin") {
				cell.locationImage.image = image
			} 
			return cell
		} else {
			return UITableViewCell()
		}
	}
	
	// MARK: - UITableViewDelegate Methods
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		
		let storyboard = UIStoryboard(name: "Main", bundle: nil)
		let selectHospitalView = storyboard.instantiateViewController(withIdentifier: "selectHospitalViewController") as? SelectHospitalViewController

		let city = cities[indexPath.row]
		selectHospitalView?.provinceId = provinceId
		selectHospitalView?.cityId = city.id
		selectHospitalView?.cityName = city.name
		
		self.navigationController?.pushViewController(selectHospitalView!, animated: true)

	}
}
