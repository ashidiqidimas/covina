//
//  HospitalDetailsViewController.swift
//  Covina
//
//  Created by Dimas on 26/07/21.
//

import UIKit

class HospitalDetailsViewController: UIViewController {

	@IBOutlet weak var phoneLabel: UILabel!
	@IBOutlet weak var addressLabel: UILabel!
	@IBOutlet weak var IGDKhususLabel: UILabel!
	@IBOutlet weak var NICUKhususLabel: UILabel!
	@IBOutlet weak var isolasiTanpaLabel: UILabel!
	@IBOutlet weak var isolasiTekananLabel: UILabel!
	@IBOutlet weak var ICUTanpaTekananVentilatorLabel: UILabel!
	@IBOutlet weak var ICUTanpaTekananDenganVentilator: UILabel!
	@IBOutlet weak var ICUTekananTanpaVentilator: UILabel!
	@IBOutlet weak var ICUTekananDenganVentilator: UILabel!
	
	var hospitalId = ""
	var hospitalName = ""
	var hospitalDetails = HospitalDetails()
	
	override func viewDidLoad() {
        super.viewDidLoad()

		self.navigationController?.navigationBar.prefersLargeTitles = true
		self.navigationItem.title = hospitalName
    }
	
	override func viewDidAppear(_ animated: Bool) {
		getHospitalDetails()
	}
	
	// MARK: - Fetching Data
	func parseHospitals(json: Data) {
		let decoder = JSONDecoder()
		
		if let jsonHospitals = try? decoder.decode(HospitalDetails.self, from: json) {
			hospitalDetails.data = jsonHospitals.data
			print(hospitalDetails.data)
		}
	}
	
	func getHospitalDetails() {
		let urlString = "https://rs-bed-covid-api.vercel.app/api/get-bed-detail?hospitalid=\(hospitalId)&type=1"
		if let url = URL(string: urlString) {
			if let data = try? Data(contentsOf: url) {
				parseHospitals(json: data)

				// Insert data to labels
				let hospital = hospitalDetails.data.first{$0.id == hospitalId}
				phoneLabel.text = hospital?.phone
				addressLabel.text = hospital?.address
				print(hospitalDetails)
			}
		}
	}
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
