//
//  ImageView.swift
//  github-users
//
//  Created by Phuc Bui on 8/2/25.
//

import Foundation
import SwiftUI

struct ImageView: View {
    //State
    @StateObject private var viewModel = ImageViewModel()

    //Properties
    let url: URL?
    let width: CGFloat
    let height: CGFloat
    let radius: CGFloat

    //body
    var body: some View {
        Group {
            if let data = viewModel.imageData, let uiImage = UIImage(data: data) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFit()
                    .cornerRadius(radius)
                    .frame(width: width, height: height)
            } else if viewModel.isLoading {
                ProgressView()
            } else {
                Image(systemName: "photo")
                    .frame(width: width, height: height)
            }
        }
        .onAppear {
            viewModel.loadImage(from: url)
        }
    }
}

