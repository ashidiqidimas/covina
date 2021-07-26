//
//  SelectHospitalViewController.swift
//  Covina
//
//  Created by Dimas on 26/07/21.
//

import UIKit

class SelectHospitalViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

	@IBOutlet weak var hospitalsTableView: UITableView!
	@IBOutlet weak var scrollView: UIScrollView!
	@IBOutlet weak var hospitalsTableViewHeight: NSLayoutConstraint!
	
	var cities = [City]()
	var cityName = ""
	var provinceId = ""
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		hospitalsTableView.dataSource = self
		hospitalsTableView.delegate = self
		
		hospitalsTableView.register(UINib(nibName: "HospitalTableViewCell", bundle: nil), forCellReuseIdentifier: "hospitalTableViewCell")
		hospitalsTableView.alwaysBounceVertical = false
		hospitalsTableView.allowsSelection = true
		
		self.navigationItem.title = provinceName
		addRefreshControl(to: scrollView)
		navigationController?.navigationBar.layer.borderWidth = 0
	}
	
	override func viewDidAppear(_ animated: Bool) {
		getCities()
		hospitalsTableViewHeight.constant = CGFloat((Double(cities.count) * 124.0) + 8)
		
	}
	
	func addRefreshControl(to scrollView: UIScrollView) {
		scrollView.refreshControl = UIRefreshControl()
		scrollView.refreshControl?.addTarget(self, action: #selector(didScrollToRefresh), for: .valueChanged)
	}
	
	@objc func didScrollToRefresh() {
		// Update your content…
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
				hospitalsTableView.reloadData()
				print(cities)
				//				print(urlString)
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
			if let image = UIImage(named: "Hospital") {
				cell.locationImage.image = image
			}
			return cell
		} else {
			return UITableViewCell()
		}
	}
	
	// MARK: - UITableViewDelegate Methods
//	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//
//		print("clicked")
//
//		let storyboard = UIStoryboard(name: "Main", bundle: nil)
//		let selectHospitalView = storyboard.instantiateViewController(withIdentifier: "selectHospitalViewController") as? SelectHospitalViewController
//
//		//		let province = provinces[indexPath.row]
//		//		selectProvinceView?.provinceName = province.name
//		//		selectProvinceView?.provinceId = province.id
//
//		self.navigationController?.pushViewController(selectHospitalView!, animated: true) // TODO: - nanti ubah ke error page
//		print("udah")
//	}

}
