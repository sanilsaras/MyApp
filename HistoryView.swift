//
//  HistoryView.swift
//  MyApp
//
//  Created by Admin on 2/3/2024.
//

import SwiftUI

struct HistoryView: View {
    @StateObject private var historyVM = HistoryVM()
    @Environment(\.presentationMode) var presentationMode
    var body: some View {
        ZStack{
            VStack{
                ScrollView{
                    if !historyVM.isSuccess {
                        ZStack {
                            VStack {
                                ActivityIndicator(isAnimating: true, style: .large)
                                    .foregroundColor(.white)
                                    .padding()
                                    .cornerRadius(10)
                            }
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .background(Color.black.opacity(0.3))
                        }
                    } else {
                        if let list = historyVM.historyData, list.isEmpty {
                            Text("List is Empty")
                                .padding(.top, 50)
                            Spacer()
                        } else {
                            VStack {
                                Text("Order History")
                                    .foregroundColor(.green)
                                    .font(.system(size: 20,weight: .bold))
                                    .padding(10)
                                    .padding(.horizontal,20)
                                    .frame(maxWidth: .infinity,alignment: .leading)
                                HStack{
                                    VStack(alignment: .leading, spacing: 0) {
                                        if let unwrappedDayInfo = historyVM.historyData {
                                            ForEach(unwrappedDayInfo, id: \.self) { item in
                                                CardShape(hisData:item)
                                                    .padding()
                                            }
                                        }
                                    }
                                }
                                Button(action: {
                                    presentationMode.wrappedValue.dismiss()
                                }) {
                                    Text("Back")
                                        .frame(width:  200,height: 50)
                                        .font(.system(size: 20,weight: .bold))
                                        .background(AppColor().primaryColor)
                                        .foregroundColor(.white)
                                        .cornerRadius(10)
                                        .padding()
                                }
                            }
                        }
                    }
                }
                .onAppear{
                    historyVM.getData()
                }
            }
        }
    }
}

