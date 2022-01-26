//
//  TodayInfo.swift
//  Savings365
//
//  Created by apple on 2022/1/25.
//

import Foundation

struct TodayInfo: Codable {
    let number: Int // 今日数字
    let date: String // 日期（"yyyy-MM-dd"）
    var checked: Bool // 是否已完成
}
