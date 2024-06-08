//
//  CurrencyTip.swift
//  LOTR Converter
//
//  Created by Ishaan Das on 08/06/24.
//

import TipKit

struct CurrencyTip: Tip {
    var title = Text("Change Currency")
    
    var message: Text? = Text("You can tap on the left or right currency to bring up the Select Currency screen.")
}
