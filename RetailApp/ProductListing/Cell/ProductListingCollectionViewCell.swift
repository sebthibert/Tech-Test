import UIKit

class ProductListingCollectionViewCell: UICollectionViewCell {
  @IBOutlet private(set) var productImageView: UIImageView!
  @IBOutlet private var badgeImageView: UIImageView!
  @IBOutlet private var titleLabel: UILabel!
  @IBOutlet private var priceLabel: UILabel!
  private lazy var service = ImageServiceImplementation(api: API())

  override func prepareForReuse() {
    super.prepareForReuse()
    productImageView.image = nil
    badgeImageView.image = nil
    titleLabel.text = nil
    priceLabel.text = nil
  }

  func configure(imageKey: String, title: String, price: NSAttributedString, badge: String?) {
    service.downloadImage(key: imageKey) { [weak self] result in
      do {
        self?.productImageView.image = try result.unwrapped()
      } catch {
        print(error.localizedDescription)
      }
    }
    titleLabel.text = title
    priceLabel.attributedText = price
    if let badge = badge {
      badgeImageView.isHidden = false
      service.downloadImage(key: "\(badge)_icon") { [weak self] result in
        do {
          self?.badgeImageView.image = try result.unwrapped()
        } catch {
          print(error.localizedDescription)
        }
      }
    }
  }
}
