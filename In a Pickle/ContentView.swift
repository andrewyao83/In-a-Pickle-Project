//
//  ContentView.swift
//  In a Pickle
//
//  Created by Andrew Yao on 4/26/25.
//

import SwiftUI

struct ContentView: View {
    @State private var moveUp = false
    @State private var showContent = false
    
    var body: some View {
        NavigationView {
            VStack {
                Image("LoadingScreenIcon")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                    .offset(y: moveUp ? -100 : 0)
                    .animation(.easeInOut(duration: 2), value: moveUp)
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now()) {
                            moveUp = true
                            DispatchQueue.main.asyncAfter(deadline: .now()) {
                                showContent = true
                            }
                        }
                    }
                
                if showContent {
                    Text("In a Pickle?")
                        .font(.custom("Times New Roman", size: 40))
                        .padding()
                    
                    NavigationLink(destination: RandomView()) {
                        Text("Randomized Selection")
                            .font(.custom("Times New Roman", size: 18))
                            .padding()
                            .background(Color.mint)
                            .foregroundColor(.white)
                            .cornerRadius(50)
                    }
                    
                    NavigationLink(destination: CompetitiveSelectionView()) {
                        Text("Competitive Selection")
                            .font(.custom("Times New Roman", size: 18))
                            .padding()
                            .background(Color.green)
                            .foregroundColor(.white)
                            .cornerRadius(50)
                    }
                }
            }
            .navigationBarHidden(true)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
