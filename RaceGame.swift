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
    
    var body: some View {
        VStack {
            Text("Race Game")
                .font(.custom("Times New Roman", size: 50))
                .padding()
            Text(players.isEmpty ? "Add players to start" : "Players: \(players.map { $0.name }.joined(separator: ", "))")
                .padding()
            
            Text("Time Left: \(timeRemaining)")
                .padding()
            
            Text("Score: \(score)")
                .padding()
            
            if !gameStarted {
                TextField("Enter player name", text: $newPlayerName)
                    .padding()
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
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
            
            if gameStarted {
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
                Text("The winner is: \(winnerNames.joined(separator: ", ")) with \(score) taps!")
                    .font(.headline)
                    .padding()
            }
        }
        .onAppear {
            resetGame()
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
        
        if currentPlayerIndex < players.count {
            // Show the next player button
            gameStarted = true
        } else {
            showWinner()
        }
    }
    
    func nextTurn() {
        score = 0
        timeRemaining = 10
        isGameActive = true
        startTurn()
    }
    
    func showWinner() {
        var highestScore = 0
        for player in players {
            if player.score > highestScore {
                highestScore = player.score
                winnerNames = [player.name]
            } else if player.score == highestScore {
                winnerNames.append(player.name)
            }
        }
    }
    
    func resetGame() {
        players.removeAll()
        currentPlayerIndex = 0
        winnerNames.removeAll()
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
