//
//  APIManager.swift
//  PlaySync
//
//  Created by Ryan Cobelli on 8/30/24.
//

import Foundation
import Alamofire
import SWXMLHash

public typealias FailureMessage = String

public class APIManager {
	public static let shared = APIManager()
	private let categoriesToRemove = [
		"ESPN",
		"ACC",
		"SEC",
		"FOX",
		"Sports",
		"HD",
		"Competition",
		"Paramount+",
		"NCAA",
		"LALIGA",
		"Eredivisie",
		"Bundesliga"
	]
	
	func getChannels(success: @escaping (([Channel]) -> Void), failure: @escaping ((FailureMessage) -> Void)) {
		
		AF.request("http://10.0.0.136:8000/xmltv.xml", method:.get).response { response in
			switch response.result {
			case .success:
				do {
					let xml = XMLHash.parse(response.data!)
					let channels = try self.parseXml(xml: xml)
					
					success(channels.filter({ ch in
						!ch.title.contains("En Español") && !ch.categories.joined().contains("Tennis") && !ch.categories.joined().contains("Volleyball")
					}))
				} catch {
					print(error)
					failure("Unable to parse XML")
				}
			case let .failure(error):
				failure(error.localizedDescription)
			}
		}
	}
	
	private func parseXml(xml: XMLIndexer) throws -> [Channel] {
		return try xml["tv"]["programme"].all.compactMap { elem in
			let channelString: String = try elem.value(ofAttribute: "channel")
			let channelNumString = channelString.split(separator: ".")[0]
			
			let categories = elem["category"].all.map { cat in
				cat.element!.text
			}
			
			let broadcaster = if categories.joined().contains("ESPN") || categories.joined().contains("ACC") || categories.joined().contains("SEC") {
				"ESPN"
			} else if categories.joined().contains("FOX") {
				"FOX"
			} else {
				"CBS"
			}
			
			let dateFormatterGet = DateFormatter()
			dateFormatterGet.dateFormat = "yyyyMMddHHmmss +0000"
			dateFormatterGet.timeZone = .gmt
			
			let start = dateFormatterGet.date(from: try elem.value(ofAttribute: "start"))
			let end = dateFormatterGet.date(from: try elem.value(ofAttribute: "stop"))
			
			// Filter out events that aren't live
			if start! > Date.now || end! < Date.now {
				return nil
			}
			
			let filteredCategories = categories.filter({ cat in
				for search in categoriesToRemove {
					if cat.contains(search) {
						return false
					}
				}
				return true
			})
			
			return Channel(channelNum: Int(channelNumString)!,
						   title: elem["title"].element!.text,
						   broadcaster: broadcaster,
						   categories: filteredCategories)
		}
	}
}


public struct Channel: Hashable, Identifiable {
	public var id: UUID = UUID()
	public var channelNum: Int
	public var title: String
	public var broadcaster: String
	public var categories: [String]
}
