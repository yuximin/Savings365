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
        view.addSubview(dataView)
        dataView.addSubview(titleLab)
        dataView.addSubview(numberView)
        numberView.addSubview(todayNumberLab)
        numberView.addSubview(checkBtn)
        dataView.addSubview(resetBtn)
        
        view.addSubview(allClearLab)
    }
    
    private func setupConstraints() {
        
        dataView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().multipliedBy(0.6)
            make.width.equalToSuperview()
        }
        
        titleLab.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.centerX.equalToSuperview()
        }
        
        numberView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(titleLab.snp.bottom).offset(15)
        }
        
        todayNumberLab.snp.makeConstraints { make in
            make.left.top.bottom.equalToSuperview()
        }
        
        checkBtn.snp.makeConstraints { make in
            make.centerY.equalTo(numberView)
            make.left.equalTo(todayNumberLab.snp.right).offset(10)
            make.right.equalToSuperview()
        }
        
        resetBtn.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(numberView.snp.bottom).offset(10)
            make.bottom.equalToSuperview()
        }
        
        allClearLab.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().multipliedBy(0.8)
        }
    }
    
    // MARK: - private
    
    private func reloadData(by info: TodayInfo?) {
        guard let info = info else {
            dataView.isHidden = true
            allClearLab.isHidden = false
            return
        }
        
        dataView.isHidden = false
        allClearLab.isHidden = true

        todayNumberLab.text = "￥\(info.number)"
        todayNumberLab.isEnabled = !info.checked
        resetBtn.isEnabled = !info.checked
        checkBtn.isSelected = info.checked
        
        let content = todayNumberLab.text ?? ""
        let attributedString = NSMutableAttributedString(string: content)
        let range = NSMakeRange(0, attributedString.length)
        if info.checked {
            attributedString.addAttribute(.strikethroughStyle, value: 1, range: range)
        } else {
            attributedString.addAttribute(.strikethroughStyle, value: 0, range: range)
        }
        todayNumberLab.attributedText = attributedString
    }
    
    // MARK: - lazy view
    
    private lazy var dataView: UIView = {
        let view = UIView()
        return view
    }()
    
    private lazy var titleLab: UILabel = {
        let lab = UILabel()
        lab.text = "【今日目标】"
        lab.font = .systemFont(ofSize: 22, weight: .medium)
        lab.textColor = .systemBlue
        lab.textAlignment = .center
        return lab
    }()
    
    private lazy var numberView: UIView = {
        let view = UIView()
        return view
    }()
    
    private lazy var todayNumberLab: UILabel = {
        let lab = UILabel()
        lab.textColor = .systemYellow
        lab.font = .boldSystemFont(ofSize: 32)
        lab.textAlignment = .center
        return lab
    }()
    
    private lazy var checkBtn: UIButton = {
       let btn = UIButton()
        btn.setImage(UIImage(named: "check"), for: .normal)
        btn.setImage(UIImage(named: "checked"), for: .selected)
        btn.addTarget(self, action: #selector(onTapCheckBtn(_:)), for: .touchUpInside)
        return btn
    }()
    
    private lazy var resetBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("换一个", for: .normal)
        btn.setTitleColor(.blue, for: .normal)
        btn.setTitleColor(.gray, for: .disabled)
        btn.addTarget(self, action: #selector(onTapResetBtn(_:)), for: .touchUpInside)
        return btn
    }()
    
    private lazy var allClearLab: UILabel = {
        let lab = UILabel()
        lab.text = "已完成全部目标"
        lab.textColor = .systemYellow
        lab.font = .boldSystemFont(ofSize: 32)
        lab.textAlignment = .center
        return lab
    }()
    
    // MARK: - action
    
    @objc private func onTapResetBtn(_ sender: UIButton) {
        reloadData(by: AppDataManager.shared.resetTodayInfo())
    }

    @objc private func onTapCheckBtn(_ sender: UIButton) {
        guard var info = AppDataManager.shared.todayInfo else {
            return
        }
        
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

