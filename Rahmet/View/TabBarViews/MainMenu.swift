//
//  MainMenu.swift
//  Rahmet
//
//  Created by Arman on 09.02.2022.
//
import UIKit
import SnapKit

class MainMenu: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .secondarySystemBackground
        setupNavigationBar()
        setupViews()
        setupConstraints()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    var fakeData: [Cafe] = [
        Cafe(name: "Del Papa", address: "ул. Бухар жырау, 66, уг. ул. Ауэзова", imgName: "cafeImage"),
        Cafe(name: "Del Papa2", address: "ул. Бухар жырау, 66, уг. ул. Ауэзова", imgName: "cafeImage"),
        Cafe(name: "Del Papa3", address: "ул. Бухар жырау, 66, уг. ул. Ауэзова", imgName: "cafeImage"),
        Cafe(name: "Del Papa4", address: "ул. Бухар жырау, 66, уг. ул. Ауэзова", imgName: "cafeImage"),
        Cafe(name: "Del Papa5", address: "ул. Бухар жырау, 66, уг. ул. Ауэзова", imgName: "cafeImage"),
        Cafe(name: "Del Papa6", address: "ул. Бухар жырау, 66, уг. ул. Ауэзова", imgName: "cafeImage")
    ]
    
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
}

extension MainMenu: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        fakeData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cafeCell", for: indexPath) as! CafeCell
        cell.cafe = fakeData[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       return 120
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
