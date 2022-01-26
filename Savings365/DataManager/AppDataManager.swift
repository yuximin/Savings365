//
//  AppDataManager.swift
//  Savings365
//
//  Created by apple on 2022/1/25.
//

import Foundation

class AppDataManager {
    
    // MARK: - cache key
    
    static let DataPoolCacheKey = "DataPoolCacheKey"
    static let TodayInfoCacheKey = "TodayInfoCacheKey"
    static let CheckedListCacheKey = "CheckedListCacheKey"
    
    // MARK: 单例
    static let shared = AppDataManager()
    
    // MARK: - 属性
    
    /// 今日目标
    var todayInfo: TodayInfo {
        get {
            getTodayInfo()
        }
        
        set {
            setTodayInfoCache(newValue)
        }
    }
    
    /// 数据池
    var dataPool: [TodayInfo] {
        getDataPool()
    }
    
    /// 已完成数据池
    var checkedDataPool: [TodayInfo] {
        dataPool.filter { $0.checked }
    }
    
    /// 未完成数据池
    var uncheckDataPool: [TodayInfo] {
        dataPool.filter { !$0.checked }
    }
    
    // MARK: - 数据池
    
    /// 获取数据池
    private func getDataPool() -> [TodayInfo] {
        if let dataPool = getDataPoolCache() {
            return dataPool
        }
        
        let dataPool = createNewDataPool()
        setDataPoolCache(dataPool)
        return dataPool
    }
    
    /// 创建新的数据池
    private func createNewDataPool() -> [TodayInfo] {
        var dataPool = [TodayInfo]()
        for i in 1...365 {
            let info = TodayInfo(number: i, date: "", checked: false)
            dataPool.append(info)
        }
        return dataPool
    }
    
    /// 获取缓存的数据池
    func getDataPoolCache() -> [TodayInfo]? {
        guard let data = UserDefaults.standard.value(forKey: AppDataManager.DataPoolCacheKey) as? Data else {
            return nil
        }
        
        let cacheList = try? JSONDecoder().decode([TodayInfo].self, from: data)
        return cacheList
    }
    
    /// 设置数据缓存池
    func setDataPoolCache(_ infoList: [TodayInfo]) {
        let encoded = try? JSONEncoder().encode(infoList)
        UserDefaults.standard.set(encoded, forKey: AppDataManager.DataPoolCacheKey)
    }
    
    /// 更新数据缓存池
    func updateItemForDataPoolCache(_ info: TodayInfo) {
        guard let cachePool = getDataPoolCache() else {
            return
        }
        
        let dataPool = cachePool.map { $0.number == info.number ? info : $0 }
        setDataPoolCache(dataPool)
    }
    
    // MARK: - 今日数据
    
    /// 获取今日数据
    private func getTodayInfo() -> TodayInfo {
        if let cacheTodayInfo = getTodayInfoCache(), cacheTodayInfo.date == formatDate(Date()) {
            return cacheTodayInfo
        }
        
        return resetTodayInfo()
    }
    
    /// 重随今日数据
    @discardableResult func resetTodayInfo() -> TodayInfo {
        let info = createNewTodayInfo()
        self.todayInfo = info
        return info
    }
    
    /// 生成新的今日数据
    private func createNewTodayInfo() -> TodayInfo {
        let dataPool = uncheckDataPool
        let index = Int(arc4random()) % dataPool.count
        let info = dataPool[index]
        return info
    }
    
    /// 获取今日信息缓存
    private func getTodayInfoCache() -> TodayInfo? {
        guard let data = UserDefaults.standard.value(forKey: AppDataManager.TodayInfoCacheKey) as? Data else {
            return nil
        }
        
        let info = try? JSONDecoder().decode(TodayInfo.self, from: data)
        return info
    }
    
    /// 设置今日信息缓存
    private func setTodayInfoCache(_ info: TodayInfo) {
        let encoded = try? JSONEncoder().encode(info)
        UserDefaults.standard.set(encoded, forKey: AppDataManager.TodayInfoCacheKey)
        UserDefaults.standard.synchronize()
    }
    
    // MARK: -
    
    /// 格式化时间
    func formatDate(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.string(from: date)
    }
    
    /// 清除 UserDefaults 所有数据
    func clearAllUserDefaultsData(){
       let userDefaults = UserDefaults.standard
       let dics = userDefaults.dictionaryRepresentation()
       for key in dics {
           userDefaults.removeObject(forKey: key.key)
       }
       userDefaults.synchronize()
    }
}
