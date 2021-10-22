//
//  AmountInputView.swift
//
//  Created by Mustafa Demirci
//

import Foundation
import UIKit


public protocol AmountInputViewInterface: AnyObject {
    func priceChanged(_ price: Double)
}
public final class AmountInputViewData {
    private let exactAmountFont: UIFont?
    private let exactAmountColor: UIColor?

    private let fractionalAmountFont: UIFont?
    private let fractionalAmountColor: UIColor?

}
public final class AmountInputView: DataBasedComponentView<AmountInputViewData> {
    private weak var newPriceComponentInterface: AmountInputViewInterface!

    private lazy var mainStackView: UIStackView = {
        let temp = UIStackView(arrangedSubviews: [exactPriceTextField, commaLabel, fractionalTextField, currencyLabel])
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.spacing = 5
        temp.alignment = .center
        temp.distribution = .fill
        temp.axis = .horizontal
        return temp
    }()

    private lazy var exactPriceTextField: CursorFixedToEndTextField = {
        let temp = CursorFixedToEndTextField()
        temp.font = .systemFont(ofSize: 60, weight: .bold)
        temp.text = "0"
        temp.keyboardType = .decimalPad
        temp.delegate = self
        temp.textColor = .black
        temp.layer.shadowOpacity = 0
        temp.translatesAutoresizingMaskIntoConstraints = false
        return temp
    }()

    private lazy var fractionalTextField: CursorFixedToBeginningTextField = {
        let temp = CursorFixedToBeginningTextField()
        temp.font =  UIFont.systemFont(ofSize: 30, weight: .medium)
        temp.delegate = self
        temp.textColor = UIColor.black.withAlphaComponent(0.7)
        temp.text = "00"
        temp.keyboardType = .decimalPad
        temp.layer.shadowOpacity = 0
        temp.translatesAutoresizingMaskIntoConstraints = false
        return temp
    }()

    private lazy var currencyLabel: UILabel = {
        let temp = UILabel()
        temp.text = "TL"
        temp.font = UIFont.systemFont(ofSize: 30, weight: .medium)
        temp.textColor = UIColor.black.withAlphaComponent(0.7)
        return temp
    }()

    private lazy var commaLabel: UILabel = {
        let temp = UILabel()
        temp.text = ","
        temp.font =  UIFont.systemFont(ofSize: 30, weight: .medium)
        temp.textColor = UIColor.black.withAlphaComponent(0.7)
        return temp
    }()

    private lazy var dismissButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Done", for: .normal)
        button.titleLabel?.font =  UIFont.systemFont(ofSize: 30, weight: .regular)
        button.setTitleColor(UIColor.systemBlue, for: .normal)
        button.addTarget(self, action: #selector(AmountInputView.dismissKeyboard), for: .touchUpInside)
        return button
    }()

    public override func addMajorViews() {
        super.addMajorViews()
        addAccessoryView()
        addMainStackView()
    }

    private func addMainStackView() {
        addSubview(mainStackView)
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: topAnchor),
            mainStackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            mainStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            mainStackView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
    private func setMinimumFont() {
        exactPriceTextField.font = .systemFont(ofSize: 45, weight: .bold)
    }
    private func setMaximumFont() {
        exactPriceTextField.font = .systemFont(ofSize: 60, weight: .bold)
    }

}
extension AmountInputView: UITextFieldDelegate {
    private func adjustFont(with count: Int) {
        if count >= 5 {
            setMinimumFont()
        } else {
            setMaximumFont()
        }
    }
    private func emptyExactPriceTextField() {
        exactPriceTextField.text = "0"
    }

    private func emptyFractionalTextField() {
        fractionalTextField.text = "00"
    }

    private func configureFractionalTextField(with string: String, currentText: String, textCount: Int) -> Bool {
        if string.isEmpty {
            if textCount == 1 {
                emptyFractionalTextField()
                return false
            }
        } else {
            if textCount == 2 {
                fractionalTextField.text = string
                return false
            }
        }
        return true
    }

    private func handleExactPriceRemoving(with currentText: String, textCount: Int) -> Bool {
        if textCount == 1 {
            emptyExactPriceTextField()
            return false
        } else if textCount >= 5 {
            var text = currentText.replacingOccurrences(of: ".", with: "")
            text = String(text.dropLast())
            if text.count > 3 {
                text.insert(".", at: text.index(text.endIndex, offsetBy: -3))
            }
            exactPriceTextField.text = text
            return false
        }
        return true
    }
    private func handleExactPriceInputEntering(string: String, currentText: String, textCount: Int) -> Bool {
        if currentText == "0" {
            exactPriceTextField.text = string
            return false
        } else if textCount == 6 {
            return false
        } else if textCount > 2 {
            var text = currentText + string
            text = text.replacingOccurrences(of: ".", with: "")
            text.insert(".", at: text.index(text.endIndex, offsetBy: -3))
            exactPriceTextField.text = text
            adjustFont(with: text.count)
            return false
        }
        return true
    }
    private func configureExactPriceTextField(with string: String) -> Bool {
        let currentText = exactPriceTextField.text ?? ""
        let textCount = exactPriceTextField.text?.count ?? 0
        if string.isEmpty {
            adjustFont(with: textCount - 1)
            return handleExactPriceRemoving(with: currentText, textCount: textCount)
        } else {
            return handleExactPriceInputEntering(string: string, currentText: currentText, textCount: textCount)
        }
    }

    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard !string.elementsEqual(",") else { return false }
        let currentText = textField.text ?? ""
        let textCount = textField.text?.count ?? 0

        if textField == exactPriceTextField {
            return configureExactPriceTextField(with: string)
        }
        else if textField == fractionalTextField {
            return configureFractionalTextField(with: string, currentText: currentText, textCount: textCount)
        }
        return true
    }

    public func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        let textCount = textField.text?.count ?? 0

        if textField == exactPriceTextField {

        }
        else if textField == fractionalTextField {
            if textCount == 1 {
                textField.text = textField.text! + "0"
            }
        }
        return true
    }

    public func textFieldDidEndEditing(_ textField: UITextField) {
    }
}

extension AmountInputView {

    public func addAccessoryView() {
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 44))
        toolBar.barStyle = .default
        toolBar.barTintColor = UIColor.white
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let dismiss = UIBarButtonItem(customView: dismissButton)
        toolBar.items = [flexibleSpace, dismiss]

        exactPriceTextField.inputAccessoryView = toolBar
        fractionalTextField.inputAccessoryView = toolBar
    }

    @objc func dismissKeyboard() {
        self.endEditing(true)
    }

}
