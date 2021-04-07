//
//	Company.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation 
import SwiftyJSON

class Company{

	var bs : String!
	var catchPhrase : String!
	var name : String!


	/**
	 * Instantiate the instance using the passed json values to set the properties values
	 */
	init(fromJson json: JSON!){
		if json.isEmpty{
			return
		}
		bs = json["bs"].stringValue
		catchPhrase = json["catchPhrase"].stringValue
		name = json["name"].stringValue
	}

}