//
//  TransactionService.swift
//  SeniKita
//
//  Created by Ricky Primayuda Putra on 15/03/25.
//

struct TransactionService: Codable {
    let id: Int
    let order_service_id: Int
    let payment_status: String
    let payment_date: String?
    let created_at: String
    let updated_at: String
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decode(Int.self, forKey: .id)
        
        if let strValue = try? container.decode(String.self, forKey: .order_service_id) {
            order_service_id = Int(strValue) ?? 0
        } else if let intValue = try? container.decode(Int.self, forKey: .order_service_id) {
            order_service_id = intValue
        } else {
            order_service_id = 0
        }
        
        payment_status = try container.decode(String.self, forKey: .payment_status)
        payment_date = try container.decodeIfPresent(String.self, forKey: .payment_date)
        created_at = try container.decode(String.self, forKey: .created_at)
        updated_at = try container.decode(String.self, forKey: .updated_at)
    }
}
