//
//  TimeInterval+Extension.swift
//  CGAssessment
//
//  Created by Diego Henrique Silva Oliveira on 03/10/23.
//

import Foundation

extension TimeInterval {

    static var minute: TimeInterval { 60 }
    static var hour: TimeInterval { minute * 60 }
    static var day: TimeInterval { hour * 24 }
    static var week: TimeInterval { day * 7 }

}
