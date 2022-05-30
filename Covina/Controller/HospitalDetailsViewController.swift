//
//  HospitalDetailsViewController.swift
//  Covina
//
//  Created by Dimas on 26/07/21.
//

import UIKit
import SafariServices

class HospitalDetailsViewController: UIViewController, UITableViewDataSource {

	@IBOutlet weak var phoneLabel: UILabel!
	@IBOutlet weak var addressLabel: UILabel!
	@IBOutlet weak var bedTableView: UITableView!
	
	var hospitalId = ""
	var hospitalName = ""
	var hospital: HospitalDetail?
	var mapsString = ""
	
	override func viewDidLoad() {
        super.viewDidLoad()
		
		preventLargeTitleCollapsing()
		
		self.navigationItem.title = hospitalName
		bedTableView.dataSource = self
		bedTableView.register(UINib(nibName: "bedDetailTableViewCell", bundle: nil), forCellReuseIdentifier: "bedDetailTableViewCell")
    }
	
	override func viewDidAppear(_ animated: Bool) {
		getHospitalDetails()
	}
	
	@IBAction func mapsButtonPressed(_ sender: UIButton) {
		getMapsUrl()
		
		let mapsVc = SFSafariViewController(url: URL(string: mapsString)!)
		present(mapsVc, animated: true, completion: nil)
	}
	
	private func preventLargeTitleCollapsing() {
		let dummyView = UIView()
		view.addSubview(dummyView)
		view.sendSubviewToBack(dummyView)
	}

	
	// MARK: - Fetching Data
	
	func parseMapsUrl(json: Data) {
		let decoder = JSONDecoder()
		
		do {
			let jsonMaps = try decoder.decode(Maps.self, from: json)
			mapsString = jsonMaps.data.gmaps
		
		} catch {
			print("Data loading fails with error:", error)
		}
	}
	
	func getMapsUrl() {
		let urlString = "https://rs-bed-covid-api.vercel.app/api/get-hospital-map?hospitalid=\(hospitalId)"
		if let url = URL(string: urlString) {
			if let data = try? Data(contentsOf: url) {
				parseMapsUrl(json: data)
			}
		}
	}
	
	func parseHospital(json: Data) {
		let decoder = JSONDecoder()
		
		do {
			let jsonHospital = try decoder.decode(HospitalDetails.self, from: json)
			hospital = jsonHospital.data
			phoneLabel.text = hospital?.phone
			addressLabel.text = hospital?.address
			
			bedTableView.reloadData()
			
		} catch {
			print("Data loading fails with error:", error)
		}
	}
	
	func getHospitalDetails() {
		let urlString = "https://rs-bed-covid-api.vercel.app/api/get-bed-detail?hospitalid=\(hospitalId)&type=1"
		if let url = URL(string: urlString) {
			if let data = try? Data(contentsOf: url) {
				parseHospital(json: data)
			}
		}
	}
	
	// MARK: - UITableDataSource
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return hospital?.bedDetail.count ?? 0
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

		if let cell = tableView.dequeueReusableCell(withIdentifier: "bedDetailTableViewCell", for: indexPath) as? BedDetailTableViewCell {
			
			cell.titleLabel.text = hospital!.bedDetail[indexPath.row].stats.title
			cell.bedLeft.text = "\(hospital!.bedDetail[indexPath.row].stats.bed_available)"
			cell.lastUpdated.text = hospital!.bedDetail[indexPath.row].time

			return cell
		} else {
			return UITableViewCell()
		}
	}
 
}
