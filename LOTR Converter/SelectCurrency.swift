//
//  SelectCurrency.swift
//  LOTR Converter
//
//  Created by Ishaan Das on 07/06/24.
//

import SwiftUI

struct SelectCurrency: View {
    
    @Environment(\.dismiss) var dismiss
    
    @Binding var leftCurrency: Currency
    @Binding var rightCurrency: Currency
    
    var body: some View {
        ZStack{
            Image(.parchment)
                .resizable()
                .ignoresSafeArea()
                .background(.brown)
            
            VStack{
                Text("Select the currency you are starting with:")
                    .fontWeight(.bold)

                IconGrid(selectedCurrency:$leftCurrency)
                
                Text("Select the currency you would like to convert to:")
                    .fontWeight(.bold)
                
                IconGrid(selectedCurrency:$rightCurrency)
                
                Button("Done"){
                    dismiss()
                }
                .buttonStyle(.borderedProminent)
                .tint(.brown)
                .padding()
                .font(.largeTitle)
                .foregroundStyle(.white)
                
            }
            .padding()
            .multilineTextAlignment(.center)
            .foregroundStyle(.black)
        }
    }
}

#Preview {
    SelectCurrency(leftCurrency: .constant(.copperPenny), rightCurrency: .constant(.silverPiece))
}
