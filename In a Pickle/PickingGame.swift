import SwiftUI

struct Element: Identifiable, Equatable {
    var id: UUID = UUID()
    var name: String
    var imageName: String
    var position: CGPoint
    var isSelected: Bool = false

    static func == (lhs: Element, rhs: Element) -> Bool {
        lhs.id == rhs.id
    }
}

func generatePentagonElements() -> [Element] {
    let center = CGPoint(x: 150, y: 150)
    let radius: CGFloat = 100
    let names = ["Beachball", "Coconut", "Boat", "Lifesaver", "Surfboard"]
    let imageNames = ["beachball", "coconut", "boat", "lifesaver", "surfboard"]

    return (0..<5).map { i in
        let angle = 2 * .pi * CGFloat(i) / 5 - .pi / 2
        let position = CGPoint(x: center.x + radius * cos(angle), y: center.y + radius * sin(angle))
        return Element(name: names[i], imageName: imageNames[i], position: position)
    }
}

struct PickingGameView: View {
    @State private var playerNames: [String] = []
    @State private var newPlayerName: String = ""
    @State private var playerLimitReached = false

    @State private var elements: [Element] = []
    @State private var target: CGPoint = .zero
    @State private var roundActive = false
    @State private var winner: String?
    @State private var winningElement: Element?
    @State private var tiedPlayers: [String] = []
    @State private var playerOrder: [String] = []
    @State private var currentTurn: Int = 0
    @State private var playerSelections: [String: Element] = [:]

    func startGame() {
        elements = generatePentagonElements()
        target = CGPoint(x: CGFloat.random(in: 30..<270), y: CGFloat.random(in: 30..<270))
        roundActive = true
        winner = nil
        winningElement = nil
        tiedPlayers = playerNames
        playerOrder = tiedPlayers.shuffled()
        currentTurn = 0
        playerSelections = [:]
    }

    func distance(from p1: CGPoint, to p2: CGPoint) -> CGFloat {
        sqrt(pow(p2.x - p1.x, 2) + pow(p2.y - p1.y, 2))
    }

    func handleSelection(element: Element) {
        guard roundActive else { return }

        let currentPlayer = playerOrder[currentTurn]
        playerSelections[currentPlayer] = element

        if playerSelections.count == tiedPlayers.count {
            let distances = playerSelections.map { (player, element) in
                (player, distance(from: element.position, to: target), element)
            }

            let minDist = distances.map { $0.1 }.min() ?? .infinity
            let closest = distances.filter { abs($0.1 - minDist) < 1e-5 }

            if closest.count == 1 {
                winner = closest.first?.0
                winningElement = closest.first?.2
                roundActive = false
            } else {
                // Tie-breaker
                tiedPlayers = closest.map { $0.0 }
                playerOrder = tiedPlayers.shuffled()
                currentTurn = 0
                playerSelections = [:]
                elements = generatePentagonElements().filter { element in
                    !playerSelections.values.contains(where: { $0.id == element.id })
                }
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
                .ignoresSafeArea()

            VStack(spacing: 15) {
                Text(" Beach Picking Game 🏝️")
                    .font(.custom("Times New Roman", size: 35))
                    .foregroundColor(Color.white)
                    .padding()

                HStack {
                    TextField("Enter player name", text: $newPlayerName)
                        .padding()
                        .textFieldStyle(RoundedBorderTextFieldStyle())

                    Button("Add Player") {
                        if !newPlayerName.isEmpty {
                            if playerNames.count < 5 {
                                playerNames.append(newPlayerName)
                                newPlayerName = ""
                                playerLimitReached = false
                            } else {
                                playerLimitReached = true
                            }
                        }
                    }.padding()
                }

                if playerLimitReached {
                    Text("You can only have 5 players.")
                        .foregroundColor(.red)
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
                    Text("🎯 Target: \(Int(target.x)), \(Int(target.y))")
                        .foregroundColor(.black)
                        .padding()

                    Text("Current Turn: \(playerOrder[currentTurn])")
                        .bold()
                        .foregroundColor(.black)

                    ZStack {
                        ForEach(elements) { element in
                            if !playerSelections.values.contains(where: { $0.id == element.id }) {
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
                            .fill(Color.red.opacity(0.05))
                            .frame(width: 10, height: 10)
                            .position(target)
                    }
                    .frame(width: 300, height: 300)
                    .background(Color.white.opacity(0.3))
                    .cornerRadius(12)
                }

                if let winner = winner {
                    Text("🎉 Winner: \(winner) 🎉")
                        .font(.title)
                        .foregroundColor(.green)

                    if let element = winningElement {
                        Image(element.imageName)
                            .resizable()
                            .frame(width: 80, height: 80)
                    }
                }

                if tiedPlayers.count > 1 && roundActive && playerSelections.isEmpty {
                    Text("Tie-breaker Round for: \(tiedPlayers.joined(separator: ", "))")
                        .foregroundColor(.orange)
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
