//
//  RandomSelectionView.swift
//  In a Pickle
//
//  Created by Nanbon Biruk on 4/29/25.
//
import SwiftUI

struct Pie: Shape {
    var startAngle: Angle
    var endAngle: Angle
    
    func path(in rect: CGRect) -> Path {
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let radius = min(rect.width, rect.height) / 2
        let start = CGPoint(
            x: center.x + radius * cos(CGFloat(startAngle.radians)),
            y: center.y + radius * sin(CGFloat(startAngle.radians))
        )
        var path = Path()
        path.move(to: center)
        path.addLine(to: start)
        path.addArc(center: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: false)
        path.addLine(to: center)
        return path
    }
}

struct PieSliceView: View {
    var index: Int
    var anglePerSegment: Double
    var userNamesCount: Int
    
    var body: some View {
        Pie(
            startAngle: Angle(degrees: Double(index) * anglePerSegment),
            endAngle: Angle(degrees: Double(index + 1) * anglePerSegment)
        )
        .fill(Color(hue: Double(index) / Double(userNamesCount), saturation: 1, brightness: 1))
    }
}

struct ViewSpin: View {
    @Binding var rotationAngle: Double
    @Binding var userNames: [String]
    
    var anglePerSegment: Double {
        userNames.isEmpty ? 0 : 360.0 / Double(userNames.count)
    }
    
    var body: some View {
        ZStack {
            ForEach(0..<userNames.count, id: \.self) { index in
                PieSliceView(index: index, anglePerSegment: anglePerSegment, userNamesCount: userNames.count)
            }
        }
        .rotationEffect(.degrees(rotationAngle))
    }
}

struct RandomView: View {
    @State private var newInputName: String = ""
    @State private var userNames: [String] = []
    @State private var selectedName: String?
    @State private var rotationAngle: Double = 0
    
    var anglePerSegment: Double {
        userNames.isEmpty ? 0 : 360.0 / Double(userNames.count)
    }
    
    var body: some View {
        VStack {
            TextField("Add Player Name", text: $newInputName)
                .padding()
            
            Button("Add") {
                if !newInputName.isEmpty {
                    userNames.append(newInputName)
                    newInputName = ""
                }
            }
            
            ViewSpin(rotationAngle: $rotationAngle, userNames: $userNames)
                .frame(width: 300, height: 300)
            
            Button("Spin") {
                let spins = Double(Int.random(in: 3...6))
                let fullRotation = rotationAngle + 360 * spins
                let regularRotation = fullRotation.truncatingRemainder(dividingBy: 360)
                let fixedAngle = Int((360 - regularRotation) / anglePerSegment) % userNames.count
                
                withAnimation(.easeOut(duration: 2)) {
                    rotationAngle = fullRotation
                }
                
                if !userNames.isEmpty && anglePerSegment != 0 {
                    selectedName = userNames[fixedAngle]
                }
            }
            
            if let name = selectedName {
                Text("Selected Person: \(name)")
                    .padding()
            }
        }
    }
}
