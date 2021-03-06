//
//  CartViewController.swift
//  Rahmet
//
//  Created by Elvina Shamoi on 18.02.2022.
//

import UIKit
import SwiftUI
import Alamofire

class CartViewController: UIViewController {

    let tableView = UITableView()
    var cartProducts: [CartItem] = []
    var restaurant: RestaurantDataModel? = RestaurantDataModel()
    var delegate: CartChangingDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupViews()
        setupConstraints()
    }

    let cafeNameView: ParametersView = {
        var view = ParametersView()
        view.mainLabel.textColor = .black
        view.mainLabel.font = .boldSystemFont(ofSize: 16)
        view.subLabel.textColor = .gray
        return view
    }()
    
    let orderLabel: UILabel = {
        var label = UILabel()
        label.font = .boldSystemFont(ofSize: 16)
        label.text = "Мой заказ"
        return label
    }()
    
    lazy var paymentButton = BlueButton(text: "Оплатить", rightText: "", leftText: "", isActive: true)
    
    @objc func payTapped() {
        var products: [OrderCreateProduct] = []
        for product in cartProducts {
            products.append(OrderCreateProduct(id: product.product.id, quantity: product.quantity))
        }
        let order: OrderInput = OrderInput(restaurantID: self.restaurant?.restaurantData?.id, products: products)
        sendData(order: order)
    }
    
    func sendData(order: OrderInput) {
        APIClient.postOrder(order: order) { result in
            switch result {
            case .success(let message):
                print(message)
                self.showAlert(title: "Готово", message: "Заказ успешно создан!")
                self.cartProducts.removeAll()
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Окей", style: UIAlertAction.Style.default, handler: { action in
            let vc = MainTabBarController()
            self.navigationController?.popToRootViewController(animated: true)
        }))
        self.present(alert, animated: true, completion: nil)
    }
}
    
extension Dictionary {
    func percentEncoded() -> Data? {
        return map { key, value in
            let escapedKey = "\(key)".addingPercentEncoding(withAllowedCharacters: .urlQueryValueAllowed) ?? ""
            let escapedValue = "\(value)".addingPercentEncoding(withAllowedCharacters: .urlQueryValueAllowed) ?? ""
            return escapedKey + "=" + escapedValue
        }
        .joined(separator: "&")
        .data(using: .utf8)
    }
}


extension CharacterSet {
    static let urlQueryValueAllowed: CharacterSet = {
        let generalDelimitersToEncode = ":#[]@" // does not include "?" or "/" due to RFC 3986 - Section 3.4
        let subDelimitersToEncode = "!$&'()*+,;="

        var allowed = CharacterSet.urlQueryAllowed
        allowed.remove(charactersIn: "\(generalDelimitersToEncode)\(subDelimitersToEncode)")
        return allowed
    }()
}
    

extension CartViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cartProducts.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if isLastRow(row: indexPath.row) {
            let cell = tableView.dequeueReusableCell(withIdentifier: OrderPositionsCell.reuseId, for: indexPath) as! OrderPositionsCell
            cell.leftLabel.text = "Итого"
            cell.leftLabel.font = .boldSystemFont(ofSize: 14)
            cell.rightLabel.text = "\(countTotalSum()) тг"
            cell.rightLabel.font = .boldSystemFont(ofSize: 14)
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: MenuItemCell.reuseId, for: indexPath) as! MenuItemCell
        cell.num = cartProducts[indexPath.row].quantity
        cell.cartItem = cartProducts[indexPath.row]
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if isLastRow(row: indexPath.row) {
            return 80
        }
        return 170
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension CartViewController: CartChangingDelegate {
    func reloadCart(cart: [CartItem]?) {
        
    }
    
    func changeQuantity(product: Product, quantity: Int) {
        let index = cartProducts.firstIndex { $0.product == product }
        if let index = index {
            cartProducts[index].quantity = quantity
            if quantity == 0 {
                cartProducts.remove(at: index)
            }
        }
        delegate?.changeQuantity(product: product, quantity: quantity)
        delegate?.reloadCart(cart: cartProducts)
        tableView.reloadData()
    }
}

extension CartViewController: LayoutForNavigationVC {
    
    func setupViews() {
        paymentButton.addTarget(self, action: #selector(payTapped), for: .touchUpInside)
        cafeNameView.mainLabel.text = restaurant?.restaurantData?.name
        cafeNameView.subLabel.text = restaurant?.restaurantData?.location
        self.tabBarController?.tabBar.isHidden = true
        view.backgroundColor = .white
        tableView.register(MenuItemCell.self, forCellReuseIdentifier: MenuItemCell.reuseId)
        tableView.register(OrderPositionsCell.self, forCellReuseIdentifier: OrderPositionsCell.reuseId)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.allowsSelection = false
        tableView.delaysContentTouches = false
        [cafeNameView, orderLabel, tableView, paymentButton].forEach {
            view.addSubview($0)
        }
    }
    
    func setupConstraints() {
        
        cafeNameView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(Constants.screenHeight / 4)
        }
        
        orderLabel.snp.makeConstraints { make in
            make.top.equalTo(cafeNameView.snp.bottom).offset(40)
            make.right.equalToSuperview()
            make.left.equalTo(15)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(orderLabel.snp.bottom).offset(15)
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview().offset(120)
        }
        
        paymentButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(20)
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(48)
        }
        
    }
    
    func setupNavigationBar() {
        self.title = "Корзина"
    }
    
    func countTotalSum() -> Int {
        var sum = 0
        for i in cartProducts {
            sum += (i.product.price ?? 0) * i.quantity
        }
        return sum
    }
    
    func isLastRow(row: Int) -> Bool {
        return row == cartProducts.count
    }
}
