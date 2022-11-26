//
//  SettingsViewController.swift
//  PhotoFileManager
//
//  Created by Kiryl Rakk on 24/11/22.
//

import UIKit
import SnapKit



class SettingsViewController: UIViewController {

    var delegate : FileController?

    private lazy var settingsTable: UITableView = {
        let table = UITableView(frame: .zero, style: .insetGrouped)
        table.delegate =  self
        table.dataSource = self
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        table.register(SortTableViewCell.self, forCellReuseIdentifier: "sort cell")
        table.register(SizeTableViewCell.self, forCellReuseIdentifier: "size cell")
        table.rowHeight = UITableView.automaticDimension
        table.estimatedRowHeight = 120
        return table
    } ()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Settings"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.view.backgroundColor = .lightGray
        setLayers()
    }
    
    private func setLayers () {
        self.view.addSubview(settingsTable)

        settingsTable.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

extension SettingsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "sort cell", for: indexPath) as! SortTableViewCell
            cell.contentView.isUserInteractionEnabled = false
            cell.textLabel?.text = "Показать в алфавитном порядке"
            return cell
        }
        else if indexPath.row == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "size cell", for: indexPath) as! SizeTableViewCell
            cell.contentView.isUserInteractionEnabled = false
            cell.textLabel?.text = "Показать размер файла"
            cell.isSelected = false
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            cell.textLabel?.text = "Сменить пароль"
            cell.accessoryType = .disclosureIndicator
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 2 {
            let vc = ChangePasswordViewController()
            present(vc, animated: true)
        }
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
}

