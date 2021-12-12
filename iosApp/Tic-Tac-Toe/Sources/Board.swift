class Board {

    // MARK: - Private Properties

    private let boardCells: [Player?]

    // MARK: - Init

    init(size: Int = 0) {
        boardCells = .init(repeatElement(nil, count: size))
    }

    // MARK: - Subscript

    subscript(_ position: Int) -> Player? {
        guard (position > 0) && (position < boardCells.count) else {
            return nil
        }

        return boardCells[position]
    }

}
