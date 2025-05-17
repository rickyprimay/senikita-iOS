//
//  InformationEvent.swift
//  SeniKita
//
//  Created by Ricky Primayuda Putra on 03/05/25.
//

import SwiftUI
import SDWebImageSwiftUI

struct InformationEvent: View {
    
    var imageService: String?
    var nameShop: String?
    var nameService: String?
    var price: Double?
    
    @Binding var currentStep: Int
    
    @State private var namePIC = ""
    @State private var callNumber = ""
    @State private var eventName = ""
    @State private var eventDate = Date()
    @State private var eventTime = Date()
    @State private var showDatePicker = false
    @State private var showTimePicker = false
    @State private var eventLocation = ""
    @State private var selectedProvince: Province?
    @State private var selectedCity: City?
    @State private var showProvinceDropdown = false
    @State private var showCityDropdown = false
    @State private var attendee = ""
    @State private var isStepTwo = false
    @State private var isStepThree = false
    @State private var additionalNote = ""
    @State private var provinceId: Int = 0
    @State private var cityId: Int = 0
    @State private var description = ""
    
    @ObservedObject var addressViewModel = AddressViewModel()
    @ObservedObject var paymentServiceViewModel: PaymentServiceViewModel
    
    var serviceId: Int
    
    var body: some View {
        
        if !isStepTwo && !isStepThree {
            MainInformation(
                imageService: imageService,
                nameShop: nameShop,
                nameService: nameService,
                price: price,
                currentStep: $currentStep,
                namePIC: $namePIC,
                callNumber: $callNumber,
                eventName: $eventName,
                eventDate: $eventDate,
                eventTime: $eventTime,
                provinceId: $provinceId,
                cityId: $cityId,
                addressViewModel: addressViewModel,
                paymentServiceViewModel: paymentServiceViewModel,
                eventLocation: $eventLocation,
                attendee: $attendee,
                isStepTwo: $isStepTwo,
            )
        } else if !isStepTwo && isStepThree {
            TermAndConditionsService(
                currentStep: $currentStep,
                isStepTwo: $isStepTwo,
                isStepThree: $isStepThree,
                name: namePIC,
                serviceId: serviceId,
                activityName: eventName,
                phone: Int(callNumber) ?? 0,
                activityDate: eventDate,
                activityTime: eventTime,
                provinceId: provinceId,
                cityId: cityId,
                address: eventLocation,
                attendee: Int(attendee) ?? 0,
                description: additionalNote,
                paymentServiceViewModel: paymentServiceViewModel,
            )
        }
        else {
            SpecialRequest(
                currentStep: $currentStep,
                isStepTwo: $isStepTwo,
                additionalNote: additionalNote,
                isStepThree: $isStepThree
            )
        }
    }
    
}
