//
//  TodayInfo.swift
//  Savings365
//
//  Created by apple on 2022/1/25.
//

import Foundation

struct TodayInfo: Codable {
    var number: Int // 今日数字
    var date: String // 日期（"yyyy-MM-dd"）
    var checked: Bool // 是否已完成
}
