//
//  ContentView.swift
//  ServiceRuki
//
//  Created by Эльвира Филиппова on 30.09.2024.
//

import SwiftUI

enum CellState: String, CaseIterable {
    case dead = "Мёртвая", alive = "Живая", life = "Жизнь"
    
    var description: String {
        self == .dead ? "или прикидывается" : (self == .alive ? "и шевелится!" : "Ку-ку!")
    }
    
    var icon: String {
        self == .dead ? "💀" : (self == .alive ? "💥" : "🐣")
    }
    
    var gradientColors: [Color] {
        switch self {
        case .dead:
            return [Color.blue, Color.green.opacity(0.5)]
        case .alive:
            return [Color.yellow, Color.orange]
        case .life:
            return [Color.purple, Color.pink]
        }
    }
}

struct ContentView: View {
    @State private var cells: [CellState] = []
    @State private var lastThreeCells: [CellState] = []
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color.purple, Color.black]), startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 0) {
                Rectangle()
                    .fill(Color.purple)
                    .frame(height: 20)
                    .edgesIgnoringSafeArea(.top)
                
                VStack {
                    Text("Клеточное наполнение")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(.vertical, 20)
                    
                    ScrollView {
                        VStack(spacing: 10) {
                            ForEach(cells, id: \.self) { cell in
                                HStack {
                                    Text(cell.icon)
                                        .font(.largeTitle)
                                        .frame(width: 50, height: 50)
                                        .background(
                                            Circle()
                                                .fill(LinearGradient(
                                                    gradient: Gradient(colors: cell.gradientColors),
                                                    startPoint: .topLeading,
                                                    endPoint: .bottomTrailing
                                                ))
                                        )
                                    
                                    VStack(alignment: .leading) {
                                        Text(cell.rawValue).font(.headline)
                                        Text(cell.description).font(.subheadline).foregroundColor(.gray)
                                    }
                                    Spacer()
                                }
                                .padding()
                                .background(Color.white)
                                .cornerRadius(10)
                                .shadow(radius: 5)
                            }
                        }
                        .padding(.horizontal)
                    }
                    
                    Button("Сотворить", action: createCell)
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.purple)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .shadow(radius: 5)
                        .padding([.horizontal, .bottom], 20)
                }
            }
        }
    }
    
    func createCell() {
        let newCell: CellState
        if lastThreeCells.allSatisfy({ $0 == .alive }) {
            newCell = .life
        } else if lastThreeCells.allSatisfy({ $0 == .dead }) {
            newCell = .dead
        } else {
            newCell = Bool.random() ? .alive : .dead
        }
        
        cells.append(newCell)
        lastThreeCells.append(newCell)
        if lastThreeCells.count > 3 { lastThreeCells.removeFirst() }
    }
}
