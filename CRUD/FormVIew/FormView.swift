//
//  FormView.swift
//  CRUD
//
//  Created by sandy ambarita on 01/03/20.
//  Copyright © 2020 Fundtastic. All rights reserved.
//

import Foundation
import UIKit

class FormView {
    var heightFromLast: Int = 0
    var widthFromLast: Int = 0
    
    func label(width: Int, metaData: MetadataPayload, completion: (UILabel) -> ()) {
        let label = UILabel(frame: CGRect(x: 16, y: heightFromLast+16, width: width-32, height: 35))
        label.font = UIFont.systemFont(ofSize: 14)
        label.text = metaData.field
        label.textColor = .black
        self.heightFromLast = Int(label.frame.maxY)
        completion(label)
    }
    
    func text(width: Int, metaData: MetadataPayload, completion: (UITextField) -> ()) {
        let textField = UITextField(frame: CGRect(x: 16, y: heightFromLast, width: width-32, height: 35))
        textField.font = UIFont.systemFont(ofSize: 14)
        textField.backgroundColor = UIColor.white
        textField.borderStyle = .roundedRect
        self.heightFromLast = Int(textField.frame.maxY)
        completion(textField)
    }
    
    func textArea(width: Int, metaData: MetadataPayload, completion: (UITextView) -> ()) {
        let textView : UITextView = UITextView(frame: CGRect(x: 16, y: heightFromLast, width: width-32, height: 50))
        textView.isUserInteractionEnabled = true
        textView.font = UIFont.systemFont(ofSize: 14)
        textView.backgroundColor = UIColor.white
        textView.layer.borderColor = UIColor.lightGray.cgColor
        textView.layer.borderWidth = 1
        self.heightFromLast = Int(textView.frame.maxY)
        completion(textView)
    }
    
    func combobox(width: Int, metaData: MetadataPayload, completion: (UITextField) -> ()) {
        
        let textField = UITextField(frame: CGRect(x: 16, y: heightFromLast, width: width-32, height: 50))
        textField.isUserInteractionEnabled = true
        textField.font = UIFont.systemFont(ofSize: 14)
        textField.backgroundColor = UIColor.white
        textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.layer.borderWidth = 1
        self.heightFromLast = Int(textField.frame.maxY)
        completion(textField)
    }
    
    func checkbox(metaData: MetadataPayload, completion: (UIButton, String) -> ()) {
        let allStatus = metaData.accepted!.components(separatedBy: "|")
        for status in allStatus {
            let button = UIButton(frame: CGRect(x: widthFromLast+16, y: heightFromLast, width: 50, height: 16))
            button.setTitle("\(status)", for: .normal)
            button.backgroundColor = UIColor.white
            button.setTitleColor(UIColor.blue, for: .normal)
            button.titleLabel?.font = .systemFont(ofSize: 14)
            button.setImage(UIImage(named: "ic_checkbox_unactive"), for: .normal)
            button.layoutIfNeeded()
            self.widthFromLast = Int(button.frame.maxX)
            completion(button, status)
        }
        self.widthFromLast = 0
    }
    
    func datePicker(width: Int, metaData: MetadataPayload, completion: (UITextField) -> ()) {
        let textField = UITextField(frame: CGRect(x: 16, y: heightFromLast, width: width-32, height: 50))
        textField.isUserInteractionEnabled = true
        textField.font = UIFont.systemFont(ofSize: 14)
        textField.backgroundColor = UIColor.white
        textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.layer.borderWidth = 1
        self.heightFromLast = Int(textField.frame.maxY)
        completion(textField)
    }
    
}

