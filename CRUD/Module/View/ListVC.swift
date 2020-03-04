//
//  ListVC.swift
//  CRUD
//
//  Created by sandy ambarita on 05/03/20.
//  Copyright © 2020 Fundtastic. All rights reserved.
//
protocol ListVCDelegate  {
    func updateOnClicked(cell:ListCell)
    func deleteOnClicked(cell:ListCell)
    func dismiss()
}

import Foundation
import UIKit

class ListVC: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    var viewModelCRUD = CRUDViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
        fethingList()
    }
    
    func fethingList() {
        let p: [String: Any] = [:]
        let params: [String : Any] = [
            "a": "list",
            "p": p
        ]
        viewModelCRUD.fetchListResponse(params: params, completion: {_ in
            DispatchQueue.main.async { [weak self] in
                self?.tableView.reloadData()
            }
        })
    }
    @IBAction func createOnClicked(_ sender: Any) {
        let nextVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CRUDVC") as? CRUDVC
        nextVC?.listVCDelegate = self
        self.present(nextVC!, animated: true, completion: nil)
    }
}

extension ListVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModelCRUD.numberOfRowsInSection()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListCell") as? ListCell
        cell?.configureCell(data: viewModelCRUD.metaAtIndex(index: indexPath.row))
        cell?.listVCDelegate = self
        return cell!
    }
    
    
}

extension ListVC: ListVCDelegate {
    func deleteOnClicked(cell: ListCell) {
        let indexPath = tableView.indexPathForRow(at: cell.center)
        let p: [String: Any] = [
            "crud_id": viewModelCRUD.listResponse[indexPath!.row].crudId ?? ""
        ]
        let params: [String : Any] = [
            "a": "delete",
            "p": p
        ]
        viewModelCRUD.fetchResponse(params: params, completion: {_ in
            DispatchQueue.main.async { [weak self] in
                self?.fethingList()
                let alert = UIAlertController(title: "Berhasil", message: "Data telah dihapus", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                self?.present(alert, animated: true, completion: nil)
            }
        })
    }
    func updateOnClicked(cell: ListCell) {
        let indexPath = tableView.indexPathForRow(at: cell.center)
        let nextVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CRUDVC") as? CRUDVC
        nextVC?.viewModelCRUD.dataUpdate = viewModelCRUD.listResponse[indexPath!.row]
        nextVC?.listVCDelegate = self
        self.present(nextVC!, animated: true, completion: nil)
    }
    func dismiss() {
        fethingList()
    }
}

