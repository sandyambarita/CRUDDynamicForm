//
//  CRUDVC.swift
//  CRUD
//
//  Created by sandy ambarita on 28/02/20.
//  Copyright © 2020 Fundtastic. All rights reserved.
//

import UIKit

class CRUDVC: UIViewController {
    @IBOutlet weak var btnSave: UIButton!
    @IBOutlet weak var viewForm: UIView!
    internal var listVCDelegate: ListVCDelegate?
    
    var viewModelCRUD = CRUDViewModel()
    var formView = FormView()
    
    private var datePicker: UIDatePicker?
    private var pickerView: UIPickerView?
    
    var selectedColor: String?
    var allColor: [String] = []
    
    var crud_id = ""
    var crud_name = ""
    var crud_description = ""
    var crud_color = ""
    var crud_status = ""
    var crud_timestamp = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fethingMetadata()
        
        pickerView = UIPickerView()
        pickerView?.delegate = self
        
        datePicker = UIDatePicker()
        datePicker?.datePickerMode = .date
        datePicker?.addTarget(self, action: #selector(self.dateChange(datePicker:)), for: .valueChanged)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.viewTapped(gestureRecognizer:)))
        viewForm.addGestureRecognizer(tapGesture)
        
    }
    
    func fethingMetadata() {
        let p: [String: Any] = [:]
        let params: [String : Any] = [
            "a": "metadata",
            "p": p
        ]
        viewModelCRUD.fetchMetadata(params: params, completion: {_ in
            DispatchQueue.main.async { [weak self] in
                if self?.viewModelCRUD.dataUpdate != nil {
                    self?.setupLayout()
                    self?.setupLayoutUpdate()
                } else {
                    self?.setupLayout()
                }
            }
        })
    }
    
    private func setupLayoutUpdate() {
        for (item) in viewForm.subviews {
            if item.accessibilityIdentifier == "crud_id" {
                let data = item as? UITextField
                data?.isUserInteractionEnabled = false
                data?.text = viewModelCRUD.dataUpdate?.crudId
                crud_id = data!.text!
            } else if item.accessibilityIdentifier == "crud_name" {
                let data = item as? UITextField
                data?.isUserInteractionEnabled = true
                data?.text = viewModelCRUD.dataUpdate?.crudName
                crud_name = data!.text!
            } else if item.accessibilityIdentifier == "crud_description" {
                let data = item as? UITextView
                data?.isUserInteractionEnabled = false
                data?.text = viewModelCRUD.dataUpdate?.crudDescription
                crud_description = data!.text!
            } else if item.accessibilityIdentifier == "crud_timestamp" {
                let data = item as? UITextField
                data?.isUserInteractionEnabled = false
                data?.text = viewModelCRUD.dataUpdate?.crudTimestamp
                let dateFormatter = DateFormatter()
                let tempLocale = dateFormatter.locale
                dateFormatter.locale = Locale(identifier: "en_US_POSIX")
                dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
                let date = dateFormatter.date(from: (viewModelCRUD.dataUpdate?.crudTimestamp)!)!
                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                dateFormatter.locale = tempLocale
                let dateString = dateFormatter.string(from: date)
                data?.text = dateString
                crud_timestamp = dateString
            } else if item.accessibilityIdentifier == "crud_color" {
                let data = item as? UITextField
                data?.isUserInteractionEnabled = false
                data?.text = viewModelCRUD.dataUpdate?.crudColor
                crud_color = data!.text!
            } else if item.accessibilityIdentifier == "crud_status" {
                let data = item as? UIButton
                data?.isUserInteractionEnabled = false
                if data?.titleLabel!.text == viewModelCRUD.dataUpdate?.crudStatus {
                    data?.setImage(UIImage(named: "ic_checkbox_active"), for: .normal)
                    crud_status = (viewModelCRUD.dataUpdate?.crudStatus)!
                } else {
                    data?.setImage(UIImage(named: "ic_checkbox_unactive"), for: .normal)
                }
            }
        }
    }
    
    private func setupLayout() {
        for (index, item) in viewModelCRUD.metadataResponse.enumerated() {
            if item.input == "text" {
                formView.label(width: Int(viewForm.frame.width) , metaData: item) { (label) in
                    viewForm.addSubview(label)
                }
                formView.text(width: Int(viewForm.frame.width), metaData: item) { (textField) in
                    textField.delegate = self
                    textField.accessibilityIdentifier = item.field
                    viewForm.addSubview(textField)
                }
            } else if item.input == "textarea" {
                formView.label( width: Int(viewForm.frame.width) , metaData: item) { (label) in
                    viewForm.addSubview(label)
                }
                formView.textArea( width: Int(viewForm.frame.width), metaData: item) { (textArea) in
                    textArea.accessibilityIdentifier = item.field
                    viewForm.addSubview(textArea)
                }
            } else if item.input == "combobox" {
                formView.label( width: Int(viewForm.frame.width) , metaData: item) { (label) in
                    viewForm.addSubview(label)
                }
                formView.text(width: Int(viewForm.frame.width), metaData: item) { (textField) in
                    textField.delegate = self
                    textField.accessibilityIdentifier = item.field
                    textField.inputView = pickerView
                    viewForm.addSubview(textField)
                }
                let data = item.accepted!.components(separatedBy: "|")
                allColor = data
            } else if item.input == "checkbox" {
                formView.label( width: Int(viewForm.frame.width) , metaData: item) { (label) in
                    viewForm.addSubview(label)
                }
                formView.checkbox(metaData: item) { (button, name) in
                    button.accessibilityIdentifier = item.field
                    let tap = MyTapGesture(target: self, action: #selector(self.buttonAction))
                    button.addGestureRecognizer(tap)
                    tap.dataSend = name
                    viewForm.addSubview(button)
                }
            } else if item.input == "datepicker" {
                formView.label( width: Int(viewForm.frame.width) , metaData: item) { (label) in
                    viewForm.addSubview(label)
                }
                formView.text(width: Int(viewForm.frame.width), metaData: item) { (textField) in
                    textField.delegate = self
                    textField.accessibilityIdentifier = item.field
                    textField.inputView = datePicker
                    viewForm.addSubview(textField)
                }
            }
        }
    }
    
    @objc func viewTapped(gestureRecognizer:UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    @objc func dateChange(datePicker: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "in_ID")
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = dateFormatter.string(from: datePicker.date)
        for (item) in viewForm.subviews {
            for (data) in viewModelCRUD.metadataResponse {
                if item.accessibilityIdentifier == data.field {
                    if data.input == "datepicker" {
                        let textData = item as? UITextField
                        textData!.text = date
                    }
                 }
            }
        }
    }
    
    @objc func buttonAction(sender : MyTapGesture) {
        for (item) in viewForm.subviews {
            for (data) in viewModelCRUD.metadataResponse {
                if item.accessibilityIdentifier == data.field {
                    if data.input == "checkbox" {
                        let btnData = item as? UIButton
                        if sender.dataSend == btnData?.titleLabel!.text {
                            if (btnData?.currentImage?.isEqual(UIImage(named: "ic_checkbox_active")))! {
                                btnData?.setImage(UIImage(named: "ic_checkbox_unactive"), for: .normal)
                            } else {
                                btnData?.setImage(UIImage(named: "ic_checkbox_active"), for: .normal)
                                crud_status = "\(btnData?.titleLabel!.text ?? "")"
                            }
                        } else {
                            btnData?.setImage(UIImage(named: "ic_checkbox_unactive"), for: .normal)
                        }
                    }
                 }
            }
        }
    }
    
    @IBAction func btnOnClicked(_ sender: Any) {
        for (item) in viewForm.subviews {
            if item.accessibilityIdentifier == "crud_id" {
                let data = item as? UITextField
                crud_id = data!.text!
            } else if item.accessibilityIdentifier == "crud_name" {
                let data = item as? UITextField
                crud_name = data!.text!
            } else if item.accessibilityIdentifier == "crud_description" {
                let data = item as? UITextView
                crud_description = data!.text!
            } else if item.accessibilityIdentifier == "crud_timestamp" {
                let data = item as? UITextField
                crud_timestamp = data!.text!
            } else if item.accessibilityIdentifier == "crud_color" {
                let data = item as? UITextField
                crud_color = data!.text!
            }
        }
        
        if crud_id == "", crud_name == "", crud_description == "", crud_color == "", crud_status == "", crud_timestamp == "" {
            let alert = UIAlertController(title: "Gagal", message: "Form ada yang kosong", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        } else {
            if self.viewModelCRUD.dataUpdate != nil {
                let p: [String: Any] = [
                    "crud_id":crud_id,
                    "crud_name": crud_name,
                ]
                let params: [String : Any] = [
                    "a": "update",
                    "p": p
                ]
                print(params)
                viewModelCRUD.fetchResponse(params: params, completion: {_ in
                    DispatchQueue.main.async { [weak self] in
                        self?.dismiss(animated: true, completion: {
                            self?.listVCDelegate?.dismiss()
                        })
                    }
                })
            } else {
                let p: [String: Any] = [
                    "crud_id":crud_id,
                    "crud_name": crud_name,
                    "crud_description":crud_description,
                    "crud_color": crud_color,
                    "crud_status":crud_status,
                    "crud_timestamp": crud_timestamp

                ]
                let params: [String : Any] = [
                    "a": "insert",
                    "p": p
                ]
                print(params)
                viewModelCRUD.fetchResponse(params: params, completion: {_ in
                    DispatchQueue.main.async { [weak self] in
                        self?.dismiss(animated: true, completion: {
                            self?.listVCDelegate?.dismiss()
                        })
                    }
                })
            }
        }
        
    }
    
}

extension CRUDVC: UITextFieldDelegate {
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        return true
    }
    
    
}

extension CRUDVC: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return allColor.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return allColor[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedColor = allColor[row]
        for (item) in viewForm.subviews {
            for (data) in viewModelCRUD.metadataResponse {
                if item.accessibilityIdentifier == data.field {
                    if data.input == "combobox" {
                        let textData = item as? UITextField
                        textData!.text = selectedColor
                    }
                 }
            }
        }
    }
}

class MyTapGesture: UITapGestureRecognizer {
    var dataSend: String?
}
