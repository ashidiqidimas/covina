//
//  SelectProvinceViewController.swift
//  Covina
//
//  Created by Dimas on 26/07/21.
//

import UIKit

class SelectProvinceViewController: UIViewController {

	@IBOutlet weak var provinceTableViewHeight: NSLayoutConstraint!
	
	override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
	
	override func viewWillAppear(_ animated: Bool) {
		self.navigationItem.title = "nama provinsi"
		
//		self.navigationController?.navigationBar.prefersLargeTitles = false
	}
	
	override func viewDidAppear(_ animated: Bool) {
		provinceTableViewHeight.constant = CGFloat(10)
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
