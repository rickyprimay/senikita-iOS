//
//  ProductReviews.swift
//  SeniKita
//
//  Created by Ricky Primayuda Putra on 07/03/25.
//

import SwiftUI
import SDWebImageSwiftUI

struct ProductReviews: View {
    var ratings: [Rating]?
    @State private var showAllReviews = false

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            if let ratings = ratings, !ratings.isEmpty {
                let displayedReviews = showAllReviews ? ratings : Array(ratings.prefix(3))

                ForEach(displayedReviews, id: \.id) { rating in
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            if let profilePicture = rating.user?.profilePicture, !profilePicture.isEmpty {
                                WebImage(url: URL(string: profilePicture))
                                    .resizable()
                                    .indicator(.activity)
                                    .scaledToFill()
                                    .frame(width: 40, height: 40)
                                    .clipShape(Circle())
                            } else {
                                ZStack {
                                    Circle()
                                        .fill(Color(UIColor.systemGray5))
                                        .frame(width: 40, height: 40)
                                    Image(systemName: "person.fill")
                                        .font(.system(size: 16))
                                        .foregroundColor(.gray)
                                }
                            }

                            VStack(alignment: .leading, spacing: 2) {
                                Text(rating.user?.name ?? "Unknown User")
                                    .font(AppFont.Nunito.bodyMedium)
                                    .foregroundColor(.primary)
                                
                                HStack(spacing: 2) {
                                    ForEach(0..<5) { index in
                                        Image(systemName: index < rating.rating ? "star.fill" : "star")
                                            .foregroundColor(.yellow)
                                            .font(.system(size: 10))
                                    }
                                }
                            }

                            Spacer()
                        }

                        Text(rating.comment ?? "No comment")
                            .font(AppFont.Raleway.bodyMedium)
                            .foregroundColor(.secondary)
                            .lineLimit(nil)

                        if let ratingImages = rating.rating_images, !ratingImages.isEmpty {
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 8) {
                                    ForEach(ratingImages, id: \.id) { image in
                                        WebImage(url: URL(string: image.picture_rating_product))
                                            .resizable()
                                            .indicator(.activity)
                                            .scaledToFill()
                                            .frame(width: 80, height: 80)
                                            .clipShape(RoundedRectangle(cornerRadius: 8))
                                    }
                                }
                            }
                        }
                    }
                    .padding(12)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color(UIColor.systemGray6))
                    .cornerRadius(12)
                }

                if ratings.count > 3 {
                    Button(action: {
                        showAllReviews.toggle()
                    }) {
                        HStack(spacing: 6) {
                            Text(showAllReviews ? "Tampilkan Lebih Sedikit" : "Lihat Semua Ulasan")
                                .font(AppFont.Raleway.bodyMedium)
                                .foregroundColor(Color("primary"))
                            
                            Image(systemName: showAllReviews ? "chevron.up" : "chevron.down")
                                .foregroundColor(Color("primary"))
                                .font(.system(size: 12, weight: .semibold))
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(Color.white)
                        .cornerRadius(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color("primary"), lineWidth: 1)
                        )
                    }
                }
            } else {
                // Empty state
                VStack(spacing: 12) {
                    ZStack {
                        Circle()
                            .fill(Color(UIColor.systemGray6))
                            .frame(width: 64, height: 64)
                        
                        Image(systemName: "text.bubble")
                            .font(.system(size: 28))
                            .foregroundColor(Color(UIColor.systemGray3))
                    }
                    
                    VStack(spacing: 4) {
                        Text("Belum Ada Ulasan")
                            .font(AppFont.Nunito.bodyMedium)
                            .foregroundColor(.primary)
                        
                        Text("Jadilah yang pertama memberikan ulasan")
                            .font(AppFont.Raleway.footnoteSmall)
                            .foregroundColor(.secondary)
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 32)
            }
        }
        .frame(maxWidth: .infinity)
    }
}
