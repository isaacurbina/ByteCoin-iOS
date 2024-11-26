//
//  CoinManager.swift
//  ByteCoin
//
//  Created by Angela Yu on 11/09/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import Foundation

protocol CoinManagerDelegate {
	func didGetResponse(_ weather: CoinApiResponse)
	func didFailWithError(_ error: Error)
}

struct CoinManager {
	
	private let baseURL = "https://rest.coinapi.io/v1/exchangerate/BTC"
	private let apiKey = "669365E4-555E-40D4-8953-3303C1680CFB"
	var delegate: CoinManagerDelegate?
	
	let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
	
	func getCoinPrice(for currency: String) {
		let requestUrl = "\(baseURL)/\(currency)?apiKey=\(apiKey)"
		print(requestUrl)
		performRequest(with: requestUrl)
	}
	
	private func performRequest(with urlString: String) {
		if let url = URL(string: urlString) {
			let session = URLSession(configuration: .default)
			let task = session.dataTask(with: url) { (data, response, error) in
				if error != nil {
					self.delegate?.didFailWithError(error!)
					return
				}
				if let safeData = data {
					if let coinApiResponse = self.parseJSON(safeData) {
						self.delegate?.didGetResponse(coinApiResponse)
					}
				}
			}
			task.resume()
		}
	}
	
	private func parseJSON(_ apiResponse: Data) -> CoinApiResponse? {
		let decoder = JSONDecoder()
		do {
			let decodedData = try decoder.decode(CoinApiResponse.self, from: apiResponse)
			return decodedData
		} catch {
			self.delegate?.didFailWithError(error)
			return nil
		}
	}
}
