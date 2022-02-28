//
//  MainMenu.swift
//  Rahmet
//
//  Created by Arman on 09.02.2022.
//

import UIKit
import SnapKit
import Alamofire

class MainMenu: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .secondarySystemBackground
        fetchData()
        setupNavigationBar()
        setupViews()
        setupConstraints()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    var fakeData: [Cafe] = [
        Cafe(name: "Del Papa", address: "ул. Бухар жырау, 66, уг. ул. Ауэзова", imgName: "cafeImage"),
        Cafe(name: "Ресторан «Свет»", address: "ул. Кабанбай батыра 83", imgName: "rest1"),
        Cafe(name: "Mamma mia", address: "ул. Панфилова 109", imgName: "rest2"),
        Cafe(name: "Bahandi Burger", address: "ул. Байтурсынова 61", imgName: "rest3"),
        Cafe(name: "Mamma mia", address: "ул. Панфилова 109", imgName: "rest4")
    ]
    
    var restaurants: [Restaurant] = []
    
    var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = true
        return tableView
    }()
}


extension MainMenu: LayoutForNavigationVC {
    func setupConstraints() {
        tableView.snp.makeConstraints { make in
            make.left.right.top.bottom.equalToSuperview()
        }
    }
    
    func setupNavigationBar() {
        navigationItem.title = "Заказ с собой"
    }
    
    func setupViews() {
        view.addSubview(tableView)
        tableView.register(CafeCell.self, forCellReuseIdentifier: "cafeCell")
    }
    
    func fetchData() {
        AF.request("http://142.93.107.238/api/restaurants")
          .validate()
          .responseDecodable(of: [Restaurant].self) { (response) in
            guard let rests = response.value else { return }
              self.restaurants = rests
              self.tableView.reloadData()
          }
      }
}

extension MainMenu: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        fakeData.count
        restaurants.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cafeCell", for: indexPath) as! CafeCell
//        cell.cafe = fakeData[indexPath.row]
        cell.cafe = restaurants[indexPath.row].restaurant
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       return 120
    }

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
//        let cafe = fakeData[indexPath.row]
        let cafe = restaurants[indexPath.row]
        navigationController?.pushViewController(Menu(cafe: cafe), animated: false)
    }

}



import SwiftUI

struct MainMenuProvider: PreviewProvider {
    static var previews: some View {
        ContainerView().edgesIgnoringSafeArea(.all)
    }
    
    struct ContainerView: UIViewControllerRepresentable {
        let menuVC = MainTabBarController()
        
        func makeUIViewController(context: Context) -> some UIViewController {
            return menuVC
        }
        
        func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
            
        }
    }
}