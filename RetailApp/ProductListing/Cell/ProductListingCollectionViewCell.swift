import UIKit

class ProductListingCollectionViewCell: UICollectionViewCell {
  @IBOutlet private(set) var imageView: UIImageView!
  @IBOutlet private var titleLabel: UILabel!
  @IBOutlet private var priceLabel: UILabel!
  private lazy var service = ImageServiceImplementation(api: API())

  override func prepareForReuse() {
    super.prepareForReuse()
    imageView.image = nil
    titleLabel.text = nil
    priceLabel.text = nil
  }

  func configure(imageKey: String, title: String, price: NSAttributedString) {
    service.downloadImage(key: imageKey) { [weak self] result in
      switch result {
      case .value(let image):
        self?.imageView.image = image
      case .error(let error):
        print(error)
      }
    }
    titleLabel.text = title
    priceLabel.attributedText = price
  }
}
