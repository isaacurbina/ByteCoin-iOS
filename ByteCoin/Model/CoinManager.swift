//
//  CoinManager.swift
//  ByteCoin
//
//  Created by Angela Yu on 11/09/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import Foundation

protocol CoinManagerDelegate {
	func didGetResponse(_ data: CoinData)
	func didFailWithError(_ error: Error)
}

struct CoinManager {
	
	private let baseURL = "https://rest.coinapi.io/v1/exchangerate/BTC"
	private let apiKey = "F73EC27B-6438-498F-9C83-0F97E7C99139"
	var delegate: CoinManagerDelegate?
	
	let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
	
	func getCoinPrice(for currency: String) {
		let requestUrl = "\(baseURL)/\(currency)?apiKey=\(apiKey)"
		print(requestUrl, currency)
		performRequest(with: requestUrl, currency: currency)
	}
	
	private func performRequest(with urlString: String, currency: String) {
		if let url = URL(string: urlString) {
			let session = URLSession(configuration: .default)
			let task = session.dataTask(with: url) { (data, response, error) in
				if error != nil {
					self.delegate?.didFailWithError(error!)
					return
				}
				if let safeData = data {
					if let coinApiResponse = self.parseJSON(safeData) {
						let coinData = CoinData(
							rate: String(format: "%.2f", coinApiResponse.rate!),
							currency: currency
						)
						self.delegate?.didGetResponse(coinData)
					}
				}
			}
			task.resume()
		}
	}
	
	private func parseJSON(_ data: Data) -> CoinApiResponse? {
		let decoder = JSONDecoder()
		do {
			let decodedData = try decoder.decode(CoinApiResponse.self, from: data)
			return decodedData
		} catch {
			self.delegate?.didFailWithError(error)
			return nil
		}
	}
}
