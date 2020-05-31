//
//  NibLoadable.swift
//  YMCirclePickerView
//
//  Created by Yusuf Miletli on 31.05.2020.
//  Copyright © 2020 Miletli. All rights reserved.
//

import Foundation
import UIKit

// MARK: - NibLoadable

public protocol NibLoadable: class {

    static var nib: UINib { get }
}

public extension NibLoadable {

    static var nib: UINib {

        return UINib(nibName: String(describing: self), bundle: Bundle(for: self))
    }
}

// MARK: NibLoadble's UIView extension

public extension NibLoadable where Self: UIView {

    /// Returns UIView object instantiated from nib.
    static func instanceFromNib() -> Self {

        guard let view = nib.instantiate(withOwner: nil, options: nil).first as? Self else {
            fatalError("The nib \(nib) expected it's root view to be of type \(self)")
        }
        return view
    }
}
