//
//  SkeletonLoading.swift
//  SeniKita
//
//  Created by Ricky Primayuda Putra on 01/02/25.
//

import SwiftUI

struct SkeletonShimmer: View {
    @State private var phase: CGFloat = 0
    
    var body: some View {
        LinearGradient(
            gradient: Gradient(stops: [
                .init(color: Color(UIColor.systemGray5), location: 0),
                .init(color: Color(UIColor.systemGray4), location: 0.3),
                .init(color: Color(UIColor.systemGray5), location: 0.5),
                .init(color: Color(UIColor.systemGray4), location: 0.7),
                .init(color: Color(UIColor.systemGray5), location: 1)
            ]),
            startPoint: .init(x: phase - 1, y: 0.5),
            endPoint: .init(x: phase, y: 0.5)
        )
        .onAppear {
            withAnimation(.linear(duration: 1.5).repeatForever(autoreverses: false)) {
                phase = 2
            }
        }
    }
}

struct SkeletonLoading: View {
    let width: CGFloat
    let height: CGFloat
    var cornerRadius: CGFloat = 8
    var isCircle: Bool = false
    var padding: EdgeInsets = EdgeInsets()
    
    var body: some View {
        Group {
            if isCircle {
                SkeletonShimmer()
                    .frame(width: width, height: height)
                    .clipShape(Circle())
            } else if width == .infinity {
                SkeletonShimmer()
                    .frame(maxWidth: .infinity)
                    .frame(height: height)
                    .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
            } else {
                SkeletonShimmer()
                    .frame(width: width, height: height)
                    .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
            }
        }
        .padding(padding)
    }
}

// MARK: - Skeleton Presets for common UI patterns

struct ProductCardSkeleton: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            SkeletonLoading(width: 160, height: 160, cornerRadius: 12)
            SkeletonLoading(width: 60, height: 12)
            SkeletonLoading(width: 140, height: 16)
            SkeletonLoading(width: 100, height: 20)
            SkeletonLoading(width: 120, height: 12)
            HStack {
                SkeletonLoading(width: 80, height: 12)
                Spacer()
                SkeletonLoading(width: 36, height: 36, isCircle: true)
            }
        }
        .padding(12)
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.04), radius: 8, y: 2)
    }
}

struct ServiceCardSkeleton: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            SkeletonLoading(width: 160, height: 140, cornerRadius: 12)
            SkeletonLoading(width: 60, height: 12)
            SkeletonLoading(width: 130, height: 16)
            HStack(spacing: 4) {
                SkeletonLoading(width: 80, height: 18)
                SkeletonLoading(width: 50, height: 12)
            }
            SkeletonLoading(width: 120, height: 12)
            SkeletonLoading(width: 100, height: 12)
        }
        .padding(12)
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.04), radius: 8, y: 2)
    }
}

struct BannerSkeleton: View {
    var body: some View {
        SkeletonLoading(width: .infinity, height: 300, cornerRadius: 24)
            .padding(.horizontal, 20)
    }
}

struct CartItemSkeleton: View {
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            SkeletonLoading(width: 22, height: 22, isCircle: true)
            SkeletonLoading(width: 70, height: 70, cornerRadius: 12)
            VStack(alignment: .leading, spacing: 8) {
                SkeletonLoading(width: 140, height: 16)
                SkeletonLoading(width: 100, height: 20)
                HStack(spacing: 12) {
                    SkeletonLoading(width: 28, height: 28, cornerRadius: 8)
                    SkeletonLoading(width: 30, height: 16)
                    SkeletonLoading(width: 28, height: 28, cornerRadius: 8)
                }
            }
            Spacer()
            SkeletonLoading(width: 36, height: 36, cornerRadius: 8)
        }
        .padding(16)
    }
}

struct HistoryCardSkeleton: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                SkeletonLoading(width: 100, height: 14)
                Spacer()
                SkeletonLoading(width: 80, height: 24, cornerRadius: 8)
            }
            Divider()
            HStack(spacing: 12) {
                SkeletonLoading(width: 60, height: 60, cornerRadius: 10)
                VStack(alignment: .leading, spacing: 6) {
                    SkeletonLoading(width: 150, height: 16)
                    SkeletonLoading(width: 80, height: 12)
                    SkeletonLoading(width: 100, height: 14)
                }
            }
            Divider()
            HStack {
                SkeletonLoading(width: 80, height: 12)
                Spacer()
                SkeletonLoading(width: 100, height: 18)
            }
        }
        .padding(16)
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.04), radius: 8, y: 2)
    }
}

struct ProfileHeaderSkeleton: View {
    var body: some View {
        VStack(spacing: 12) {
            SkeletonLoading(width: 80, height: 80, isCircle: true)
            SkeletonLoading(width: 120, height: 20)
            SkeletonLoading(width: 180, height: 14)
        }
        .padding(20)
        .frame(maxWidth: .infinity)
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.04), radius: 8, y: 2)
    }
}

#Preview {
    ScrollView {
        VStack(spacing: 20) {
            Text("Basic Skeletons")
                .font(.headline)
            
            HStack(spacing: 12) {
                SkeletonLoading(width: 100, height: 16)
                SkeletonLoading(width: 50, height: 50, isCircle: true)
            }
            
            Text("Product Card Skeleton")
                .font(.headline)
            ProductCardSkeleton()
            
            Text("Service Card Skeleton")
                .font(.headline)
            ServiceCardSkeleton()
            
            Text("History Card Skeleton")
                .font(.headline)
            HistoryCardSkeleton()
        }
        .padding()
    }
    .background(Color(UIColor.systemGroupedBackground))
}
