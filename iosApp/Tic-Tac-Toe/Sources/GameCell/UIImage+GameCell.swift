import UIKit

extension UIImage {

    enum GameCell {

        static var crossImage: UIImage {
            return .init(named: "cross", in: .main, with: nil) ?? UIImage()
        }

        static var circleImage: UIImage {
            return .init(named: "circle", in: .main, with: nil) ?? UIImage()
        }

    }

}
