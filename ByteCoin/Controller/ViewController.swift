//
//  ViewController.swift
//  ByteCoin
//
//  Created by Angela Yu on 11/09/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

	private var coinManager = CoinManager()
	
	// MARK: - Outlets
	@IBOutlet weak var bitcoinLabel: UILabel!
	@IBOutlet weak var currencyLabel: UILabel!
	@IBOutlet weak var currencyPicker: UIPickerView!
	
	// MARK: - UIViewController
	override func viewDidLoad() {
        super.viewDidLoad()
		coinManager.delegate = self
		currencyPicker.dataSource = self
		currencyPicker.delegate = self
		currencySelected(0)
    }
}

// MARK: - UIPickerViewDataSource
extension ViewController : UIPickerViewDataSource {
	
	func numberOfComponents(in pickerView: UIPickerView) -> Int {
		return 1
	}
	
	func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
		return coinManager.currencyArray.count
	}
}

// MARK: - UIPickerViewDelegate
extension ViewController : UIPickerViewDelegate {
	
	func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
		return coinManager.currencyArray[row]
	}
	
	func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
		currencySelected(row)
	}
	
	private func currencySelected(_ index: Int) {
		let currency = coinManager.currencyArray[index]
		currencyLabel.text = currency
		coinManager.getCoinPrice(for: currency)
	}
}

// MARK: - CoinManagerDelegate
extension ViewController : CoinManagerDelegate {
	
	func didGetResponse(_ response: CoinData) {
		DispatchQueue.main.async {
			self.bitcoinLabel.text = response.rate
			self.currencyLabel.text = response.currency
		}
	}
	
	func didFailWithError(_ error: any Error) {
		print(error)
	}
}
