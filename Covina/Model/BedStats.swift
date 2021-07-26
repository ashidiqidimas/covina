//
//  BedData.swift
//  Covina
//
//  Created by Dimas on 26/07/21.
//

import Foundation

struct BedStats: Codable {
	var title: String
	var bed_available: Int
	var bed_empty: Int
	var queue: Int
}
