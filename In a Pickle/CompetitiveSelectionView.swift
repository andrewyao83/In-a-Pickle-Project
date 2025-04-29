//
//  CompetitiveSelectionView.swift
//  In a Pickle
//
//  Created by Andrew Yao on 4/29/25.
//
import SwiftUI

struct CompetitiveSelectionView: View {
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("Fight for the Verdict")
                    .font(.custom("Times New Roman", size: 36))
                    .padding()
                Image("Luka")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 250, height: 300)
                NavigationLink(destination: RaceGameView()) {
                    Text("Race")
                        .font(.custom("Times New Roman", size: 24))
                        .padding()
                        .foregroundColor(.white)
                        .background(Color.black)
                        .cornerRadius(15)
                }
                
                NavigationLink(destination: PickingGameView()) {
                    Text("Scavenge")
                        .font(.custom("Times New Roman", size: 24))
                        .padding()
                        .foregroundColor(.white)
                        .background(Color.black)
                        .cornerRadius(15)
                }
            }
            .navigationBarTitle("Competitive Mode")
        }
    }
}

struct CompetitiveSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        CompetitiveSelectionView()
    }
}
