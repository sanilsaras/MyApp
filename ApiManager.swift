//
//  ApiManager.swift
//  MyApp
//
//  Created by Admin on 28/2/2024.
//

import Foundation
import SwiftUI
import Alamofire
import UIKit

let baseURL = "http://test.aakri.in/api/test/"
let homeDataURL = baseURL + "pre_data"
let submitURL = baseURL + "save_order"
let historyURL = baseURL + "history"

class ApiManager: ObservableObject {
    static let shared = ApiManager()
    
    
    func getHomeData(success:@escaping(_ homeData:HomeDataModel)->Void,failiure:@escaping(_ message:String)->Void){
        print("URL:\(homeDataURL)")
        performRequest(urlString:homeDataURL,success: {data in
            let decoder = JSONDecoder()
            let convertedString = String(data: data, encoding: String.Encoding.utf8)
            print(convertedString)
            do{
                let decodedData = try decoder.decode(HomeDataModel.self, from: data)
                if decodedData.status == "success"{
                    success(decodedData)
                }
            }
            catch{
                print("Error:\(error)")
            }
        }, failiure: {error in
            print("Error:\(error)")
        })
    }
    func submitDetails(product_id : String,date: String, capturedImage : UIImage, success:@escaping(_ message:String)->Void,failiure:@escaping(_ message:String)->Void) {
        var parameters: [String : Any] = [:]
        parameters = [
            "product_id": product_id,
            "date": date,
        ]
        let headers: HTTPHeaders = ["Content-type": "multipart/form-data", "Accept": "application/json", "Authorization": "Basic YWRtaW46MTIzNA==", "session": "WKSSWCCC"]
        AF.upload(multipartFormData: { (multipartFormData) in
            if let photoImageData = capturedImage.jpegData(compressionQuality: 0.5){
                multipartFormData.append(photoImageData, withName: "file_name", fileName: "\(Date().timeIntervalSince1970).jpeg", mimeType: "image/jpeg")
            }
            for (key, value) in parameters {
                multipartFormData.append((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key)
            }
        }, to: submitURL, method: .post, headers: headers)
        .responseJSON { (resp) in
            print("Image Upload URL:\(submitURL)")
            if let err = resp.error{
                print("Image Upload Error:\(err)")
                failiure("Something went Wrong!Try again Later")
                return
            }
            print("Successfully uploaded")
            let decoder = JSONDecoder()
            let convertedString = String(data: resp.data!, encoding: String.Encoding.utf8)
            print(convertedString)
            do{
                let decodeData = try decoder.decode(SubmitRespModel.self, from: resp.data!)
                DispatchQueue.main.async {
                    if decodeData.status == "success" {
                        success(decodeData.message)
                    }
                }
            }
            catch{
                print("Error:\(error)")
            }
        }
    }
    
    func getHistoryData(success:@escaping(_ history:HistoryModel)->Void,failiure:@escaping(_ message:String)->Void){
        
        print("URL:\(historyURL)")
        performRequest(urlString:historyURL , success: {data in
            let decoder = JSONDecoder()
            let convertedString = String(data: data, encoding: String.Encoding.utf8)
            print(convertedString)
            do{
                let decodedData = try decoder.decode(HistoryModel.self, from: data)
                if decodedData.status == "success" {
                    success(decodedData)
                }
            }
            catch{
                print("Error:\(error)")
            }
        }, failiure: {error in
            print("Error:\(error)")
        })
    }
    func performRequest(urlString:String, success:@escaping(_ data:Data)->Void,failiure:@escaping(_ error:Error)->Void){
        if let url = URL(string: urlString){
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            let authString = "Basic YWRtaW46MTIzNA=="
                    request.setValue(authString, forHTTPHeaderField: "Authorization")
                    let sessionToken = "WKSSWCCC" 
                    request.setValue(sessionToken, forHTTPHeaderField: "session")
            let session = URLSession(configuration: .default)
            let task =  session.dataTask(with: request) { (data, response, error) in
                if error != nil{
                    failiure(error!)
                    return
                }
                if let safeData = data{
                    success(safeData)
                }
            }
            task.resume()
        }
    }
}
