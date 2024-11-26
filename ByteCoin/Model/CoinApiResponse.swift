//
//  CoinApiResponse.swift
//  ByteCoin
//
//  Created by Isaac Urbina on 11/25/24.
//  Copyright © 2024 The App Brewery. All rights reserved.
//

struct CoinApiResponse : Decodable {
	let time: String?
	let asset_id_base: String?
	let asset_id_quote: String?
	let rate: Double?
}
