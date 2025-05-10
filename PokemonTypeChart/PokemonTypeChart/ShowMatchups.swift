//
//  ShowMatchups.swift
//  PokemonTypeChart
//
//  Created by Alice Zhang on 5/9/25.
//

import SwiftUI

struct showMatchups: View {
    
    var effectText: String
    var effectTypes: [String]
    
    var body: some View {
        VStack {
            Text(effectText)
            ForEach(effectTypes, id: \.self) { types in
                Image(types)
            }
        }
    }
    
}
