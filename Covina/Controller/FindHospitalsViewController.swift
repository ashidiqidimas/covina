//
//  ViewController.swift
//  Covina
//
//  Created by Dimas on 22/07/21.
//

import UIKit

class FindHospitalsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
	
	@IBOutlet weak var scrollView: UIScrollView!
	@IBOutlet weak var provincesTableView: UITableView!
	@IBOutlet weak var provinceTableViewHeight: NSLayoutConstraint!
	
	var provinces = [Province]()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		provincesTableView.dataSource = self
		provincesTableView.delegate = self
		provincesTableView.register(UINib(nibName: "CustomTableViewCell", bundle: nil), forCellReuseIdentifier: "customTableViewCell")
		
		provincesTableView.alwaysBounceVertical = false
		addRefreshControl(to: scrollView)
		if let thisTabBar = self.tabBarController {
			customizeTabbar(for: thisTabBar)
		}
		self.navigationController?.navigationBar.shadowImage = UIImage()

	}
	
	 override func viewDidAppear(_ animated: Bool) {
		getProvince()
		provinceTableViewHeight.constant = CGFloat((Double(provinces.count) * 124.0) + 8)
	}
	
	func customizeTabbar(for thisTabBar: UITabBarController) {
		let border = thisTabBar.tabBar.layer
		border.borderWidth = 1.2
		border.borderColor = #colorLiteral(red: 0.9411764706, green: 0.9411764706, blue: 0.9411764706, alpha: 1)
	}
	
	func addRefreshControl(to scrollView: UIScrollView) {
		scrollView.refreshControl = UIRefreshControl()
		scrollView.refreshControl?.addTarget(self, action: #selector(didScrollToRefresh), for: .valueChanged)
	}
	
	@objc func didScrollToRefresh() {
		getProvince()

		DispatchQueue.main.async {
			self.scrollView.refreshControl?.endRefreshing()
		}
	}

	// MARK: - Fetching Data
	func parseProvinces(json: Data) {
		let decoder = JSONDecoder()
		
		if let jsonProvinces = try? decoder.decode(Provinces.self, from: json) {
			provinces = jsonProvinces.provinces
			provinces.sort{$0.name < $1.name}
		}
	}
	
	func getProvince() {
		let urlString = "https://rs-bed-covid-api.vercel.app/api/get-provinces"
		
		if let url = URL(string: urlString) {
			if let data = try? Data(contentsOf: url) {
				parseProvinces(json: data)
				provincesTableView.reloadData()
			}
		}
	}
	
	// MARK: - UITableDataSourse Methods
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return provinces.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		if let cell = tableView.dequeueReusableCell(withIdentifier: "customTableViewCell", for: indexPath) as? CustomTableViewCell {
			let province = provinces[indexPath.row]
			cell.locationLabel.text = province.name
			if let image = UIImage(named: province.name) {
				cell.locationImage.image = image
			} else {
				cell.locationImage.image = UIImage(named: "Location Pin")!
			}
			return cell
		} else {
			return UITableViewCell()
		}
	}
	
	// MARK: - UITableViewDelegate Methods
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		
		let storyboard = UIStoryboard(name: "Main", bundle: nil)
		let selectProvinceView = storyboard.instantiateViewController(withIdentifier: "selectCitiesViewController") as? SelectCitiesViweController
		
		let province = provinces[indexPath.row]
		selectProvinceView?.provinceName = province.name
		selectProvinceView?.provinceId = province.id
		
		self.navigationController?.pushViewController(selectProvinceView!, animated: true)
	}
}

