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
		"NJCAA",
		"LALIGA",
		"Eredivisie",
		"Bundesliga",
		"Premier Lacrosse League",
		"PLL",
		"Fuera de Juego",
		"MLB",
		"US Open",
		"NHL",
		"American Cornhole League",
		"UFC"
	]
	
	func getChannels(success: @escaping (([Channel]) -> Void), failure: @escaping ((FailureMessage) -> Void)) {
		
		AF.request("http://10.0.0.4:8000/xmltv.xml", method:.get).response { response in
			switch response.result {
			case .success:
				do {
					let xml = XMLHash.parse(response.data!)
					let channels = try self.parseXml(xml: xml)
					
					success(channels.filter({ ch in
						!ch.title.contains("En Español")
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
			
			var categories = elem["category"].all.map { cat in
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
			
			categories = categories.map({ cat in
				if cat == "English Football League" {
					return "Soccer"
				} else if cat == "Argentina Liga Profesional de Fútbol" {
					return "Soccer"
				} else if cat.contains("USL ") {
					return "Soccer"
				} else if cat == "Others" {
					return "Other"
				}
				
				return cat
			})
			
			categories = categories.filter({ cat in
				for search in categoriesToRemove {
					if cat.contains(search) {
						return false
					}
				}
				return true
			})
			
			if categories.count == 0 {
				categories = ["Other"]
			}
			
			return Channel(channelNum: Int(channelNumString)!,
						   title: elem["title"].element!.text,
						   broadcaster: broadcaster,
						   categories: categories)
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
