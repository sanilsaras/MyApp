//
//  HomeDataVM.swift
//  MyApp
//
//  Created by Admin on 28/2/2024.
//

import SwiftUI

class HomeDataVM: ObservableObject {
    private let apiManager = ApiManager()
    @Published  var homeData : DataClass?
    @Published  var alert = ""
    @Published  var showAlert : Bool = false
    @Published  var isSuccess : Bool = false
    
    func getData(){
        apiManager.getHomeData { homeData in
            DispatchQueue.main.async {
                self.homeData = homeData.data
                self.alert = homeData.message
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

