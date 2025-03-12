//
//  ImageViewModel.swift
//  github-users
//
//  Created by Phuc Bui on 8/2/25.
//


import Foundation
import SwiftUI
import Combine

protocol ImageViewHandleable : AnyObject {
    func loadImage(from url: URL?)
}


class ImageViewModel: ImageViewHandleable, ObservableObject {
    //MARK: - States
    @Published var imageData: Data?
    @Published var isLoading = false
    
    //MARK: - Properties
    private static let cache = NSCache<NSURL, NSData>()
    private var cancellables = Set<AnyCancellable>()
    
    private let imageQueue = DispatchQueue(label: "user.imagequeue", attributes: .concurrent)
    
    //MARK: - Public functions
    func loadImage(from url: URL?) {
        isLoading = true
        
        imageQueue.sync { [weak self] in
            guard let self = self else {
                return
            }
            guard let url = url else {
                self.isLoading = false
                return
            }
            if let data = Self.cache.object(forKey: url as NSURL) {
                self.imageData = data as Data
                self.isLoading = false
                return
            }
            URLSession.shared.dataTaskPublisher(for: url)
                .map { $0.data }
                .replaceError(with: nil)
                .receive(on: DispatchQueue.main)
                .sink { [weak self] in
                    if let data = $0 {
                        Self.cache.setObject(data as NSData, forKey: url as NSURL)
                        self?.imageData = data
                    }
                    self?.isLoading = false
                }
                .store(in: &self.cancellables)
            
        }
        
    }
}

