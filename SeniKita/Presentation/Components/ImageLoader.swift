//
//  ImageLoader.swift
//  SeniKita
//
//  Created by Ricky Primayuda Putra on 31/01/26.
//
import SwiftUI

// MARK: - Async Image Loader
struct AsyncImageLoader: View {
    let url: String?
    let placeholder: String
    let contentMode: ContentMode
    
    init(
        url: String?,
        placeholder: String = "photo",
        contentMode: ContentMode = .fill
    ) {
        self.url = url
        self.placeholder = placeholder
        self.contentMode = contentMode
    }
    
    var body: some View {
        if let urlString = url, let imageURL = URL(string: urlString) {
            AsyncImage(url: imageURL) { phase in
                switch phase {
                case .empty:
                    PlaceholderView(systemImage: placeholder)
                        .shimmer()
                    
                case .success(let image):
                    image
                        .resizable()
                        .aspectRatio(contentMode: contentMode)
                    
                case .failure:
                    PlaceholderView(systemImage: "exclamationmark.triangle")
                    
                @unknown default:
                    PlaceholderView(systemImage: placeholder)
                }
            }
        } else {
            PlaceholderView(systemImage: placeholder)
        }
    }
}

// MARK: - Placeholder View
struct PlaceholderView: View {
    let systemImage: String
    
    var body: some View {
        ZStack {
            Color.gray.opacity(0.2)
            
            Image(systemName: systemImage)
                .font(.system(size: 30))
                .foregroundColor(.gray.opacity(0.5))
        }
    }
}

// MARK: - Product Image
struct ProductImageView: View {
    let imageURL: String?
    let size: CGSize
    
    var body: some View {
        AsyncImageLoader(url: fullImageURL)
            .frame(width: size.width, height: size.height)
            .clipShape(RoundedRectangle(cornerRadius: 8))
    }
    
    private var fullImageURL: String? {
        guard let imageURL = imageURL else { return nil }
        
        if imageURL.hasPrefix("http") {
            return imageURL
        }
        
        return AppConfig.imageBaseURL + imageURL
    }
}

// MARK: - Avatar Image
struct AvatarImageView: View {
    let imageURL: String?
    let size: CGFloat
    let placeholder: String
    
    init(
        imageURL: String?,
        size: CGFloat = 50,
        placeholder: String = "person.circle.fill"
    ) {
        self.imageURL = imageURL
        self.size = size
        self.placeholder = placeholder
    }
    
    var body: some View {
        AsyncImageLoader(url: fullImageURL, placeholder: placeholder, contentMode: .fill)
            .frame(width: size, height: size)
            .clipShape(Circle())
    }
    
    private var fullImageURL: String? {
        guard let imageURL = imageURL else { return nil }
        
        if imageURL.hasPrefix("http") {
            return imageURL
        }
        
        return AppConfig.imageBaseURL + imageURL
    }
}

// MARK: - Banner Image
struct BannerImageView: View {
    let imageURL: String?
    let height: CGFloat
    let cornerRadius: CGFloat
    
    init(
        imageURL: String?,
        height: CGFloat = 150,
        cornerRadius: CGFloat = 12
    ) {
        self.imageURL = imageURL
        self.height = height
        self.cornerRadius = cornerRadius
    }
    
    var body: some View {
        AsyncImageLoader(url: fullImageURL)
            .frame(height: height)
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
    }
    
    private var fullImageURL: String? {
        guard let imageURL = imageURL else { return nil }
        
        if imageURL.hasPrefix("http") {
            return imageURL
        }
        
        return AppConfig.imageBaseURL + imageURL
    }
}
