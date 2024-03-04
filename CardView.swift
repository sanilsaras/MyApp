//
//  CardView.swift
//  MyApp
//
//  Created by Admin on 2/3/2024.
//

import SwiftUI

struct CardShape: View {
    var hisData : HistoryDatum?
    var body: some View {
        ZStack{
            HStack {
                if let imgURL = URL(string: hisData?.fileName ?? "") {
                    AsyncImage(url: imgURL,width: 100,height: 80, borderColor: .clear)
                        .padding()
                }
                VStack(alignment: .leading, spacing: 5){
                    Text(hisData?.productName ?? "")
                        .foregroundColor(.white)
                        .font(.system(size: 20,weight: .bold))
                    Text(hisData?.date ?? "")
                        .foregroundColor(.white)
                        .font(.system(size: 16,weight: .semibold))
                }
                .padding(.leading, 20)
                Spacer()
            }
          
        }
        .frame(width: getRect().width - 60,height: 100)
        .background(AppColor().primaryColor)
        .cornerRadius(15)
//        .shadow(color : .black.opacity(0.5) ,radius: 5)
    }
}
