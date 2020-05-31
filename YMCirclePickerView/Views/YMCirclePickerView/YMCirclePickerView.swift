//
//  YMCirclePickerView.swift
//  YMCirclePickerView
//
//  Created by Yusuf Miletli on 31.05.2020.
//  Copyright © 2020 Miletli. All rights reserved.
//

import Foundation
import UIKit

// MARK: - YMCirclePickerView

public struct YMCirclePickerViewPresentation {

    public var presentation: YMCirclePickerViewLayoutPresentation
}

// MARK: - YMCirclePickerViewDelegate

public protocol YMCirclePickerViewDelegate: AnyObject {

    func ymCirclePickerView(ymCirclePickerView: YMCirclePickerView, didSelectItemAt index: Int)
}

public extension YMCirclePickerViewDelegate {

    func ymCirclePickerView(ymCirclePickerView: YMCirclePickerView, didSelectItemAt index: Int) {}
}

// MARK: - YMCirclePickerView

public class YMCirclePickerView: UIView {

    // MARK: - Outlets

    // MARK: - Properties

    weak var delegate: YMCirclePickerViewDelegate? = nil

    var presentation: YMCirclePickerViewPresentation? {
        didSet {
            updateUI()
        }
    }

    // MARK: - Lifecycle

    private func updateUI() {

        // TODO
    }
}
