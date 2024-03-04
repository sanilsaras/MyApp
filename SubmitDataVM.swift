//
//  SubmitDataVM.swift
//  MyApp
//
//  Created by Admin on 28/2/2024.
//

import Foundation
import SwiftUI

class SubmitDataVM: ObservableObject {
    private let apiManager = ApiManager()
    @Published  var alert = ""
    @Published  var product_id = ""
    @Published  var date = ""
    @Published  var errorMessage = ""
    @Published  var showAlert : Bool = false
    @Published  var isSuccess : Bool = false
    @Published var capturedImage: UIImage?
    
    func submitData(){
        guard validate() else{
            return
        }
        apiManager.submitDetails(product_id: product_id, date: date, capturedImage: capturedImage!) { message in
            DispatchQueue.main.async {
                self.alert = message
                self.showAlert = true
                self.isSuccess = true
            }
        } failiure: { message in
            DispatchQueue.main.async {
                self.alert = message
                self.showAlert = true
                self.isSuccess = false
                print("failed")
            }
        }
    }
    
    func validate() -> Bool {
        guard !product_id.trimmingCharacters(in: .whitespaces).isEmpty else {
            self.alert = "Please select a product"
            self.showAlert = true
            return false
        }
        guard !date.trimmingCharacters(in: .whitespaces).isEmpty else {
            self.alert = "Please select an available date"
            self.showAlert = true
            return false
        }
        guard capturedImage != nil else {
            self.showAlert = true
            self.alert = "Please select an image"
            return false
        }
        self.showAlert = false
        self.alert = ""
        return true
    }

}
