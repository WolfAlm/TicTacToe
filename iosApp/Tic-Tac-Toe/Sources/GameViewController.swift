import UIKit

struct Player: Equatable {

    enum ShapeType {
        case circle
        case cross
    }

    let type: ShapeType
    let color: UIColor

}

final class GameViewController: UIViewController {

    // MARK: - Private Types

    private typealias GameCellImage = UIImage.GameCell

    private enum Constants {

        enum Board {

            static var cellCount: Int {
                return rowsCount * columnsCount
            }

            static var rowsCount: Int {
                return 3
            }

            static var columnsCount: Int {
                return 3
            }

            static var screenPadding: CGFloat {
                return 8.0
            }

            static var interitemSpacing: CGFloat {
                return 0
            }

            static var lineSpacing: CGFloat {
                return 0
            }

            static var border: (width: CGFloat, color: CGColor) {
                return (2.0, UIColor.black.cgColor)
            }

        }

        enum Image {

            static var crossImage: UIImage {
                return .init(named: "arrow_right", in: .main, with: nil) ?? UIImage()
            }

        }

        static var screenWidth: CGFloat {
            return UIScreen.main.bounds.width
        }

    }

    // MARK: - Private Properties

    private let players: [Player] = [
        .init(type: .circle, color: .systemGreen),
        .init(type: .cross, color: .systemBlue)
    ]

    private var cellsLayer: CAShapeLayer? {
        didSet {
            guard let cellsLayer = cellsLayer else {
                return
            }

            guard let oldValue = oldValue else {
                gameBoardCollectionView.layer.addSublayer(cellsLayer)
                return
            }

            gameBoardCollectionView.layer.replaceSublayer(oldValue, with: cellsLayer)
        }
    }

    private lazy var currentPlayer: Player = players.first! {
        didSet {
            switch currentPlayer.type {
                case .circle:
                    currentPlayerInfoView.image = Constants.Image.crossImage.withHorizontallyFlippedOrientation()

                case .cross:
                    currentPlayerInfoView.image = Constants.Image.crossImage
            }
        }
    }

    private var board = Board()

    // MARK: Outlets

    @IBOutlet private weak var gameBoardCollectionView: UICollectionView!
    @IBOutlet weak var firstPlayerInfoView: UIImageView!
    @IBOutlet weak var secondPlayerInfoView: UIImageView!
    @IBOutlet weak var currentPlayerInfoView: UIImageView!

    // MARK: - Internal Methods

    // MARK: Overrides

    override func viewDidLoad() {
        super.viewDidLoad()

        currentPlayer = players.randomElement()!
        board = .init(size: Constants.Board.cellCount)
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()

        players.forEach { configureInfoView(for: $0) }
        configureGameBoardCollectionView()
    }

    // MARK: - Private Methods

    private func configureInfoView(for player: Player) {
        switch player.type {
            case .circle:
                firstPlayerInfoView.image = GameCellImage.circleImage
                firstPlayerInfoView.tintColor = player.color

            case .cross:
                secondPlayerInfoView.image = GameCellImage.crossImage
                secondPlayerInfoView.tintColor = player.color
        }
    }

    private func configureGameBoardCollectionView() {
        gameBoardCollectionView.layer.borderWidth = Constants.Board.border.width
        gameBoardCollectionView.layer.borderColor = Constants.Board.border.color

        cellsLayer = createCellsLayer()
    }

    private func createCellsLayer() -> CAShapeLayer {
        let path = UIBezierPath()
        let delta = gameBoardCollectionView.frame.width / CGFloat(Constants.Board.rowsCount)

        for i in 1..<(Constants.Board.rowsCount) {
            path.move(to: CGPoint(x: 0.0, y: delta * CGFloat(i)))
            path.addLine(to: CGPoint(x: gameBoardCollectionView.frame.width, y: delta * CGFloat(i)))
        }

        for i in 1..<(Constants.Board.columnsCount) {
            path.move(to: CGPoint(x: delta * CGFloat(i), y: 0.0))
            path.addLine(to: CGPoint(x: delta * CGFloat(i), y: gameBoardCollectionView.frame.height))
        }

        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.strokeColor = Constants.Board.border.color
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineWidth = Constants.Board.border.width

        return shapeLayer
    }

}

// MARK: - Protocol UICollectionViewDataSource

extension GameViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Constants.Board.cellCount
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GameCell.cellIdentifier, for: indexPath) as? GameCell else {
            return UICollectionViewCell()
        }

        cell.configure(for: board[indexPath.row])

        return cell
    }

}

// MARK: - Protocol UICollectionViewDelegate

extension GameViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? GameCell, !cell.isFilled else {
            return
        }

        cell.configure(for: currentPlayer)

        let currentPlayerIndex = players.firstIndex { $0 == currentPlayer } ?? 0
        currentPlayer = (currentPlayerIndex != players.count - 1) ? players[currentPlayerIndex + 1] : players[0]
    }

}

// MARK: - Protocol UICollectionViewDelegateFlowLayout

extension GameViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let collectionCellDimension = (Constants.screenWidth - Constants.Board.screenPadding * 2) / 3

        return CGSize(width: collectionCellDimension, height: collectionCellDimension)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return Constants.Board.lineSpacing
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return Constants.Board.interitemSpacing
    }

}
