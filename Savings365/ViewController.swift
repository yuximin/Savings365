//
//  ViewController.swift
//  Savings365
//
//  Created by apple on 2022/1/25.
//

import UIKit
import SnapKit

class ViewController: UIViewController {

    // MARK: - lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        reloadData(by: AppDataManager.shared.todayInfo)
    }
    
    // MARK: - UI
    
    private func setupUI() {
        view.backgroundColor = .white
        
        setupNavigationItems()
        setupSubviews()
        setupConstraints()
    }
    
    private func setupNavigationItems() {
        let rightItem = UIBarButtonItem(title: "历史记录", style: .plain, target: self, action: #selector(onTapHistoryBtn(_:)))
        self.navigationItem.rightBarButtonItem = rightItem
    }
    
    private func setupSubviews() {
        view.addSubview(titleLab)
        view.addSubview(todayNumberLab)
        view.addSubview(checkBtn)
        view.addSubview(resetBtn)
    }
    
    private func setupConstraints() {
        titleLab.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(150)
        }
        
        todayNumberLab.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(titleLab.snp.bottom).offset(10)
        }
        
        checkBtn.snp.makeConstraints { make in
            make.centerY.equalTo(todayNumberLab)
            make.left.equalTo(todayNumberLab.snp.right).offset(10)
        }
        
        resetBtn.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(todayNumberLab.snp.bottom).offset(10)
        }
    }
    
    // MARK: - private
    
    private func reloadData(by info: TodayInfo) {
        todayNumberLab.text = "￥\(info.number)"
        resetBtn.isEnabled = !info.checked
        checkBtn.isSelected = info.checked
    }
    
    // MARK: - lazy view
    
    private lazy var titleLab: UILabel = {
        let lab = UILabel()
        lab.text = "今日目标"
        lab.font = .boldSystemFont(ofSize: 32)
        lab.textColor = .black
        lab.textAlignment = .center
        return lab
    }()
    
    private lazy var todayNumberLab: UILabel = {
        let lab = UILabel()
        lab.textColor = .black
        lab.font = .boldSystemFont(ofSize: 28)
        lab.textAlignment = .center
        return lab
    }()
    
    private lazy var resetBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("换一个", for: .normal)
        btn.setTitleColor(.blue, for: .normal)
        btn.setTitleColor(.gray, for: .disabled)
        btn.addTarget(self, action: #selector(onTapResetBtn(_:)), for: .touchUpInside)
        return btn
    }()
    
    private lazy var checkBtn: UIButton = {
       let btn = UIButton()
        btn.setImage(UIImage(named: "check"), for: .normal)
        btn.setImage(UIImage(named: "checked"), for: .selected)
        btn.addTarget(self, action: #selector(onTapCheckBtn(_:)), for: .touchUpInside)
        return btn
    }()
    
    // MARK: - action
    
    @objc private func onTapResetBtn(_ sender: UIButton) {
        let info = AppDataManager.shared.resetTodayInfo()
        reloadData(by: info)
    }

    @objc private func onTapCheckBtn(_ sender: UIButton) {
        var info = AppDataManager.shared.todayInfo
        info.checked = !info.checked
        AppDataManager.shared.todayInfo = info
        AppDataManager.shared.updateItemForDataPoolCache(info)
        
        reloadData(by: info)
    }
    
    @objc private func onTapHistoryBtn(_ sender: UIBarButtonItem) {
        let viewController = HistoryViewController()
        self.navigationController?.pushViewController(viewController, animated: true)
    }
}

