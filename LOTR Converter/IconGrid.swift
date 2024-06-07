//
//  IconGrid.swift
//  LOTR Converter
//
//  Created by Ishaan Das on 07/06/24.
//

import SwiftUI

struct IconGrid: View {
    
    @Binding var selectedCurrency: Currency
    
    var body: some View {
        LazyVGrid(columns:[GridItem(),GridItem(),GridItem()]){
            ForEach(Currency.allCases){ currency in
                if currency == selectedCurrency {
                    CurrencyIcon(currencyImage: currency.image, currencyName: currency.name)
                        .shadow(color: .black, radius: 10)
                        .overlay{
                            RoundedRectangle(cornerRadius: 25)
                                .stroke(lineWidth: 3)
                                .opacity(0.5)
                        }
                }
                else{
                    CurrencyIcon(currencyImage: currency.image, currencyName: currency.name)
                        .onTapGesture {
                            selectedCurrency = currency
                        }
                }
            }
        }
    }
}

#Preview {
    IconGrid(selectedCurrency: .constant(.copperPenny))
}
