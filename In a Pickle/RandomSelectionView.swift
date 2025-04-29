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

            // Visual pointer at the top
            Triangle()
                .fill(Color.black)
                .frame(width: 20, height: 20)
                .offset(y: -160)
        }
        .rotationEffect(.degrees(rotationAngle))
    }
}

struct Triangle: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.midX, y: rect.minY)) // top
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY)) // bottom right
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY)) // bottom left
        path.closeSubpath()
        return path
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
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)

            Button("Add") {
                if !newInputName.isEmpty {
                    userNames.append(newInputName)
                    newInputName = ""
                }
            }
            .padding()

            ViewSpin(rotationAngle: $rotationAngle, userNames: $userNames)
                .frame(width: 300, height: 300)
                .padding()

            Button("Spin") {
                guard !userNames.isEmpty else { return }

                let randomIndex = Int.random(in: 0..<userNames.count)

                let targetAngle = 360.0 - (Double(randomIndex) * anglePerSegment)

                let extraSpins = Double(Int.random(in: 3...6)) * 360
                let finalRotation = extraSpins + targetAngle

                withAnimation(.easeOut(duration: 2)) {
                    rotationAngle = finalRotation
                }

                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    selectedName = userNames[randomIndex]
                }
            }
            .padding()

            if let name = selectedName {
                Text("Selected Person: \(name)")
                    .padding()
                    .font(.headline)
            }
        }
    }
}

struct contentView: View {
    var body: some View {
        RandomView()
    }
}

#Preview {
    ContentView()
}

