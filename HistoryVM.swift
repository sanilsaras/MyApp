//
//  HistoryVM.swift
//  MyApp
//
//  Created by Admin on 28/2/2024.
//

import Foundation
import SwiftUI

class HistoryVM: ObservableObject {
    private let apiManager = ApiManager()
    @Published  var historyData : [HistoryDatum]?
    @Published  var alert = ""
    @Published  var showAlert : Bool = false
    @Published  var isSuccess : Bool = false
    
    func getData(){
        apiManager.getHistoryData { history in
            DispatchQueue.main.async {
                self.alert = history.message
                self.historyData = history.data
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
}
