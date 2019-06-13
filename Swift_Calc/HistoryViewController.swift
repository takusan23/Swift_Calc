//
//  HistoryViewController.swift
//  Swift_Calc
//
//  Created by takusan23 on 2019/06/13.
//  Copyright © 2019 takusan23. All rights reserved.
//

import UIKit

class HistoryViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var historyList : [String] = []

    
    @IBOutlet weak var TableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let userDefaults = UserDefaults.standard
        if userDefaults.object(forKey: "history_list") != nil {
            historyList = userDefaults.array(forKey: "history_list") as! [String]
        } else {
            historyList = []
        }
        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return historyList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "tableCell", for: indexPath)
        cell.textLabel!.text = historyList[indexPath.row]
        return cell
    }

    @IBAction func ClearList(_ sender: UIBarButtonItem) {
        let userDefaults = UserDefaults.standard
        historyList = []
        userDefaults.set(historyList,forKey : "history_list")
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
