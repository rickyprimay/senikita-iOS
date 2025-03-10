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
        VStack(alignment: .leading) {
            Text("Ulasan Pembeli")
                .font(AppFont.Nunito.bodyMedium)
                .foregroundColor(.black)
                .bold()
                .padding(.top)

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
                                Image(systemName: "person")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 40, height: 40)
                                    .foregroundColor(.gray)
                                    .background(Color.gray.opacity(0.2))
                                    .clipShape(Circle())
                            }

                            Text(rating.user?.name ?? "Unknown User")
                                .font(AppFont.Nunito.bodyMedium)
                                .foregroundColor(.black)
                                .bold()

                            Spacer()

                            HStack(spacing: 4) {
                                Image(systemName: "star.fill")
                                    .foregroundColor(.yellow)
                                    .font(.system(size: 12))

                                Text(String(rating.rating))
                                    .font(AppFont.Nunito.bodyMedium)
                                    .fontWeight(.bold)
                                    .foregroundColor(.black)
                            }
                        }

                        Text(rating.comment ?? "No comment")
                            .font(AppFont.Nunito.bodyMedium)
                            .foregroundColor(.black)
                            .lineLimit(nil)

                        if let ratingImages = rating.rating_images, !ratingImages.isEmpty {
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack {
                                    ForEach(ratingImages, id: \.id) { image in
                                        WebImage(url: URL(string: image.picture_rating_product))
                                            .resizable()
                                            .indicator(.activity)
                                            .scaledToFill()
                                            .frame(width: 100, height: 100)
                                            .clipShape(RoundedRectangle(cornerRadius: 10))
                                    }
                                }
                            }
                        }
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(20)
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                    )
                    .padding(.bottom, 8)
                }

                if ratings.count > 3 {
                    Button(action: {
                        showAllReviews.toggle()
                    }) {
                        HStack(spacing: 8) {
                            Text(showAllReviews ? "View Less" : "View More")
                                .font(AppFont.Nunito.bodyMedium)
                                .foregroundColor(Color("primary"))
                            
                            Image(systemName: showAllReviews ? "chevron.up" : "chevron.down")
                                .foregroundColor(Color("primary"))
                                .font(.system(size: 14, weight: .bold))
                        }
                        .padding(.vertical, 10)
                        .padding(.horizontal, 20)
                        .background(Color.white)
                        .cornerRadius(8)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color("primary"), lineWidth: 1)
                        )
                        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                }
            } else {
                Text("Tidak ada ulasan")
                    .font(AppFont.Nunito.bodyMedium)
                    .foregroundColor(.black)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(20)
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                    )
                    .padding(.bottom, 8)
            }
        }
    }
}
