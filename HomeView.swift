//
//  HomeView.swift
//  MyApp
//
//  Created by Admin on 28/2/2024.
//

import SwiftUI
import FSCalendar

struct HomeView: View {
    @StateObject var submitVM = SubmitDataVM()
    @State private var currentMonthAvailability: [String: Int] = [:]
    @State private var nextMonthAvailability: [String: Int] = [:]
    @State private var selectedDate: String?
    @State var isImagePickerPresented = false
    @State var isImageUpload = false
    @State var isSubmitted = false
    @State var isImageAdded = false
    @State var color: Color = .white
    @State var selectedItem : Product?
    @State var capturedImage : UIImage?
    @State var selectedSourceType : UIImagePickerController.SourceType = .camera
    @StateObject var homeVM = HomeDataVM()
    let spacing : CGFloat = 20
    var body: some View {
        let coloumns = [GridItem(.flexible(), spacing: spacing),
                        GridItem(.flexible(), spacing: spacing),
                        GridItem(.flexible(), spacing: spacing)]
        VStack{
            if !homeVM.isSuccess {
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
                if let details = homeVM.homeData?.product, details.isEmpty {
                    Text("List is Empty")
                        .padding(.top, 50)
                    Spacer()
                } else{
                    VStack{
                        Text("Products")
                            .foregroundColor(.green)
                            .font(.system(size: 20,weight: .bold))
                            .padding(.leading,30)
                            .frame(maxWidth: .infinity,alignment: .leading)
                        ScrollView{
                            LazyVGrid(columns: coloumns, spacing: spacing){
                                if let products = homeVM.homeData?.product {
                                    ForEach(products){ item in
                                        ItemView(item : item, isSelected: selectedItem == item)
                                            .onTapGesture {
                                                if selectedItem == item {
                                                    selectedItem = nil
                                                } else {
                                                    selectedItem = item
                                                }
                                            }
                                    }
                                }
                            }
                            .padding()
                        }
                        .frame(height: getRect().height * 0.26)
                        .padding(.horizontal)
                        Text("Select Date")
                            .foregroundColor(.green)
                            .font(.system(size: 20,weight: .bold))
                            .padding(.horizontal,30)
                            .frame(maxWidth: .infinity,alignment: .leading)
                        VStack {
                            FSCalendarView(currentMonthAvailability: $currentMonthAvailability, nextMonthAvailability: $nextMonthAvailability, selectedDate: $selectedDate)
                                .padding()
                        }
                        .frame(width: getRect().width - 50, height: getRect().height * 0.30)
                        .background(.white)
                        .cornerRadius(10)
                        .shadow(color: .black.opacity(0.3),radius: 5)
                        
                        Text("Add Image")
                            .foregroundColor(.green)
                            .font(.system(size: 20,weight: .bold))
                            .padding(10)
                            .padding(.horizontal,20)
                            .frame(maxWidth: .infinity,alignment: .leading)
                        Button(action: {
                            isImageUpload = true
                        }) {
                            HStack{
                                Text(isImageAdded ? "Image is Added" : "Select Image")
                                Image(systemName: isImageAdded ? "checkmark" : "square.and.arrow.up.circle.fill")
                                    .font(.system(size: 25))
                                    .scaledToFit()
                                    .clipShape(Circle())
                                    .padding()
                            }
                            .frame(width: getRect().width - 100,height: 40)
                            .background(isImageAdded ? AppColor().primaryColor : .white)
                            .foregroundColor(isImageAdded ? .white : .gray)
                            .cornerRadius(10)
                            .shadow(color: .black.opacity(0.3),radius: 5)
                        }
                        Button(action: {
                            submitVM.product_id = selectedItem?.id ?? ""
                            submitVM.date = selectedDate ?? ""
                            submitVM.submitData()
                        }) {
                            Text("SUBMIT")
                                .frame(width:  200,height: 50)
                                .font(.system(size: 20,weight: .bold))
                                .background(isSubmitted ? .gray : AppColor().primaryColor)
                                .foregroundColor(isSubmitted ? AppColor().primaryColor : .white)
                                .cornerRadius(10)
                                .shadow(color: .black.opacity(0.3),radius: 5)
                                .padding(.top,20)
                        }
                        Spacer()
                    }
                }
            }
        }
        .background(.white)
        .onChange(of: homeVM.isSuccess) { _ in
            currentMonthAvailability = parseAvailability((homeVM.homeData?.available_dates.current_month_scrap_availability)!)
            nextMonthAvailability = parseAvailability((homeVM.homeData?.available_dates.next_month_scrap_availability)!)
        }
        .onAppear{
            homeVM.getData()
        }
        .alert(isPresented: $submitVM.showAlert) {
            
            Alert(title: Text(""),message: Text(submitVM.alert),dismissButton: .destructive(Text("Ok")){
                if submitVM.isSuccess {
                    isSubmitted = true
                    selectedItem = nil
                    isImageAdded = false
                    selectedDate = nil
                    submitVM.capturedImage = nil
                }else{
                    isSubmitted = false
                }
            })
        }
        
        .fullScreenCover(isPresented: $isSubmitted, content: {
            HistoryView()
        })
        .actionSheet(isPresented: $isImageUpload) {
            ActionSheet(
                title: Text("Select Image"),
                buttons: [
                    .default(Text("Camera"), action: {
                        selectedSourceType = .camera
                        isImagePickerPresented = true
                    }),
                    .default(Text("Photo Library"), action: {
                        selectedSourceType = .photoLibrary
                        isImagePickerPresented = true
                    }),
                    .cancel()
                ]
            )
        }
        .sheet(isPresented: $isImagePickerPresented, onDismiss: loadImage) {
            ImagePicker(image: $capturedImage, sourceType: selectedSourceType)
        }
    }
    func loadImage() {
        if let image = capturedImage {
            submitVM.capturedImage = capturedImage
            withAnimation {
                isImageAdded = true
            }
        }
    }
    func parseAvailability(_ availabilityString: String) -> [String: Int] {
        let data = availabilityString.data(using: .utf8)!
        do {
            let dict = try JSONSerialization.jsonObject(with: data, options: []) as! [String: Int]
            print("dictionary: \(dict)")
            
            var convertedDictionary: [String: Int] = [:]
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyyMMdd"
            
            for (key, value) in dict {
                let dayString = String(key.dropFirst(3))
                if let day = Int(dayString), let date = Calendar.current.date(byAdding: .day, value: day, to: Date()) {
                    let dateString = dateFormatter.string(from: date)
                    convertedDictionary[dateString] = value
                }
            }
            return convertedDictionary
        } catch {
            print("Error parsing availability: \(error)")
            return [:]
        }
    }
}

struct ItemView : View {
    let item : Product
    let isSelected: Bool
    var body: some View {
        let height = getRect().height * 0.1
        GeometryReader { reader in
            VStack{
                
                AsyncImage(url: URL(string: item.image)!, width:height/2, height: height/2)
                Text(item.name)
                    .foregroundColor(.blue)
                    .font(.system(size: 14,weight: .semibold))
            }
            .frame(width: reader.size.width, height: reader.size.height)
            .background(isSelected ? .orange : .white)
        }
        .frame(height: height)
        .cornerRadius(15)
        .shadow(color: .black.opacity(0.5), radius: 5)
    }
}

#Preview {
    HomeView()
}
