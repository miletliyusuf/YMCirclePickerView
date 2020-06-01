//
//  YMCirclePickerViewLayout.swift
//  YMCirclePickerView
//
//  Created by Yusuf Miletli on 31.05.2020.
//  Copyright © 2020 Miletli. All rights reserved.
//

import Foundation
import UIKit

// MARK: - YMCirclePickerViewLayoutPresentation

public struct YMCirclePickerViewLayoutPresentation {

    /// Collection Item Size
    var itemSize: CGSize

    /// Unselected Item Size
    var unselectedItemSize: CGSize?

    /// Spacing between items
    var spacing: CGFloat
}

// MARK: - YMCirclePickerViewLayout

public final class YMCirclePickerViewLayout: UICollectionViewFlowLayout {

    private var presentation: YMCirclePickerViewLayoutPresentation?

    /// Used to ignore bounds change when auto scrolling to certain cell
    var ignoringBoundsChange: Bool = false

    /// Layout init.
    /// - Parameter presentation: `YMCirclePickerViewLayoutPresentation`
    public convenience init(presentation: YMCirclePickerViewLayoutPresentation) {

        self.init()
        self.presentation = presentation
    }

    override init() {

        super.init()
        guard self.presentation != nil else {
            fatalError("Must init with `YMCirclePickerViewLayoutPresentation`")
        }
    }

    required init?(coder: NSCoder) {

        super.init(coder: coder)
    }

    // MARK: - Public Properties

    public override var collectionViewContentSize: CGSize {

        guard let presentation = self.presentation else { return .zero }
        let leftmostEdge = cachedItemsAttributes.values.map { $0.frame.minX }.min() ?? 0
        let rightmostEdge = cachedItemsAttributes.values.map { $0.frame.maxX }.max() ?? 0
        return CGSize(width: rightmostEdge - leftmostEdge, height: presentation.itemSize.height)
    }

    // MARK: - Private Properties
    private var cachedItemsAttributes: [IndexPath: UICollectionViewLayoutAttributes] = [:]

    private var selectedIndex = 0 {
        didSet {
            guard let collectionView = collectionView else { return }
            let indexPath = IndexPath(item: selectedIndex, section: 0)
            collectionView.delegate?.collectionView?(
                collectionView,
                didSelectItemAt: indexPath
            )
        }
    }

    private var continuousFocusedIndex: CGFloat {

        guard let collectionView = collectionView,
            let presentation = self.presentation else { return 0 }
        let offset = collectionView.bounds.width / 2 + collectionView.contentOffset.x - presentation.itemSize.width / 2
        let index = round(offset / (presentation.itemSize.width + presentation.spacing))
        if selectedIndex != Int(index) {
            selectedIndex = Int(index)
        }
        return index
    }

    // MARK: - Public Methods

    override public func prepare() {

        super.prepare()
        guard let collectionView = self.collectionView else { return }
        updateInsets()
        guard cachedItemsAttributes.isEmpty else { return }
        collectionView.decelerationRate = .fast
        let itemsCount = collectionView.numberOfItems(inSection: 0)
        for item in 0..<itemsCount {
            let indexPath = IndexPath(item: item, section: 0)
            cachedItemsAttributes[indexPath] = createAttributesForItem(at: indexPath)
        }
    }

    public override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {

        return cachedItemsAttributes
            .map { $0.value }
            .filter { $0.frame.intersects(rect) }
            .map { self.shiftedAttributes(from: $0) }
    }

    public override func targetContentOffset(
        forProposedContentOffset proposedContentOffset: CGPoint,
        withScrollingVelocity velocity: CGPoint
    ) -> CGPoint {

        guard let collectionView = collectionView else {
            return super.targetContentOffset(forProposedContentOffset: proposedContentOffset)
        }
        let collectionViewMidX: CGFloat = collectionView.bounds.size.width / 2
        guard let closestAttribute = findClosestAttributes(toXPosition: proposedContentOffset.x + collectionViewMidX) else {
            return super.targetContentOffset(forProposedContentOffset: proposedContentOffset)
        }
        return CGPoint(x: closestAttribute.center.x - collectionViewMidX, y: proposedContentOffset.y)
    }

    // MARK: - Invalidate layout

    public override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {

        if newBounds.size != collectionView?.bounds.size { cachedItemsAttributes.removeAll() }
        return !ignoringBoundsChange
    }

    public override func invalidateLayout(with context: UICollectionViewLayoutInvalidationContext) {

        if context.invalidateDataSourceCounts { cachedItemsAttributes.removeAll() }
        super.invalidateLayout(with: context)
    }

    // MARK: - Items

    public override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {

        guard let attributes = cachedItemsAttributes[indexPath] else { fatalError("No attributes cached") }
        return shiftedAttributes(from: attributes)
    }

    private func createAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {

        let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
        guard let collectionView = collectionView,
            let presentation = self.presentation else { return nil }
        attributes.frame.size = presentation.itemSize
        attributes.frame.origin.y = (collectionView.bounds.height - presentation.itemSize.height) / 2
        attributes.frame.origin.x = CGFloat(indexPath.item) * (presentation.itemSize.width + presentation.spacing)
        return attributes
    }

    private func shiftedAttributes(from attributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {

        guard let attributes = attributes.copy() as? UICollectionViewLayoutAttributes,
            let presentation = self.presentation else {
            fatalError("Couldn't copy attributes")
        }
        let roundedFocusedIndex = round(continuousFocusedIndex)
        guard attributes.indexPath.item != Int(roundedFocusedIndex) else { return attributes }
        if let unselectedSize = presentation.unselectedItemSize {
            let xRatio = unselectedSize.width / presentation.itemSize.width
            let yRatio = unselectedSize.height / presentation.itemSize.height
            attributes.transform = CGAffineTransform(scaleX: xRatio, y: yRatio)
        }
        return attributes
    }

    // MARK: - Private Methods

    private func findClosestAttributes(toXPosition xPosition: CGFloat) -> UICollectionViewLayoutAttributes? {

        guard let collectionView = collectionView else { return nil }
        let searchRect = CGRect(
            x: xPosition - collectionView.bounds.width, y: collectionView.bounds.minY,
            width: collectionView.bounds.width * 2, height: collectionView.bounds.height
        )
        return layoutAttributesForElements(in: searchRect)?.min(
            by: { abs($0.center.x - xPosition) < abs($1.center.x - xPosition) }
        )
    }

    private func updateInsets() {

        guard let collectionView = collectionView,
            let presentation = self.presentation else { return }
        collectionView.contentInset.left = (collectionView.bounds.size.width - presentation.itemSize.width) / 2
        collectionView.contentInset.right = (collectionView.bounds.size.width - presentation.itemSize.width) / 2
    }
}
