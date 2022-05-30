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
	
	var hospitals = [Hospital]()
	var provinceId = ""
	var cityName = ""
	var cityId = ""
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		hospitalsTableView.dataSource = self
		hospitalsTableView.delegate = self
		
		hospitalsTableView.register(UINib(nibName: "HospitalTableViewCell", bundle: nil), forCellReuseIdentifier: "hospitalTableViewCell")
		hospitalsTableView.alwaysBounceVertical = false
		hospitalsTableView.allowsSelection = true
		
		self.navigationItem.title = cityName
		addRefreshControl(to: scrollView)
	}
	
	override func viewDidAppear(_ animated: Bool) {
		getHospitals()
		if hospitals.count > 7 {
			hospitalsTableViewHeight.constant = CGFloat((Double(hospitals.count) * 124.0) + 8)
		}
	}
	
	func addRefreshControl(to scrollView: UIScrollView) {
		scrollView.refreshControl = UIRefreshControl()
		scrollView.refreshControl?.addTarget(self, action: #selector(didScrollToRefresh), for: .valueChanged)
	}
	
	@objc func didScrollToRefresh() {

		getHospitals()

		DispatchQueue.main.async {
			self.scrollView.refreshControl?.endRefreshing()
		}
	}
	
	// MARK: - Fetching Data
	func parseHospitals(json: Data) {
		let decoder = JSONDecoder()
		
		if let jsonHospitals = try? decoder.decode(Hospitals.self, from: json) {
			hospitals = jsonHospitals.hospitals
			hospitals.sort{$0.name < $1.name}
		}
	}
	
	func getHospitals() {
		let urlString = "https://rs-bed-covid-api.vercel.app/api/get-hospitals?provinceid=\(provinceId)&cityid=\(cityId)&type=1"
		if let url = URL(string: urlString) {
			if let data = try? Data(contentsOf: url) {
				parseHospitals(json: data)
				hospitalsTableView.reloadData()

			}
		}
	}
	
	// MARK: - UITableViewDataSource
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		hospitals.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		if let cell = tableView.dequeueReusableCell(withIdentifier: "hospitalTableViewCell", for: indexPath) as? HospitalTableViewCell {
			
			let hospital = hospitals[indexPath.row]
			cell.availableBedLabel.text = "Bed Availability: \(hospital.bed_availability)"
			cell.hospitalNameLabel.text = hospital.name
			cell.lastUpdated.text = hospital.info
			if let image = UIImage(named: "Hospital") {
				cell.hospitalImage.image = image
			}
			
			if hospital.bed_availability == 0 {
				cell.availableBedLabel.textColor = UIColor.init(named: "Red")
			} else if hospital.bed_availability <= 5 {
				cell.availableBedLabel.textColor = UIColor.init(named: "Yellow")
			} else {
				cell.availableBedLabel.textColor = UIColor.init(named: "Green")
			}
			
			return cell
		} else {
			return UITableViewCell()
		}
	}
	
	// MARK: - UITableViewDelegate Methods
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

		let storyboard = UIStoryboard(name: "Main", bundle: nil)
		let selectedHospital = storyboard.instantiateViewController(withIdentifier: "hospitalDetailsViewController") as? HospitalDetailsViewController

		let hospital = hospitals[indexPath.row]
		selectedHospital?.hospitalId = hospital.id
		selectedHospital?.hospitalName = hospital.name
		
		self.navigationController?.pushViewController(selectedHospital!, animated: true)
	}

}
