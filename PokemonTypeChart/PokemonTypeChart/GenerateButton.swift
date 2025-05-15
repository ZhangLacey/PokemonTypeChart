//
//  GenerateButton.swift
//  PokemonTypeChart
//
//  Created by Alice Zhang on 5/9/25.
//

import SwiftUI

struct generateButton: View {
    
    var buttonText: String
    var textColour: Color
    var backgroundColour: Color
    
    var body: some View {
        Text(buttonText)
            .frame(width: 240, height: 50)
            .background(backgroundColour)
            .foregroundColor(textColour)
            .font(.system(size: 20, weight: .bold, design: .default))
            .cornerRadius(10)
            .shadow(radius: 10)
    }
    
    
}
