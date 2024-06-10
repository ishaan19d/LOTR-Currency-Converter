//
//  ContentView.swift
//  LOTR Converter
//
//  Created by Ishaan Das on 05/06/24.
//

import SwiftUI
import TipKit

struct ContentView: View {
    
    @State var showExchangeInfo = false
    @State var showSelectCurrency = false
    
    @State var leftAmount: String = (UserDefaults.standard.string(forKey: "leftAmountKey") ?? "")
    @State var rightAmount: String = UserDefaults.standard.string(forKey: "rightAmountKey") ?? ""
    
    @State var leftCurrency: Currency = Currency(rawValue: UserDefaults.standard.double(forKey: "leftCurrencyKey")) ?? .silverPiece
    @State var rightCurrency: Currency = Currency(rawValue: UserDefaults.standard.double(forKey: "rightCurrencyKey")) ?? .goldPiece
    
    @FocusState var leftTyping
    @FocusState var rightTyping
    
    private func hideKeyboard() {
        leftTyping = false
        rightTyping = false
    }
    
    private func saveLastConversion(){
        UserDefaults.standard.setValue(leftCurrency.rawValue, forKey: "leftCurrencyKey")
        UserDefaults.standard.setValue(rightCurrency.rawValue, forKey: "rightCurrencyKey")
        UserDefaults.standard.setValue(leftAmount, forKey: "leftAmountKey")
        UserDefaults.standard.setValue(rightAmount, forKey: "rightAmountKey")
    }

    var body: some View {
        ZStack{
            Image(.background)
                .resizable()
                .ignoresSafeArea()
            
            VStack{
                Image(.prancingpony)
                    .resizable()
                    .scaledToFit()
                    .frame(height:250)
                
                Text("Currency Exchange")
                    .font(.largeTitle)
                    .foregroundStyle(.white)
                
                HStack{
                    InputSection(currency: $leftCurrency, amount: $leftAmount, typing: _leftTyping, showSelectCurrency: $showSelectCurrency, isLeft: true)
                    
                    Image(systemName: "equal")
                        .font(.largeTitle)
                        .foregroundStyle(.white)
                        .symbolEffect(.pulse)
                    
                    InputSection(currency: $rightCurrency, amount: $rightAmount, typing: _rightTyping, showSelectCurrency: $showSelectCurrency, isLeft: false)
                }
                .padding()
                .background(.black.opacity(0.5))
                .clipShape(.rect(cornerRadius: 25))
                
                Spacer()
                
                HStack{
                    Spacer()
                    
                    Button{
                        showExchangeInfo.toggle()
                    } label: {
                        Image(systemName: "info.circle.fill")
                            .font(.largeTitle)
                            .foregroundStyle(.white)
                    }
                    .padding(.trailing)
                }

            }
        }
        .task {
            try? Tips.configure()
        }
        .onChange(of: leftAmount) {
            if leftTyping {
                rightAmount = leftCurrency.convert(leftAmount, to: rightCurrency)
                saveLastConversion()
            }
        }
        .onChange(of: rightAmount) {
            if rightTyping {
                leftAmount = rightCurrency.convert(rightAmount, to: leftCurrency)
                saveLastConversion()
            }
        }
        .onChange(of: leftCurrency, {
            leftAmount = rightCurrency.convert(rightAmount, to: leftCurrency)
            saveLastConversion()
        })
        .onChange(of: rightCurrency, {
            rightAmount = leftCurrency.convert(leftAmount, to: rightCurrency)
            saveLastConversion()
        })
        .sheet(isPresented: $showExchangeInfo, content: {
            ExchangeInfo()
        })
        .sheet(isPresented: $showSelectCurrency, content: {
            SelectCurrency(leftCurrency: $leftCurrency,rightCurrency: $rightCurrency)
        })
        .onTapGesture {
            hideKeyboard()
        }
    }
}

#Preview {
    ContentView()
}
