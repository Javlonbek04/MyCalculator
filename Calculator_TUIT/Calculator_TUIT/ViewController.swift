//
//  ViewController.swift
//  Calculator_TUIT
//
//  Created by Abdulvoxid on 10/12/24.
//

import UIKit

class ViewController: UIViewController {
    
    private let displayLabel: UILabel = {
        let label = UILabel()
        label.text = "0"
        label.font = UIFont.systemFont(ofSize: 30, weight: .bold)
        label.textAlignment = .right
        label.textColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let buttonTitles: [[String]] = [
        ["7", "8", "9", "/"],
        ["4", "5", "6", "x"],
        ["1", "2", "3", "-"],
        ["0", ".", "=", "+"]
    ]
    
    private var currentNumber: String = "0"
    private var previousNumber: String = ""
    private var currentOperation: String? = nil
    private var isTyping: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
    }
    
    func setupUI() {
        view.addSubview(displayLabel)
        NSLayoutConstraint.activate([
            displayLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 250),
            displayLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            displayLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            displayLabel.heightAnchor.constraint(equalToConstant: 80)
        ])
        
        let buttonStackView = UIStackView()
        buttonStackView.axis = .vertical
        buttonStackView.distribution = .fillEqually
        buttonStackView.spacing = 15
        buttonStackView.translatesAutoresizingMaskIntoConstraints = false
        
        for row in buttonTitles {
            let rowStackView = createRowStackView(with: row)
            buttonStackView.addArrangedSubview(rowStackView)
        }
        
        view.addSubview(buttonStackView)
        NSLayoutConstraint.activate([
            buttonStackView.topAnchor.constraint(equalTo: displayLabel.bottomAnchor, constant: 20),
            buttonStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            buttonStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            buttonStackView.heightAnchor.constraint(equalToConstant: 350),
        ])
        
        let lastRowView = createLastRow()
        view.addSubview(lastRowView)
        NSLayoutConstraint.activate([
            lastRowView.topAnchor.constraint(equalTo: buttonStackView.bottomAnchor, constant: 15),
            lastRowView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            lastRowView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -305),
            lastRowView.heightAnchor.constraint(equalTo: buttonStackView.heightAnchor, multiplier: 0.22)
        ])


    }
    
    private func createRowStackView(with titles: [String]) -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 15
        stackView.distribution = .fillEqually
        
        for title in titles {
            let button = createButton(with: title)
            stackView.addArrangedSubview(button)
        }
        return stackView
    }
    
    private func createButton(with title: String) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 24, weight: .medium)
        button.backgroundColor = .blue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        return button
    }
    
    private func createLastRow() -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 15
        stackView.distribution = .fillProportionally
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        let clearButton = createButton(with: "C")
        stackView.addArrangedSubview(clearButton)
        
        return stackView
    }



    @objc private func buttonTapped(_ sender: UIButton) {
        guard let title = sender.currentTitle else { return }
        
        switch title {
        case "C":
            clear()
        case "=":
            calculateResult()
        case "+", "-", "x", "/":
            selectOperation(title)
        default:
            appendNumber(title)
        }
    }
    
    private func appendNumber(_ number: String) {
        if number == "." && currentNumber.contains(".") { return }
        
        if !isTyping || currentNumber == "0" {
            currentNumber = number
            isTyping = true
        } else {
            currentNumber += number
        }
        updateDisplay()
    }

    private func selectOperation(_ operation: String) {
        if isTyping {
            calculateResult()
        }
        previousNumber = currentNumber
        currentOperation = operation
        isTyping = false
    }

    private func calculateResult() {
        guard let operation = currentOperation,
              let previous = Double(previousNumber),
              let current = Double(currentNumber) else {
            return
        }
        
        var result: Double = 0
        switch operation {
        case "+":
            result = previous + current
        case "-":
            result = previous - current
        case "x":
            result = previous * current
        case "/":
            if current != 0 {
                result = previous / current
            } else {
                displayLabel.text = "Error"
                clear()
                return
            }
        default:
            break
        }
        
        currentNumber = formatResult(result)
        previousNumber = ""
        currentOperation = nil
        isTyping = false
        updateDisplay()
    }

    private func clear() {
        currentNumber = "0"
        previousNumber = ""
        currentOperation = nil
        isTyping = false
        updateDisplay()
    }
    
    private func formatResult(_ result: Double) -> String {
        return result.truncatingRemainder(dividingBy: 1) == 0 ? String(Int(result)) : String(result)
    }
    
    private func updateDisplay() {
        displayLabel.text = currentNumber
    }
}
