//
//  TodayViewController.swift
//  Covina
//
//  Created by Dimas on 23/07/21.
//

import UIKit

class TodayViewController: UIViewController {
	
    override func viewDidLoad() {
        super.viewDidLoad()

		// Customize the tab bar controller
		let border = self.tabBarController?.tabBar.layer
		border?.borderWidth = 1.2
		border?.borderColor = #colorLiteral(red: 0.9411764706, green: 0.9411764706, blue: 0.9411764706, alpha: 1)

    }
	
	override func viewWillAppear(_ animated: Bool) {

		// show dis
		guard let viewControllers = self.tabBarController?.viewControllers else { return }
		if viewControllers.indices.contains(1) {
			self.tabBarController?.selectedIndex = 1
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
