//  RaceGame.swift
//  In a Pickle
//
//  Created by Nanbon Biruk on 4/29/25.
//

 
import SwiftUI

struct Player {
    var name: String
    var score: Int = 0
}

struct RaceGameView: View {
    @State private var players: [Player] = []
    @State private var currentPlayerIndex = 0
    @State private var winnerNames: [String] = []
    @State private var timeRemaining = 10
    @State private var timer: Timer?
    @State private var score = 0
    @State private var isGameActive = false
    @State private var gameStarted = false
    @State private var newPlayerName = ""
    @State private var winningScore = 0

    var body: some View {
        ZStack {
            Image("Gradient")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()

            VStack {
                Text("Race Game")
                    .font(.custom("Times New Roman", size: 50))
                    .foregroundColor(.white)
                    .padding()

                Text(players.isEmpty ? "Add players to start" : "Players: \(players.map { $0.name }.joined(separator: ", "))")
                    .foregroundColor(.white)
                    .padding()

                Text("Time Left: \(timeRemaining)")
                    .foregroundColor(.white)
                    .padding()

                Text("Score: \(score)")
                    .foregroundColor(.white)
                    .padding()

                if !gameStarted {
                    TextField("Enter player name", text: $newPlayerName)
                        .padding()
                        .background(Color.white)
                        .foregroundColor(.black)
                        .cornerRadius(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.gray, lineWidth: 1)
                        )
                        .frame(maxWidth: 300)
                        .padding()

                    Button(action: addPlayer) {
                        Text("Add Player")
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .padding()
                }

                if players.count > 0 && !gameStarted {
                    Button(action: startGame) {
                        Text("Start Game")
                            .padding()
                            .background(Color.green)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .padding()
                }

                if isGameActive {
                    Button(action: tapButtonPressed) {
                        Text("Tap as fast as you can!")
                            .font(.title2)
                            .padding()
                            .background(Color.orange)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .padding()
                }

                if gameStarted && !isGameActive && currentPlayerIndex < players.count {
                    Button(action: nextTurn) {
                        Text("Next Player")
                            .padding()
                            .background(Color.purple)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .padding()
                }

                if gameStarted && currentPlayerIndex >= players.count {
                    Text("The winner is: \(winnerNames.joined(separator: ", ")) with \(winningScore) taps!")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                }
            }
            .onAppear {
                resetGame()
            }
        }
    }

    func addPlayer() {
        if !newPlayerName.isEmpty {
            let newPlayer = Player(name: newPlayerName)
            players.append(newPlayer)
            newPlayerName = ""
        }
    }

    func startGame() {
        gameStarted = true
        startTurn()
    }

    func startTurn() {
        if currentPlayerIndex >= players.count {
            showWinner()
            return
        }

        score = 0
        timeRemaining = 10
        isGameActive = true
        startTimer()
    }

    func tapButtonPressed() {
        score += 1
    }

    func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            DispatchQueue.main.async {
                timeRemaining -= 1
                if timeRemaining == 0 {
                    endTurn()
                }
            }
        }
    }

    func endTurn() {
        timer?.invalidate()
        isGameActive = false
        players[currentPlayerIndex].score = score
        currentPlayerIndex += 1

        if currentPlayerIndex >= players.count {
            showWinner()
        }
    }

    func nextTurn() {
        startTurn()
    }

    func showWinner() {
        let highestScore = players.map { $0.score }.max() ?? 0
        winningScore = highestScore
        winnerNames = players.filter { $0.score == highestScore }.map { $0.name }
    }

    func resetGame() {
        players.removeAll()
        currentPlayerIndex = 0
        winnerNames.removeAll()
        winningScore = 0
        timeRemaining = 10
        score = 0
        gameStarted = false
        isGameActive = false
    }
}

struct GameContentView: View {
    var body: some View {
        RaceGameView()
    }
}

struct GameContentView_Previews: PreviewProvider {
    static var previews: some View {
        GameContentView()
    }
}
