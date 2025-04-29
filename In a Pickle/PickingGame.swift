//
//  PickingGame.swift
//  In a Pickle
//
//  Created by Andrew Yao on 4/29/25.
//

import SwiftUI

struct Element: Identifiable {
    var id: UUID = UUID()
    var name: String
    var imageName: String
    var position: CGPoint
    var isSelected: Bool = false
}

func generateFixedElements() -> [Element] {
    return [
        Element(name: "Beachball", imageName: "beachball", position: CGPoint(x: 80, y: 100)),
        Element(name: "Coconut", imageName: "coconut", position: CGPoint(x: 200, y: 100)),
        Element(name: "Boat", imageName: "boat", position: CGPoint(x: 80, y: 250)),
        Element(name: "Lifesaver", imageName: "lifesaver", position: CGPoint(x: 200, y: 250)),
        Element(name: "Surfboard", imageName: "surfboard", position: CGPoint(x: 140, y: 180))
    ]
}

struct PickingGameView: View {
    @State private var playerNames: [String] = []
    @State private var currentTurn = 0
    @State private var elements: [Element] = []
    @State private var target: CGPoint = .zero
    @State private var winner: String?
    @State private var winningElement: Element? = nil
    @State private var roundActive = false
    @State private var tiedPlayers: [String] = []
    @State private var playerOrder: [String] = []
    @State private var newPlayerName: String = ""

    func startGame() {
        elements = generateFixedElements()
        target = CGPoint(x: CGFloat.random(in: 0..<300), y: CGFloat.random(in: 0..<300))
        winner = nil
        winningElement = nil
        roundActive = true
        tiedPlayers = playerNames
        playerOrder = playerNames.shuffled()
        currentTurn = 0
    }

    func distance(from p1: CGPoint, to p2: CGPoint) -> CGFloat {
        sqrt(pow(p2.x - p1.x, 2) + pow(p2.y - p1.y, 2))
    }

    func handleSelection(element: Element) {
        if let index = elements.firstIndex(where: { $0.id == element.id }) {
            elements[index].isSelected = true
        }

        let picked = elements.filter { $0.isSelected }
        if picked.count == tiedPlayers.count {
            var playerDistances: [(String, CGFloat, Element)] = []
            for (i, player) in tiedPlayers.enumerated() {
                let selectedElement = picked[i]
                let dist = distance(from: selectedElement.position, to: target)
                playerDistances.append((player, dist, selectedElement))
            }

            let minDist = playerDistances.map { $0.1 }.min() ?? .infinity
            let closest = playerDistances.filter { abs($0.1 - minDist) < 1e-5 }

            if closest.count == 1 {
                winner = closest.first?.0
                winningElement = closest.first?.2
                roundActive = false
            } else {
                tiedPlayers = closest.map { $0.0 }
                elements = generateFixedElements().filter { !$0.isSelected }
                currentTurn = 0
            }
        } else {
            currentTurn += 1
        }
    }

    var body: some View {
        ZStack {
            Image("Beach")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)

            VStack {
                Text("Beach Picking Game")
                    .font(.custom("Times New Roman", size: 36))
                    .foregroundColor(.white)
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
                    }.padding()
                }

                if playerNames.count > 1 && !roundActive {
                    Button("Start Game") {
                        startGame()
                    }
                    .padding()
                    .background(Color.yellow)
                    .cornerRadius(10)
                }

                if roundActive {
                    Text("Target: \(Int(target.x)), \(Int(target.y))")
                        .padding()
                        .foregroundColor(.white)

                    Text("Current Turn: \(tiedPlayers[currentTurn])")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding(.bottom)

                    ZStack {
                        ForEach(elements) { element in
                            if !element.isSelected {
                                Image(element.imageName)
                                    .resizable()
                                    .frame(width: 60, height: 60)
                                    .position(element.position)
                                    .onTapGesture {
                                        handleSelection(element: element)
                                    }
                            }
                        }

                        Circle()
                            .fill(Color.red.opacity(0.5))
                            .frame(width: 10, height: 10)
                            .position(target)
                    }
                    .frame(width: 300, height: 300)
                }

                if let winner = winner {
                    Text("🎉 Winner: \(winner) 🎉")
                        .font(.title)
                        .foregroundColor(.green)
                        .padding()

                    if let winningElement = winningElement {
                        Image(winningElement.imageName)
                            .resizable()
                            .frame(width: 80, height: 80)
                            .overlay(Color.black.opacity(0.3))
                            .position(winningElement.position)
                            .padding()
                    }
                }

                if tiedPlayers.count > 1 && roundActive {
                    Text("Tie-breaker for: \(tiedPlayers.joined(separator: ", "))")
                        .foregroundColor(.white)
                        .padding()
                }
            }
            .padding()
        }
    }
}

struct PickingGameView_Previews: PreviewProvider {
    static var previews: some View {
        PickingGameView()
    }
}
