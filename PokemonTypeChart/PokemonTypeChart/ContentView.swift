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
                Spacer()
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
        if primaryType == nil {
            primaryType = name
        } else if primaryType == name {
            primaryType = nil
        } else if secondaryType == nil {
            secondaryType = name
        } else if secondaryType == name {
            secondaryType = nil
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
            // create 3 dictionaries or some structure counting strengths/weaks/immunes. Have default counts at 1 for each. *= 2 every time we encounter a supereffective type, *= 0.5 each time we encounter a not very effective type, *= 0 for immune
            // for the = 2 they are super effective. For = 4 they are 4x effective (strengths)
            // = 0.5 is not very effective, = 0.25 is 4x resists, 0 is immune
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
