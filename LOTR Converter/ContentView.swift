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
    
    @State var leftAmount = ""
    @State var rightAmount = ""
    
    @State var leftCurrency: Currency = .silverPiece
    @State var rightCurrency: Currency = .goldPiece
    
    @FocusState var leftTyping
    @FocusState var rightTyping
    
    private func hideKeyboard() {
        leftTyping = false
        rightTyping = false
    }
    
    let userDefaults = UserDefaults.standard
    
    private func saveLastConversion() {
        userDefaults.set(leftAmount, forKey: "leftAmountKey")
        userDefaults.set(rightAmount, forKey: "rightAmountKey")
        userDefaults.set(leftCurrency.rawValue, forKey: "leftCurrencyKey")
        userDefaults.set(rightCurrency.rawValue, forKey: "rightCurrencyKey")
    }
    
    private func loadLastConversion() {
        if let savedLeftAmount = userDefaults.object(forKey: "leftAmountKey") as? String {
            leftAmount = savedLeftAmount
        }
        if let savedRightAmount = userDefaults.object(forKey: "rightAmountKey") as? String {
            rightAmount = savedRightAmount
        }
        if let savedLeftCurrencyRawValue = userDefaults.object(forKey: "leftCurrencyKey") as? Double {
            leftCurrency = Currency(rawValue: savedLeftCurrencyRawValue)!
        }
        if let savedRightCurrencyRawValue = userDefaults.object(forKey: "rightCurrencyKey") as? Double {
            rightCurrency = Currency(rawValue: savedRightCurrencyRawValue)!
        }
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
                
                // Conversion Section
                HStack{
                    VStack{
                        HStack{
                            Image(leftCurrency.image)
                                .resizable()
                                .scaledToFit()
                                .frame(height: 33)
                            
                            Text(leftCurrency.name)
                                .font(.headline)
                                .foregroundStyle(.white)
                        }
                        .padding(.bottom,-5)
                        .onTapGesture {
                            showSelectCurrency.toggle()
                        }
                        .popoverTip(CurrencyTip(), arrowEdge: .bottom)
                        
                        TextField("Amount", text: $leftAmount)
                            .textFieldStyle(.roundedBorder)
                            .focused($leftTyping)
                            .keyboardType(.decimalPad)

                    }
                    
                    Image(systemName: "equal")
                        .font(.largeTitle)
                        .foregroundStyle(.white)
                        .symbolEffect(.pulse)
                    
                    // Right Conversion Section
                    VStack{
                        //currency
                        HStack{
                            Text(rightCurrency.name)
                                .font(.headline)
                                .foregroundStyle(.white)
                            
                            Image(rightCurrency.image)
                                .resizable()
                                .scaledToFit()
                                .frame(height: 33)
                        }
                        .padding(.bottom,-5)
                        .onTapGesture {
                            showSelectCurrency.toggle()
                        
                        }
                        
                        TextField("Amount", text: $rightAmount)
                            .textFieldStyle(.roundedBorder)
                            .multilineTextAlignment(.trailing)
                            .focused($rightTyping)
                            .keyboardType(.numberPad)
                    }
                }
                .padding()
                .background(.black.opacity(0.5))
                .clipShape(.rect(cornerRadius: 25))
                
                Spacer()
                // Info button
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
            loadLastConversion()
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
