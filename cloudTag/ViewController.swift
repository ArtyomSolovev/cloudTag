//
//  ViewController.swift
//  cloudTag
//
//  Created by Артем Соловьев on 03.04.2022.
//

import UIKit
import Alamofire

class ViewController: UIViewController {
    
    private var arrayOfButtons = [UIButton]()
    private var arrayOfDrinks = [Drink]()
    
    private let scrollView: UIScrollView = {
        let v = UIScrollView()
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    private let customView: UIView = {
        let view = UIView()
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(scrollView)
        scrollView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        scrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        scrollView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        scrollView.addSubview(customView)
        self.view.backgroundColor = .white
        AF.request("https://www.thecocktaildb.com/api/json/v1/1/filter.php?a=Non_Alcoholic")
            .responseDecodable(of: All.self) { (response) in
                guard let drinks = response.value else { return }
                drinks.drinks.forEach({ self.arrayOfDrinks.append($0)})
            }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [self] in
            for i in 0..<arrayOfDrinks.count {
                arrayOfButtons.append(UIButton())
                self.customView.addSubview(self.arrayOfButtons[i])
                arrayOfButtons[i].setTitle(" \(arrayOfDrinks[i].strDrink) ", for: .normal)
                arrayOfButtons[i].backgroundColor = .systemGray
                arrayOfButtons[i].layer.cornerRadius = 8
                arrayOfButtons[i].addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
            }
            placeText()
        }
        
    }
    
    @objc func buttonAction(sender: UIButton!) {
        sender.applyGradient(colours: [.red, .purple]).cornerRadius = 8
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
            if widthOfButtons < widthOfScreen - 8 {
                arrayOfButtons[indexOfButton].frame = CGRect(x: widthOfButtons - arrayOfButtons[indexOfButton].sizeThatFits(UIScreen.main.bounds.size).width,
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
        }
        scrollView.contentSize = CGSize(width: UIScreen.main.bounds.size.width, height: 8 + (arrayOfButtons[arrayOfButtons.count - 1].sizeThatFits(UIScreen.main.bounds.size).height+8) * line)
        customView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 8 + (arrayOfButtons[arrayOfButtons.count - 1].sizeThatFits(UIScreen.main.bounds.size).height+8) * line)
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
