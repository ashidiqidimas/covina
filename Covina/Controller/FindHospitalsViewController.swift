//
//  ViewController.swift
//  Covina
//
//  Created by Dimas on 22/07/21.
//

import UIKit

class FindHospitalsViewController: UIViewController {

	override func viewDidLoad() {
		super.viewDidLoad()
		
		// Customize the tab bar controller
		let border = self.tabBarController?.tabBar.layer
		border?.borderWidth = 1.2
		border?.borderColor = #colorLiteral(red: 0.9411764706, green: 0.9411764706, blue: 0.9411764706, alpha: 1)
	}
	
}

