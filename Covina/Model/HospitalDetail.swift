//
//  HospitalDetail.swift
//  Covina
//
//  Created by Dimas on 26/07/21.
//

import Foundation

struct HospitalDetail: Codable {
	var id: String
	var name: String
	var address: String
	var phone: String
	var bedDetail = [BedDetail]()
}
