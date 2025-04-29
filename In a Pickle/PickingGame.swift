//
//  PickingGame.swift
//  In a Pickle
//
//  Created by Andrew Yao on 4/29/25.
//

import SwiftUI

// Model to represent each element on the beach (or grid)
struct Element {
    var id: UUID = UUID()
    var name: String
    var position: CGPoint
    var isSelected: Bool = false // Track if the element is selected
}

// Function to generate random positions for elements
func generateRandomPositions(count: Int, width: CGFloat, height: CGFloat) -> [Element] {
    var elements: [Element] = []
    for i in 0..<count {
        let position = CGPoint(x: CGFloat.random(in: 0..<width), y: CGFloat.random(in: 0..<height))
        let element = Element(name: "Element \(i + 1)", position: position)
        elements.append(element)
    }
    return elements
}

// ContentView
struct PickingGameView: View {
    @State private var playerNames: [String] = []
    @State private var currentTurn = 0
    @State private var elements: [Element] = []
    @State private var target: CGPoint = .zero
    @State private var winner: String?
    @State private var roundActive = true
    @State private var tiedPlayers: [String] = []
    
    @State private var newPlayerName: String = ""
    
    // Generate elements and set the target
    func startGame() {
        elements = generateRandomPositions(count: 5, width: 300, height: 300)
        target = CGPoint(x: CGFloat.random(in: 0..<300), y: CGFloat.random(in: 0..<300))
        winner = nil
        roundActive = true
        tiedPlayers = playerNames // All players start in the tie-breaker round
    }

    // Function to calculate the distance between two points
    func distance(from p1: CGPoint, to p2: CGPoint) -> CGFloat {
        return sqrt(pow(p2.x - p1.x, 2) + pow(p2.y - p1.y, 2))
    }
    
    // Function to handle player selection
    func handleSelection(element: Element) {
        let distances = elements.map { distance(from: $0.position, to: target) }
        let closestDistance = distances.min() ?? CGFloat.infinity
        let closestPlayers = playerNames.enumerated().filter { distances[$0.offset] == closestDistance }.map { $0.element }
        
        if closestPlayers.count == 1 {
            winner = closestPlayers.first
            roundActive = false
        } else {
            // If multiple players are tied, reset and move to the tie-breaker round
            tiedPlayers = closestPlayers
            elements = elements.filter { !$0.isSelected } // Reset unselected elements for tie-breaker
            currentTurn = 0
        }
    }

    var body: some View {
        VStack {
            Text("Beach Picking Game")
                .font(.largeTitle)
                .padding()

            HStack {
                TextField("Enter player name", text: $newPlayerName)
                    .padding()
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                Button("Add Player") {
                    if !newPlayerName.isEmpty {
                        playerNames.append(newPlayerName)
                        newPlayerName = ""
                    }
                }
                .padding()
            }
            
            if playerNames.count > 1 {
                Button("Start Game") {
                    startGame()
                }
                .padding()
            }
            
            if roundActive {
                Text("Current Turn: \(tiedPlayers[currentTurn])")
                    .padding()
                
                Text("Target is at: \(target.x, specifier: "%.1f"), \(target.y, specifier: "%.1f")")
                    .padding()
                
                // Display elements as buttons for the tie-breaker round
                HStack {
                    ForEach(elements, id: \.id) { element in
                        if !element.isSelected { // Only show unselected elements
                            Button(action: {
                                handleSelection(element: element)
                            }) {
                                Text(element.name)
                                    .padding()
                                    .background(Color.blue)
                                    .foregroundColor(.white)
                                    .cornerRadius(10)
                            }
                        }
                    }
                }
            }
            
            if let winner = winner {
                Text("Winner: \(winner)")
                    .font(.title)
                    .padding()
            }
            
            if tiedPlayers.count > 1 {
                Text("Tie-breaker round for: \(tiedPlayers.joined(separator: ", "))")
                    .font(.title2)
                    .padding()
            }
        }
        .padding()
    }
}

struct PickingGameView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
