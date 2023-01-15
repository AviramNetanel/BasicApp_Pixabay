//
//  BindingExtension.swift
//  Basic
//
//  Created by Aviram on 14/1/23.
//

import Foundation
import SwiftUI

extension Binding {
     func unwrappedInt32<T>() -> Binding<T> where Value == Int32  {
         Binding<T>(get: { self.wrappedValue as! T },
                    set: { self.wrappedValue = $0 as! Int32 })
    }
}
