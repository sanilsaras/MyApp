//
//  ActivityIndicator.swift
//  MyApp
//
//  Created by Admin on 2/3/2024.
//

import SwiftUI

    struct ActivityIndicator: UIViewRepresentable {
        
        var isAnimating: Bool
        let style: UIActivityIndicatorView.Style
        
        func makeUIView(context: UIViewRepresentableContext<ActivityIndicator>) -> UIActivityIndicatorView {
            return UIActivityIndicatorView(style: style)
        }
        
        func updateUIView(_ uiView: UIActivityIndicatorView, context: UIViewRepresentableContext<ActivityIndicator>) {
            isAnimating ? uiView.startAnimating() : uiView.stopAnimating()
        }
    }
