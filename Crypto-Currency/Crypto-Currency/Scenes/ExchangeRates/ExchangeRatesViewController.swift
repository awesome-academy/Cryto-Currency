//
//  ExchangeRatesViewController.swift
//  Crypto-Currency
//
//  Created by namtrinh on 04/08/2021.
//

import UIKit

final class ExchangeRatesViewController: UIViewController {
    
    @IBOutlet private weak var baseImageView: UIImageView!
    @IBOutlet private weak var targetImageView: UIImageView!
    @IBOutlet private weak var baseTextField: UITextField!
    @IBOutlet private weak var targetTextField: UITextField!
    @IBOutlet private weak var baseLabel: UILabel!
    @IBOutlet private weak var targetLabel: UILabel!
    @IBOutlet private weak var targetSymbolLabel: UILabel!
    @IBOutlet private weak var baseSymbolLabel: UILabel!
    
    private var exchangeRate = "1.0"
    var defaultCurrency = ""
    
    private var baseCurrency: SimpleCoin?
    private var targetCurrency: SimpleCoin?
    var newBaseCurrency: SimpleCoin?
    var newTargetCurrency: SimpleCoin?
    
    private let repository = RepositoryAPI()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureImageView()
        configureTextField()
        loadSimpleCoin()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        baseTextField.becomeFirstResponder()
    }
    
    func validate() {
        if let newBaseCurrency = newBaseCurrency,
           let baseCurrency = baseCurrency {
            if newBaseCurrency.uuid != baseCurrency.uuid {
                self.baseCurrency = newBaseCurrency
                configureCoin()
                loadAPI()
            }
        }
        
        if let newTargetCurrency = newTargetCurrency,
           let targetCurrency = targetCurrency {
            if newTargetCurrency.uuid != targetCurrency.uuid {
                self.targetCurrency = newTargetCurrency
                configureCoin()
                loadAPI()
            }
        }
    }
    
    private func configureTextField() {
        baseTextField.delegate = self
        targetTextField.delegate = self
    }
    
    private func configureImageView() {
        baseImageView.layer.cornerRadius = 30
        targetImageView.layer.cornerRadius = 30

        let baseTap = UITapGestureRecognizer(target: self,
                                             action: #selector(baseImageTapped))
        baseImageView.isUserInteractionEnabled = true
        baseImageView.addGestureRecognizer(baseTap)
        
        let targetTap = UITapGestureRecognizer(target: self,
                                               action: #selector(targetImageTapped))
        targetImageView.isUserInteractionEnabled = true
        targetImageView.addGestureRecognizer(targetTap)
    }
    
    @objc private func baseImageTapped() {
        let searchScreen = SearchViewController()
        searchScreen.modalPresentationStyle = .fullScreen
        searchScreen.fromBaseCurrency = true
        present(searchScreen, animated: false, completion: nil)
    }
    
    @objc private func targetImageTapped() {
        let searchScreen = SearchViewController()
        searchScreen.modalPresentationStyle = .fullScreen
        searchScreen.fromTargetCurrency = true
        present(searchScreen, animated: false, completion: nil)
    }
    
    private func loadSimpleCoin() {
        repository.getSimpleCoin(name: defaultCurrency) { [weak self] coins, error in
            guard let self = self else { return }
            if let error = error {
                print(error.localizedDescription)
            }
            
            if let coins = coins {
                self.baseCurrency = coins.first
                self.targetCurrency = coins.first
                DispatchQueue.main.async {
                    self.configureCoin()
                }
            }
        }
    }
    
    private func loadAPI() {
        guard let baseCurrency = baseCurrency,
              let targetCurrency = targetCurrency else {
            return
        }
        
        let urlString = Network.shared.getExchangeRates(base: baseCurrency.uuid,
                                                        target: targetCurrency.uuid)
        repository.getExchangeRates(urlString: urlString) { [weak self] result, error in
            guard let self = self else { return }
            if let error = error {
                print(error.localizedDescription)
            }
            
            if let result = result {
                self.exchangeRate = result.price
            }
        }
    }
    
    private func configureCoin() {
        guard let baseCurrency = baseCurrency,
              let targetCurrency = targetCurrency else {
            return
        }
        
        baseLabel.text = baseCurrency.name
        baseSymbolLabel.text = baseCurrency.symbol
        let baseUrl = baseCurrency.iconUrl.replacingOccurrences(of: "svg", with: "png")
        if let url = URL(string: baseUrl) {
            baseImageView.setImage(from: url)
        }
        
        targetLabel.text = targetCurrency.name
        targetSymbolLabel.text = targetCurrency.symbol
        let targetUrl = targetCurrency.iconUrl.replacingOccurrences(of: "svg", with: "png")
        if let url = URL(string: targetUrl) {
            targetImageView.setImage(from: url)
        }
    }
    
    @IBAction func handleExitButton(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}

extension ExchangeRatesViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.becomeFirstResponder()
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        guard let exchangeRate = Double(exchangeRate) else {
            return
        }
        
        switch textField {
        case baseTextField:
            guard let text = baseTextField.text,
                  let number = Double(text) else {
                return
            }
            targetTextField.text = String(format: "%.2f", exchangeRate * number)
            
        case targetTextField:
            guard let text = targetTextField.text,
                  let number = Double(text) else {
                return
            }
            baseTextField.text = String(format: "%.2f", number / exchangeRate)
        default:
            return
        }
    }
    
}
