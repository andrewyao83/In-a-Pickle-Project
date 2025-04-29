//
//  ContentView.swift
//  In a Pickle
//
//  Created by Andrew Yao on 4/26/25.
//

import SwiftUI

struct ContentView: View {
    @State private var isLoading = true
    var body: some View {
        VStack {
            if isLoading {
                Image(systemName: "LoadingScreenIcon")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                    .font(.largeTitle)
                    .foregroundColor(.blue)
                    .opacity(isLoading ? 1:0)
                    .onAppear{
                        withAnimation(.bouncy(duration: 2)) {
                            withAnimation(.easeOut(duration: 2)) {
                                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                    isLoading = false
                                }
                            }
                        }
                    }
                }else{
                    NavigationView {
                        VStack{
                            Text("In a Pickle?")
                            .font(.largeTitle)
                            .padding()
                            NavigationLink(destination: RandomSelectionView()) {
                            Text("Randomized Selection")
                                    .padding()
                                    .background(Color.blue)
                                    .foregroundColor(.white)
                                    .cornerRadius(8)
                            }
                            NavigationLink(destination: CompetitiveSelectionView()) {
                                Text("Competitive Selection")
                                    .padding()
                                    .background(Color.green)
                                    .foregroundColor(.white)
                                    .cornerRadius(8)
                            }
                        }
                        .navigationTitle(Text("Home"))
                    }
                }
            }
        .animation(.easeInOut, value: isLoading)
        }
    }

