import UIKit

class ViewController: UIViewController {
    private let displayLabel = UILabel()
    private var currentInput = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        view.backgroundColor = .black
        
        displayLabel.frame = CGRect(x: 20, y: 100, width: view.frame.width - 40, height: 100)
        displayLabel.textAlignment = .right
        displayLabel.font = UIFont.systemFont(ofSize: 60, weight: .light)
        displayLabel.textColor = .white
        displayLabel.text = "0"
        view.addSubview(displayLabel)
        
        let buttons = [
            ["C", "%", "/", "√"],
            ["7", "8", "9", "*"],
            ["4", "5", "6", "-"],
            ["1", "2", "3", "+"],
            ["0", ".", "="]
        ]
        
        let buttonSize: CGFloat = (view.frame.width - 50) / 4
        let grid = UIStackView()
        grid.axis = .vertical
        grid.distribution = .fillEqually
        grid.spacing = 10
        grid.frame = CGRect(x: 10, y: 250, width: view.frame.width - 20, height: buttonSize * 5 + 40)
        view.addSubview(grid)
        
        for row in buttons {
            let rowStack = UIStackView()
            rowStack.axis = .horizontal
            rowStack.distribution = .fillEqually
            rowStack.spacing = 10
            
            for title in row {
                let button = UIButton(type: .system)
                button.setTitle(title, for: .normal)
                button.titleLabel?.font = UIFont.systemFont(ofSize: 32, weight: .medium)
                button.layer.cornerRadius = buttonSize / 2
                
                if ["+", "-", "*", "/", "=", "√"].contains(title) {
                    button.backgroundColor = .systemOrange
                    button.setTitleColor(.white, for: .normal)
                } else if ["C", "%"].contains(title) {
                    button.backgroundColor = .darkGray
                    button.setTitleColor(.black, for: .normal)
                } else {
                    button.backgroundColor = .lightGray
                    button.setTitleColor(.black, for: .normal)
                }
                
                if title == "0" {
                    button.widthAnchor.constraint(equalToConstant: buttonSize * 2 + 10).isActive = true
                } else {
                    button.widthAnchor.constraint(equalToConstant: buttonSize).isActive = true
                }
                
                button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
                rowStack.addArrangedSubview(button)
            }
            
            grid.addArrangedSubview(rowStack)
        }
    }
    
    @objc private func buttonTapped(_ sender: UIButton) {
        guard let title = sender.currentTitle else { return }

        if title == "C" {
            currentInput = ""
            displayLabel.text = "0"
        } else if title == "=" {
            if containsDivisionByZero(currentInput) {
                displayLabel.text = "Ошибка"
                currentInput = ""
            } else {
                let expression = NSExpression(format: currentInput)
                if let result = expression.expressionValue(with: nil, context: nil) as? Double {
                    displayLabel.text = formatResult(result)
                    currentInput = "\(result)"
                } else {
                    displayLabel.text = "Ошибка"
                    currentInput = ""
                }
            }
        } else if title == "√" {
            if let value = Double(currentInput), value >= 0 {
                let result = sqrt(value)
                displayLabel.text = formatResult(result)
                currentInput = "\(result)"
            } else {
                displayLabel.text = "Ошибка"
                currentInput = ""
            }
        } else if title == "%" {
            if let value = Double(currentInput) {
                let percentValue = value / 100
                currentInput = "\(percentValue)"
                displayLabel.text = formatResult(percentValue)
            } else {
                displayLabel.text = "Ошибка"
                currentInput = ""
            }
        } else {
            if title == "." {
                if currentInput.contains(".") {
                    return
                }
            }

            if currentInput == "0" && title != "." {
                currentInput = title
            } else {
                currentInput += title
            }
            displayLabel.text = currentInput
        }
    }

    private func containsDivisionByZero(_ input: String) -> Bool {
        let components = input.split(separator: "/")
        return components.count > 1 && components.last?.trimmingCharacters(in: .whitespaces) == "0"
    }

    private func formatResult(_ value: Double) -> String {
        return value.truncatingRemainder(dividingBy: 1) == 0 ? "\(Int(value))" : "\(value)"
    }
}
