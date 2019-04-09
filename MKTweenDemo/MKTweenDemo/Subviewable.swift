import Foundation

protocol Subviewable {
    func setupSubviews()
    func setupStyles()
    func setupHierarchy()
    func setupAutoLayout()
}

extension Subviewable {
    func setup() {
        setupSubviews()
        setupStyles()
        setupHierarchy()
        setupAutoLayout()
    }
}
