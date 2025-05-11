//
//  ContentView.swift
//  PokemonTypeChart
//
//  Created by Alice Zhang on 5/9/25.
//

import SwiftUI

struct PokemonType: Identifiable, Codable, Hashable {
    var id: Int
    var name: String
    var strengths: [String]
    var weaknesses: [String]
    var immunes: [String]
    
}

struct ContentView: View {
    @State private var pokemonTypes = [PokemonType]()
    @State private var primaryType: String? = nil
    @State private var secondaryType: String? = nil
    @State private var invalidTyping = false
    @State private var invalidTypeError = "Invalid type combination!"
    @State private var weaks: [String] = []
    @State private var strengths: [String] = []
    @State private var immunities: [String] = []
    
    var body: some View {
        NavigationStack {
            VStack {
                Spacer()
                Text("Select up to two Pokemon types!")
                
                let columns = [
                    GridItem(.flexible()),
                    GridItem(.flexible()),
                    GridItem(.flexible())
                ]
                
                LazyVGrid(columns: columns, spacing: 10) {
                    ForEach(pokemonTypes, id: \.self) {
                        type in
                        Image(type.name)
                            .background(
                                Rectangle()
                                    .stroke(primaryType == type.name ? Color.orange : Color.clear, lineWidth: 4)
                                    .stroke(secondaryType == type.name ? Color.orange : Color.clear, lineWidth: 4)
                            )
                            .onTapGesture {
                                selectType(type.name)
                            }
                    }
                }
                .padding()
                Section() {
                    VStack {
                        Button {
                            generate(firstType: primaryType!, secondType: secondaryType ?? "None")
                        } label: {
                            generateButton(textColour: .blue, backgroundColour: .white)
                        } .disabled(primaryType == nil)
                        
                        .padding()
                        
                        HStack(alignment: .top) {
                            showMatchups(effectText: "Super effective:", effectTypes: strengths)
                            showMatchups(effectText: "Not very effective:", effectTypes: weaks)
                            showMatchups(effectText: "No effect:", effectTypes: immunities)
                            
                        }
                        
                    }
                    Spacer()
                }
                
            }
            .onAppear {
                pokemonTypes = decode()
            }
            .alert(invalidTypeError, isPresented: $invalidTyping) {
                
            } message: {
                Text("Please enter a valid type combination")
            }
        }
        
    }
    
    func decode() -> [PokemonType] {
        guard let url = Bundle.main.url(forResource: "types", withExtension: "json") else {
            fatalError("Failed to locate types.json in bundle")
        }
        
        guard let data = try? Data(contentsOf: url) else {
            fatalError("Failed to load file from types.json from bundle")
        }
        
        let decoder = JSONDecoder()
        
        guard let loadedFile = try? decoder.decode([PokemonType].self, from: data) else {
            fatalError("Failed to decode types.json from bundle")
        }
        
        return loadedFile
    }
    
    func selectType(_ name: String) {
        if primaryType == name {
            if let second = secondaryType {
                primaryType = second
                secondaryType = nil
            } else {
                primaryType = nil
            }
        } else if secondaryType == name {
            secondaryType = nil
        } else if primaryType == nil {
            primaryType = name
        } else if secondaryType == nil {
            secondaryType = name
        }
    }
    
    func generate(firstType: String, secondType: String) {
        immunities = []
        strengths = []
        weaks = []
        
        // error
        if (firstType == secondType) || (firstType == "None" && secondType != "None") {
            invalidTyping = true
            return
        }
        
        // dual type
        if firstType != "None" && secondType != "None" {
            var typeOne: PokemonType?
            var typeTwo: PokemonType?
            
            // get the two types
            for types in pokemonTypes {
                if types.name == firstType {
                    typeOne = types
                    
                } else if types.name == secondType {
                    typeTwo = types
                }
            }
            
            if let typeOne = typeOne, let typeTwo = typeTwo {
                // if one of the types hit for super effective: super effective
                for strength in typeOne.strengths {
                    strengths.append(strength)
                }
                for strength in typeTwo.strengths {
                    if !strengths.contains(strength) {
                        strengths.append(strength)
                    }
                }
                
                // if both types hit for not very effective/neutral: not very effective
                for weak in typeOne.weaknesses {
                    if !typeTwo.strengths.contains(weak) {
                        weaks.append(weak)
                    }
                }
                for weak in typeTwo.weaknesses {
                    if !typeOne.strengths.contains(weak) && !weaks.contains(weak) {
                        weaks.append(weak)
                    }
                }
                
                
                // if both types hit for no effect: no effect
                for immune in typeOne.immunes {
                    if typeTwo.immunes.contains(immune) {
                        immunities.append(immune)
                    }
                }
                
            }
            
        }
        
        // monotype
        if firstType != "None" && secondType == "None" {
            for types in pokemonTypes {
                if types.name == firstType {
                    for immune in types.immunes {
                        immunities.append(immune)
                    }
                    
                    for weak in types.weaknesses {
                        weaks.append(weak)
                    }
                    
                    for strength in types.strengths {
                        strengths.append(strength)
                    }
                }
            }
        }
    }
    
}

#Preview {
    ContentView()
}
