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
    var unselectedItemSize: CGSize

    /// Spacing between items
    var spacing: CGFloat

    var initialIndex: Int?

    public init(
        itemSize: CGSize,
        unselectedItemSize: CGSize,
        spacing: CGFloat,
        initialIndex: Int? = nil
    ) {

        self.itemSize = itemSize
        self.unselectedItemSize = unselectedItemSize
        self.spacing = spacing
        self.initialIndex = initialIndex
    }
}

// MARK: - YMCirclePickerViewLayout

public final class YMCirclePickerViewLayout: UICollectionViewFlowLayout {

    private var presentation: YMCirclePickerViewLayoutPresentation?

    /// Layout init.
    /// - Parameter presentation: `YMCirclePickerViewLayoutPresentation`
    public convenience init(presentation: YMCirclePickerViewLayoutPresentation) {

        self.init()
        self.presentation = presentation
        self.selectedIndex = presentation.initialIndex ?? 0
    }

    override init() {

        super.init()
    }

    required init?(coder: NSCoder) {

        super.init(coder: coder)
    }

    // MARK: - Public Properties

    public override var collectionViewContentSize: CGSize {

        let leftmostEdge = cachedItemsAttributes.values.map { $0.frame.minX }.min() ?? 0
        let rightmostEdge = cachedItemsAttributes.values.map { $0.frame.maxX }.max() ?? 0
        return CGSize(width: rightmostEdge - leftmostEdge, height: collectionView?.frame.size.height ?? 0.0)
    }

    // MARK: - Private Properties
    private var cachedItemsAttributes: [IndexPath: UICollectionViewLayoutAttributes] = [:]

    public var selectedIndex = 0

    private var continuousFocusedIndex: CGFloat {

        guard let collectionView = collectionView,
            let presentation = self.presentation,
            !cachedItemsAttributes.isEmpty else { return 0 }

        let offset = collectionView.bounds.width / 2 + collectionView.contentOffset.x - presentation.itemSize.width / 2
        let index = round(offset / (presentation.itemSize.width + presentation.spacing))
        let count = cachedItemsAttributes.count - 1
        var safeIndex = Int(index)
        if safeIndex > count { safeIndex = count }
        if safeIndex < 0 { safeIndex = 0 }
        if selectedIndex != safeIndex {
            selectedIndex = safeIndex
        }
        return CGFloat(safeIndex)
    }

    // MARK: - Public Methods

    // Called whenever layout is invalidated.
    override public func prepare() {

        super.prepare()
        guard let collectionView = self.collectionView,
            cachedItemsAttributes.isEmpty else { return }
        updateInsets()
        let itemsCount = collectionView.numberOfItems(inSection: 0)
        for item in 0..<itemsCount {
            let indexPath = IndexPath(item: item, section: 0)
            cachedItemsAttributes[indexPath] = createAttributesForItem(at: indexPath)
        }
    }

    private func updateInsets() {

        guard let collectionView = collectionView,
            let presentation = self.presentation else { return }
        let horizontalInset = (collectionView.bounds.size.width - presentation.itemSize.width) / 2
        collectionView.contentInset.left = horizontalInset
        collectionView.contentInset.right = horizontalInset
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
        return true
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
        let xRatio = presentation.unselectedItemSize.width / presentation.itemSize.width
        let yRatio = presentation.unselectedItemSize.height / presentation.itemSize.height
        attributes.transform = CGAffineTransform(scaleX: xRatio, y: yRatio)
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
}
