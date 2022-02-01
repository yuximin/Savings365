//
//  TodayInfo.swift
//  Savings365
//
//  Created by apple on 2022/1/25.
//

import Foundation

struct TodayInfo: Codable {
    var number: Int // 今日数字
    var date: Date // 日期
    var checked: Bool // 是否已完成
}
