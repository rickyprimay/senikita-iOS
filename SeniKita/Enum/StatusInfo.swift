//
//  StatusInfo.swift
//  SeniKita
//
//  Created by Ricky Primayuda Putra on 14/03/25.
//

import SwiftUI

struct StatusInfo {
    let icon: String
    let text: String
    let bgColor: Color
    let borderColor: Color
    let textColor: Color
}

let statusMap: [String: StatusInfo] = [
    "pending": StatusInfo(
        icon: "hourglass",
        text: "Menunggu Pembayaran",
        bgColor: Color.yellow.opacity(0.2),
        borderColor: Color.yellow.opacity(0.3),
        textColor: Color.yellow
    ),
    "selesai": StatusInfo(
        icon: "checkmark.circle",
        text: "Pembayaran Berhasil",
        bgColor: Color.green.opacity(0.2),
        borderColor: Color.green.opacity(0.3),
        textColor: Color.green
    ),
    "gagal": StatusInfo(
        icon: "xmark.circle",
        text: "Pembayaran Gagal",
        bgColor: Color.red.opacity(0.2),
        borderColor: Color.red.opacity(0.3),
        textColor: Color.red
    ),
    "diproses": StatusInfo(
        icon: "arrow.triangle.2.circlepath",
        text: "Sedang Diproses",
        bgColor: Color.blue.opacity(0.2),
        borderColor: Color.blue.opacity(0.3),
        textColor: Color.blue
    ),
    "dikirim": StatusInfo(
        icon: "shippingbox",
        text: "Sedang Dikirim",
        bgColor: Color.orange.opacity(0.2),
        borderColor: Color.orange.opacity(0.3),
        textColor: Color.orange
    ),
    "dibatalkan": StatusInfo(
        icon: "xmark",
        text: "Pesanan Dibatalkan",
        bgColor: Color.gray.opacity(0.2),
        borderColor: Color.gray.opacity(0.3),
        textColor: Color.gray
    )
]
