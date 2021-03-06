//
//  MenuItemCell.swift
//  Rahmet
//
//  Created by Arman on 04.03.2022.
//

import UIKit
import SDWebImage

class MenuItemCell: UITableViewCell {
    
    static let reuseId: String = "MenuItemCell"
    
    var cartItem: CartItem? {
        didSet {
            guard let cartItem = cartItem else {return}
            if let name = cartItem.product.name {
                nameLabel.text = name
            }
            if let desc = cartItem.product.description {
                descriptionLabel.text = desc
            }
            if let imageName = cartItem.product.image {
                if let url = URL(string: imageName) {
                    productImageView.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "dish"), options: [.continueInBackground, .progressiveLoad], completed: nil)
                }
            }
            if let price = cartItem.product.price {
                priceLabel.text = "\(price) тг"
            }
            counterView.cnt = num
        }
    }
    
    var num: Int = 0 {
        didSet {
            counterView.cnt = num
        }
    }
    var delegate: CartChangingDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func layoutSubviews() {
        setupViews()
        setupConstraints()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        guard let item = cartItem else {return}
//        delegate?.changeQuantity(product: item.product, quantity: counterView.cnt)
    }

    let productImageView: UIImageView = {
        let img = UIImageView()
        img.contentMode = .scaleAspectFill
        img.layer.cornerRadius = 10
        img.clipsToBounds = true
        img.contentMode = .scaleAspectFit
        return img
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = .black
        label.numberOfLines = 0
        return label
    }()
    
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .black
        label.clipsToBounds = true
        label.numberOfLines = 0
        return label
    }()
    
    let priceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .systemBlue
        label.clipsToBounds = true
        label.numberOfLines = 0
        return label
    }()
    
    let stackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = 5
        return view
    }()
    
    lazy var counterView = CounterView()
    
    func setupViews() {
        counterView.didSelectItem = {
            let cnt = self.counterView.cnt
            self.num = cnt
//            print(cnt, self.num)
            guard let product = self.cartItem?.product else { return }
            self.delegate?.changeQuantity(product: product, quantity: self.num)
        }
        counterView.layer.backgroundColor = UIColor.secondarySystemBackground.cgColor
        counterView.layer.cornerRadius = 10
        [nameLabel, descriptionLabel, priceLabel].forEach { stackView.addArrangedSubview($0)}
        [productImageView, stackView, counterView].forEach { contentView.addSubview($0) }
    }
    
    func setupConstraints() {
        stackView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(20)
            make.right.equalTo(productImageView.snp.left).offset(-15)
            make.top.equalToSuperview().offset(8)
        }

        productImageView.snp.makeConstraints { make in
            make.left.equalTo(Constants.screenWidth * 0.72)
            make.right.equalToSuperview().inset(15)
            make.centerY.equalToSuperview()
            make.height.equalTo(80)
        }
        counterView.snp.makeConstraints { make in
            make.width.equalTo(productImageView.width).inset(20)
            make.left.right.equalTo(productImageView).inset(5)
            make.bottom.equalTo(productImageView.snp_bottomMargin)
            make.height.equalTo(30)
        }
    }
}




//import SwiftUI
//struct MenuViewCellProvider: PreviewProvider {
//    static var previews: some View {
//        ContainerView().edgesIgnoringSafeArea(.all)
//    }
//    struct ContainerView: UIViewControllerRepresentable {
//        let menuVC = MenuViewController(restaurant: Restaurant(restaurant: RestaurantDataModel(restaurantData: DetailedRestaurant(id: 1, name: "Mamma Mia", location: "Baker Street 221B", createdAt: "20.02.2022", updatedAt: "20.02.2022", images: []), image: nil)))
//        func makeUIViewController(context: Context) -> some UIViewController {
//            return NavigationVCGenerator.generateNavigationController(rootViewController: menuVC, image: UIImage(), title: "Title", prefersLargeTitle: true)
//        }
//        func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
//        }
//    }
//}
