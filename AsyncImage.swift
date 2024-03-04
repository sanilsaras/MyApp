//
//  AsyncImage.swift
//  MyApp
//
//  Created by Admin on 2/3/2024.
//

import SwiftUI
import Combine

struct AsyncImage: View {
        @StateObject private var loader = ImageLoader()
        let url: URL
        var width : CGFloat
        var height : CGFloat
        var borderColor = Color(.black)
        var body: some View {
            Group {
                if let image = loader.image {
                    Image(uiImage: image)
                        .resizable()
                        .frame(width: width,height: height)
                        .cornerRadius(20)
                    
                } else {
                    ProgressView()
                }
            }
            .onAppear { loader.load(from: url) }
            .onDisappear { loader.cancel() }
        }
    }


class ImageLoader: ObservableObject {
    @Published var image: UIImage?
    private var cancellable: AnyCancellable?
    
    func load(from url: URL) {
        cancellable = URLSession.shared.dataTaskPublisher(for: url)
            .map { UIImage(data: $0.data) }
            .replaceError(with: nil)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in self?.image = $0 }
    }
    
    func cancel() {
        cancellable?.cancel()
    }
}


extension View{
    func getRect() -> CGRect{
        return UIScreen.main.bounds
    }
}
