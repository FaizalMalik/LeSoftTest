//
//	Geo.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation 
import SwiftyJSON

class Geo{

	var lat : String!
	var lng : String!


	/**
	 * Instantiate the instance using the passed json values to set the properties values
	 */
	init(fromJson json: JSON!){
		if json.isEmpty{
			return
		}
		lat = json["lat"].stringValue
		lng = json["lng"].stringValue
	}

}