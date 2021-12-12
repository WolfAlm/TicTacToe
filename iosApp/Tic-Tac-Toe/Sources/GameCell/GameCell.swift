import UIKit

class GameCell: UICollectionViewCell {

    // MARK: - Private Types

    typealias Image = UIImage.GameCell

    // MARK: - Internal Properties

    static var cellIdentifier: String {
        return "GameCell"
    }

    // MARK: - Internal Properties

    var isFilled: Bool = false

    // MARK: - Private Properties

    @IBOutlet private weak var shapeImageView: UIImageView!

    // MARK: - Internal Methods

    func configure(for player: Player?) {
        guard let player = player else {
            isFilled = false
            return
        }

        switch player.type {
            case .cross:
                shapeImageView.image = Image.crossImage

            case .circle:
                shapeImageView.image = Image.circleImage
        }

        shapeImageView.tintColor = player.color
        isFilled = true
    }

}
