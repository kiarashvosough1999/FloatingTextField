//
//  String++Extension.swift
//  FloatingTextField (iOS)
//
//  Created by Kiarash Vosough on 3/18/22.
//

import Foundation

extension String {
    
    var withSingleTrailingSpace:  String {
        appending(" ")
    }
    
    var withSingleLeadingSpace:  String {
        " " + self
    }
}
