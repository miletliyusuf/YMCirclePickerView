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

protocol NibLoadable: class {

    static var nib: UINib { get }
}

extension NibLoadable {

    static var nib: UINib {

        return UINib(nibName: String(describing: self), bundle: Bundle(for: self))
    }
}

// MARK: NibLoadble's UIView extension

extension NibLoadable where Self: UIView {

    /// Returns UIView object instantiated from nib.
    static func instanceFromNib() -> Self {

        guard let view = nib.instantiate(withOwner: nil, options: nil).first as? Self else {
            fatalError("The nib \(nib) expected it's root view to be of type \(self)")
        }
        return view
    }
}

extension UIView {
    /// Eventhough we already set the file owner in the xib file, where we are setting the file owner again because sending nil will set existing file owner to nil.
    @discardableResult
    func fromNib<T : UIView>() -> T? {
        guard let contentView = Bundle(for: type(of: self))
            .loadNibNamed(String(describing: type(of: self)), owner: self, options: nil)?.first as? T else {
                return nil
        }
        return contentView
    }
}
