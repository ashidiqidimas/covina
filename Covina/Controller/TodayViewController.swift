//
//  TodayViewController.swift
//  Covina
//
//  Created by Dimas on 23/07/21.
//

import UIKit

class TodayViewController: UIViewController {
	
	@IBOutlet weak var casesLabel: UILabel!
	@IBOutlet weak var recoveredLabel: UILabel!
	@IBOutlet weak var deathsLabel: UILabel!
	
	var indonesia: Indonesia?
	
	override func viewDidAppear(_ animated: Bool) {
		updateLabel()
	}
	
	// MARK: - Fetching Data
	func parseCovidStats(json: Data) {
		let decoder = JSONDecoder()
		
		do {
			let jsonStats = try decoder.decode([Indonesia].self, from: json)
			indonesia = jsonStats.first
		} catch {
			print("Data loading fails with error:", error)
		}
	}
	
	func updateLabel() {
		let urlString = "https://api.kawalcorona.com/indonesia/"
		if let url = URL(string: urlString) {
			if let data = try? Data(contentsOf: url) {
				parseCovidStats(json: data)
				self.casesLabel.text = indonesia?.positif
				self.recoveredLabel.text = indonesia?.sembuh
				deathsLabel.text = indonesia?.meninggal
			}
		}
	}

	
}
