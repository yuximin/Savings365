//
//  HistoryViewController.swift
//  Savings365
//
//  Created by apple on 2022/1/26.
//

import UIKit

class HistoryViewController: UIViewController {
    
    private var checkDatas: [TodayInfo] {
        AppDataManager.shared.checkedDataPool.sorted { $0.date > $1.date}
    }
    
    private var allDatas: [TodayInfo] {
        AppDataManager.shared.dataPool
    }
    
    /// 总金额
    private var totalAmount: Int {
        var amount = 0
        for item in checkDatas {
            amount += item.number
        }
        return amount
    }

    // MARK: - lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupUI()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        amountLab.text = "总额: \(totalAmount)"
    }
    
    // MARK: - UI
    
    private func setupUI() {
        view.backgroundColor = .white
        
        setupNavigationItems()
        setupSubviews()
        setupConstraints()
    }
    
    private func setupNavigationItems() {
        let rightItem = UIBarButtonItem(title: "切换视图", style: .plain, target: self, action: #selector(onTapSwitchBtn(_:)))
        self.navigationItem.rightBarButtonItem = rightItem
    }
    
    private func setupSubviews() {
        view.addSubview(amountLab)
        view.addSubview(tableView)
        view.addSubview(collectionView)
    }
    
    private func setupConstraints() {
        amountLab.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(100)
            make.centerX.equalToSuperview()
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(amountLab.snp.bottom).offset(10)
            make.left.bottom.right.equalToSuperview()
        }
        
        collectionView.snp.makeConstraints { make in
            make.edges.equalTo(tableView)
        }
    }
    
    // MARK: - lazy view
    
    private lazy var amountLab: UILabel = {
        let lab = UILabel()
        lab.textColor = .black
        lab.textAlignment = .center
        lab.font = .boldSystemFont(ofSize: 24)
        return lab
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.backgroundView = emptyDataTipsLab
        tableView.backgroundView?.isHidden = true
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .clear
        return tableView
    }()
    
    private lazy var emptyDataTipsLab: UILabel = {
        let lab = UILabel()
        lab.text = "暂无历史数据"
        lab.textColor = .black
        lab.textAlignment = .center
        lab.font = .boldSystemFont(ofSize: 20)
        return lab
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 50, height: 50)
        layout.minimumLineSpacing = 5
        layout.minimumInteritemSpacing = 5
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(HistoryCollectionViewCell.self, forCellWithReuseIdentifier: "HistoryCollectionViewCell")
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isHidden = true
        collectionView.backgroundColor = .clear
        return collectionView
    }()
    
    // MARK: - action
    
    @objc private func onTapSwitchBtn(_ sender: UIBarButtonItem) {
        let flag = tableView.isHidden
        tableView.isHidden = !flag
        collectionView.isHidden = flag
    }

}

extension HistoryViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = self.checkDatas.count
        if count <= 0 {
            tableView.backgroundView?.isHidden = false
        }
        
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell
        if let cache = tableView.dequeueReusableCell(withIdentifier: "HistoryTableViewCell") {
            cell = cache
        } else {
            cell = UITableViewCell(style: .value1, reuseIdentifier: "HistoryTableViewCell")
        }
        
        let info = checkDatas[indexPath.row]
        cell.textLabel?.text = "￥\(info.number)"
        cell.detailTextLabel?.text = AppDataManager.formatDate(info.date)
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        tableView.selectRow(at: indexPath, animated: true, scrollPosition: .none)
        tableView.beginUpdates()
        if editingStyle == .delete {
            
        }
        tableView.endUpdates()
    }
    
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        "删除"
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        .delete
    }
}

extension HistoryViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.allDatas.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HistoryCollectionViewCell", for: indexPath) as! HistoryCollectionViewCell
        let info = self.allDatas[indexPath.item]
        cell.textLabel.text = "\(info.number)"
        cell.backgroundColor = info.checked ? .systemPink : .lightGray
        return cell
    }
}
