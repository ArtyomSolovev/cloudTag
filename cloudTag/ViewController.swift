//
//  ViewController.swift
//  cloudTag
//
//  Created by Артем Соловьев on 03.04.2022.
//

import UIKit
import Alamofire

class ViewController: UIViewController {
    
    var arrayOfButtons = [UIButton]()
    var switcherOfButtons = [Bool]()
    var arrayOfDrinks = [Drink]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        let frame = view.safeAreaLayoutGuide.layoutFrame
        AF.request("https://www.thecocktaildb.com/api/json/v1/1/filter.php?a=Non_Alcoholic")
            .responseDecodable(of: All.self) { (response) in
                guard let drinks = response.value else { return }
                drinks.drinks.forEach({ self.arrayOfDrinks.append($0)})
            }
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) { [self] in
            for i in 0..<arrayOfDrinks.count {
                arrayOfButtons.append(UIButton())
                switcherOfButtons.append(false)
                self.view.addSubview(self.arrayOfButtons[i])
                arrayOfButtons[i].setTitle(" \(arrayOfDrinks[i].strDrink) ", for: .normal)
                arrayOfButtons[i].setTitle("123", for: .selected)
                arrayOfButtons[i].backgroundColor = .systemGray
                arrayOfButtons[i].layer.cornerRadius = 8
                arrayOfButtons[i].addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
            }
            placeText()
        }
        
    }
    
    @objc func buttonAction(sender: UIButton!) {
        guard let index = arrayOfButtons.index(of: sender) else  {return}
        if switcherOfButtons[index] == false {
            sender.applyGradient(colours: [.red, .purple]).cornerRadius = 8
        } else {
            sender.applyGradient(colours: [.red])
            sender.backgroundColor = .red
        }
        switcherOfButtons[index].toggle()
        print(switcherOfButtons[index])
    }
    
    private func placeText(){
        let widthOfScreen = UIScreen.main.bounds.width
        let sizeOfScreen = UIScreen.main.bounds.size
        var line:CGFloat = 0
        var column = 1
        var indexOfButton = 0
        while indexOfButton<arrayOfButtons.count {
            var widthOfButtons:CGFloat = 8
            for indexOfColumn in 0..<column {
                widthOfButtons = widthOfButtons + arrayOfButtons[indexOfButton - indexOfColumn].sizeThatFits(sizeOfScreen).width + 8
            }
            if widthOfButtons < widthOfScreen {
                arrayOfButtons[indexOfButton].frame = CGRect(x: 8 + widthOfButtons - arrayOfButtons[indexOfButton].sizeThatFits(UIScreen.main.bounds.size).width,
                                                      y: 8 + (arrayOfButtons[indexOfButton].sizeThatFits(UIScreen.main.bounds.size).height+8) * line,
                                                      width: arrayOfButtons[indexOfButton].sizeThatFits(UIScreen.main.bounds.size).width,
                                                      height: arrayOfButtons[indexOfButton].sizeThatFits(UIScreen.main.bounds.size).height)
                column += 1
                indexOfButton += 1
            } else {
                line += 1
                arrayOfButtons[indexOfButton].frame = CGRect(x: 8,
                                                      y: 8 + (arrayOfButtons[indexOfButton].sizeThatFits(UIScreen.main.bounds.size).height+8) * line,
                                                      width: arrayOfButtons[indexOfButton].sizeThatFits(UIScreen.main.bounds.size).width,
                                                      height: arrayOfButtons[indexOfButton].sizeThatFits(UIScreen.main.bounds.size).height)
                column = 1
            }
//            print("line: ", line , arrayOfButtons[indexOfButton].titleLabel?.text ?? "", " : ",arrayOfButtons[indexOfButton].frame)
        }
        
        
    }
}

extension UIView {
    func applyGradient(colours: [UIColor]) -> CAGradientLayer {
        return self.applyGradient(colours: colours, locations: nil)
    }
    func applyGradient(colours: [UIColor], locations: [NSNumber]?) -> CAGradientLayer {
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = self.bounds
        gradient.colors = colours.map { $0.cgColor }
        gradient.locations = locations
        self.layer.insertSublayer(gradient, at: 0)
        return gradient
    }
}
