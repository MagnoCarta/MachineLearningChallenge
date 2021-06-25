//
//  SoundView.swift
//  MachineLearning
//
//  Created by Gilberto Magno on 6/15/21.
//

import Foundation
import SwiftUI


var newDots: [Dots] = []
var deadDots: [Dots] = []

extension Color {

    func color(colorEnum: DotColor) -> Color {
        switch colorEnum {
        case .blue:
            return Color.blue
        case .red:
            return Color.red
        case .green:
            return Color.green
        case .yellow:
            return Color.yellow
        case .purple:
            return Color.purple
        case .orange:
            return Color.orange
        case .pink:
            return Color.pink
        case .brown:
            return Color.gray
        case .black:
            return Color.black
        case .white:
            return Color.white
//        case .rainbow:
//            return Color.clear
        }
    }
    func color(colorEnum: DotColors) -> Color {
        switch colorEnum {
        case .blue:
            return Color.blue
        case .red:
            return Color.red
        case .green:
            return Color.green
        case .yellow:
            return Color.yellow
        case .white:
            return Color.white
        }
    }

}

enum DotState {
    case leftAndTopcorner
    case center
    case topCorner
    case bottomCorner
    case rightCorner
    case leftCorner
    case leftAndBotCorner
    case rightAndTopCorner
    case rightAndBotCorner
}

enum dotHungry: Int {
    case full = 4
    case fine = 3
    case okay = 2
    case starving = 1
    case dead = 0
}

enum Direction {
    case right
    case left
    case top
    case bottom
}

enum Action {
    case atack
    case reproduce
}

enum DotColor: String,CaseIterable {

    case blue 
    // Blue are neutral, they dont judge colors and trust they neighborhood at first moment , so problably will provide assist, if its  starving, it will atack, but dont show if its starving
    // no hates
    // no loves
    case red
    // Agressive type ,begin with strong atack and got double atack, but they are dumb and let show their stats
    // HATES Pink
    // Love reds
    case green
    // Green are helpers,they loss only 2 food to reproduce
    //Love reds
    // Hate White
    case yellow
    // yellow are Defenders , they get double defense when defending, and get double food, but they cant atack
    case purple
    //Purple is the product of Blue and Red, have double atack, but normally just atack when in trouble.
    case orange
    // Oragen is the product of red and yellow, they are defenders with agressive attitude, they can atack,but only when defense is high enough, loses 2 food sometimes
    case pink
    //Pink is the luxuous , he get 1 food every round pass and values more
    case brown
    //Brown is the product of 3 couple, blue orange,red green yellow purple, so it normally dont atack this colors and get 1 food for each one in their side, they cant defende themselves , but cost 1 to move
    case black
    // Black is like blue, but all colros product become black, it tries to dominate by reproduction
    case white
    // reproduct alone spending half of the food, it begins with double shield and atack
 //   case rainbow
    // mutation
    // DEAD

}

enum DotColors: String,CaseIterable {

    case blue
    // Blue are neutral, they dont judge colors and trust they neighborhood at first moment , so problably will provide assist, if its  starving, it will atack, but dont show if its starving
    // no hates
    // no loves
    case red
    // Agressive type ,begin with strong atack and got double atack, but they are dumb and let show their stats
    // HATES Pink
    // Love reds
    case green

    case yellow

    case white
}



class Vector {
    var x: Int
    var y: Int
    init(x:Int,y:Int) {
        self.x = x
        self.y = y
    }
}

class Brain {

    var colorsSocial: [DotColors: Int] = [:]
    var oponents: [Dots] = []
    var actDot: Dots?
    var atackdDots: [Dots] = []

    func getPriorityHate(myColor: DotColors) {
        switch myColor {
        case .blue:
            colorsSocial[DotColors.red] = 3
            colorsSocial[DotColors.yellow] = 2
            colorsSocial[DotColors.green] = 0
            colorsSocial[DotColors.blue] = -1
            colorsSocial[DotColors.white] = -2
        case .red:
            colorsSocial[DotColors.blue] = 3
            colorsSocial[DotColors.yellow] = 2
            colorsSocial[DotColors.green] = 0
            colorsSocial[DotColors.red] = -1
            colorsSocial[DotColors.white] = -2
        case .green:
            colorsSocial[DotColors.red] = 3
            colorsSocial[DotColors.yellow] = 2
            colorsSocial[DotColors.blue] = 0
            colorsSocial[DotColors.green] = -1
            colorsSocial[DotColors.white] = -2
        case .yellow:
            colorsSocial[DotColors.red] = 3
            colorsSocial[DotColors.blue] = 2
            colorsSocial[DotColors.green] = 0
            colorsSocial[DotColors.yellow] = -1
            colorsSocial[DotColors.white] = -2
        case .white:
            colorsSocial[DotColors.red] = 3
            colorsSocial[DotColors.yellow] = 2
            colorsSocial[DotColors.green] = 0
            colorsSocial[DotColors.blue] = -1
            colorsSocial[DotColors.white] = -2
        }
    }

    func act(dot: Dots) {
        oponents.sort(by: {
            if colorsSocial[$0.colorEnum]! != colorsSocial[$1.colorEnum]! {
                return colorsSocial[$0.colorEnum]! < colorsSocial[$1.colorEnum]!
            }else {
                return colorsSocial[$0.colorEnum]! > colorsSocial[$1.colorEnum]!
            }
        })

        if oponents.last?.colorEnum != dot.colorEnum && oponents.last?.colorEnum != DotColors.white {
            actDot = oponents.last
        }

    }


    func checkSocial(dot: Dots,atacked: Bool,helped:Bool){
    }


    func reInitBrain(dot: Dots,dots: [Dots]) {
        oponents.removeAll()
        getSideOponents(dot: dot,dots: dots)
        getPriorityHate(myColor: dot.colorEnum)
        act(dot: dot)
    }

    func getLeftOponent(dot: Dots,dots: [Dots]) {
         oponents.append(dots[dot.dotIndex-1])
    }
    func getRightOponent(dot: Dots,dots: [Dots]) {
        oponents.append(dots[dot.dotIndex+1])
    }
    func getTopOponent(dot: Dots,dots: [Dots]) {
        oponents.append(dots[dot.dotIndex-dot.numberOfColumns])
    }
    func getBottomOponent(dot: Dots,dots: [Dots]) {
        oponents.append(dots[dot.dotIndex+dot.numberOfColumns])
    }


    func getSideOponents(dot: Dots,dots: [Dots]) {
        switch dot.state {
        case .bottomCorner:
            getLeftOponent(dot: dot,dots: dots)
            getTopOponent(dot: dot, dots: dots)
            getRightOponent(dot: dot, dots: dots)
        case .leftAndTopcorner:
            getRightOponent(dot: dot, dots: dots)
            getBottomOponent(dot: dot, dots: dots)
        case .center:
            getLeftOponent(dot: dot, dots: dots)
            getTopOponent(dot: dot, dots: dots)
            getRightOponent(dot: dot, dots: dots)
            getBottomOponent(dot: dot, dots: dots)
        case .topCorner:
            getLeftOponent(dot: dot, dots: dots)
            getRightOponent(dot: dot, dots: dots)
            getBottomOponent(dot: dot, dots: dots)
        case .rightCorner:
            getLeftOponent(dot: dot, dots: dots)
            getTopOponent(dot: dot, dots: dots)
            getBottomOponent(dot: dot, dots: dots)
        case .leftCorner:
            getTopOponent(dot: dot, dots: dots)
            getRightOponent(dot: dot, dots: dots)
            getBottomOponent(dot: dot, dots: dots)
        case .leftAndBotCorner:
            getTopOponent(dot: dot, dots: dots)
            getRightOponent(dot: dot, dots: dots)
        case .rightAndTopCorner:
            getLeftOponent(dot: dot, dots: dots)
            getBottomOponent(dot: dot, dots: dots)
        case .rightAndBotCorner:
            getLeftOponent(dot: dot, dots: dots)
            getTopOponent(dot: dot, dots: dots)
        }
    }

}



class generator {

    func getPositions(dots: [Dots],dot: Dots) -> [Vector] {
        var positions: [Vector] = []
        switch dot.state {

        case .leftAndTopcorner:
            if dots[dot.dotIndex+1].colorEnum == DotColors.white {
                positions.append(dots[dot.dotIndex+1].position)
            }
            if dots[dot.dotIndex+9].colorEnum == DotColors.white {
                positions.append( dots[dot.dotIndex+9].position)
            }
        case .center:
            if dots[dot.dotIndex+1].colorEnum == DotColors.white {
                positions.append(dots[dot.dotIndex+1].position)
            }
            if dots[dot.dotIndex+9].colorEnum == DotColors.white {
                positions.append(dots[dot.dotIndex+9].position)
            }
            if dots[dot.dotIndex-1].colorEnum == DotColors.white {
                positions.append(dots[dot.dotIndex-1].position)
            }
            if dots[dot.dotIndex-9].colorEnum == DotColors.white {
                positions.append(dots[dot.dotIndex-9].position)
            }
        case .topCorner:
            if dots[dot.dotIndex+1].colorEnum == DotColors.white {
                positions.append(dots[dot.dotIndex+1].position)
            }
            if dots[dot.dotIndex+9].colorEnum == DotColors.white {
                positions.append(dots[dot.dotIndex+9].position)
            }
            if dots[dot.dotIndex-1].colorEnum == DotColors.white {
                positions.append(dots[dot.dotIndex-1].position)
            }

        case .bottomCorner:
            if dots[dot.dotIndex+1].colorEnum == DotColors.white {
                positions.append( dots[dot.dotIndex+1].position)
            }
            if dots[dot.dotIndex-9].colorEnum == DotColors.white {
                positions.append(dots[dot.dotIndex-9].position)
            }
            if dots[dot.dotIndex-1].colorEnum == DotColors.white {
                positions.append(dots[dot.dotIndex-1].position)
            }
        case .rightCorner:
            if dots[dot.dotIndex-1].colorEnum == DotColors.white {
                positions.append(dots[dot.dotIndex-1].position)
            }
            if dots[dot.dotIndex+9].colorEnum == DotColors.white {
                positions.append(dots[dot.dotIndex+9].position)
            }
            if dots[dot.dotIndex-9].colorEnum == DotColors.white {
                positions.append(dots[dot.dotIndex-9].position)
            }
        case .leftCorner:
            if dots[dot.dotIndex+1].colorEnum == DotColors.white {
                positions.append(dots[dot.dotIndex+1].position)
            }
            if dots[dot.dotIndex+9].colorEnum == DotColors.white {
                positions.append(dots[dot.dotIndex+9].position)
            }
            if dots[dot.dotIndex-9].colorEnum == DotColors.white {
                positions.append(dots[dot.dotIndex-9].position)
            }
        case .leftAndBotCorner:
            if dots[dot.dotIndex+1].colorEnum == DotColors.white {
                positions.append(dots[dot.dotIndex+1].position)
            }
            if dots[dot.dotIndex-9].colorEnum == DotColors.white {
                positions.append(dots[dot.dotIndex-9].position)
            }
        case .rightAndTopCorner:
            if dots[dot.dotIndex-1].colorEnum == DotColors.white {
                positions.append(dots[dot.dotIndex-1].position)
            }
            if dots[dot.dotIndex+9].colorEnum == DotColors.white {
                positions.append(dots[dot.dotIndex+9].position)
            }
        case .rightAndBotCorner:
            if dots[dot.dotIndex-1].colorEnum == DotColors.white {
                positions.append(dots[dot.dotIndex-1].position)
            }
            if dots[dot.dotIndex-9].colorEnum == DotColors.white {
                positions.append(dots[dot.dotIndex-9].position)
            }
        }
        return positions
    }

    func possibleBirthPlaces(dots: [Dots],color: DotColors) -> [Vector] {
        var positions: [Vector] = []
        dots.forEach {
            if $0.colorEnum == color {
                positions.append(contentsOf:getPositions(dots: dots, dot: $0))
            }

        }
        return positions
    }

    func mutation(dots: [Dots]) -> [Dots] {
        //Aleatoriedade de 5%
        var newDots = dots
        if Int.random(in: 0...20) == 0 {
            let position = Vector(x: Int.random(in: 0...8), y: Int.random(in: 0...8))
            let newDot = Dots(position: Vector(x: Int.random(in: 0...8), y: Int.random(in: 0...8)), color: [DotColors.blue,DotColors.red,DotColors.yellow,DotColors.green].randomElement()!, indexDot: indexDot)
            indexDot += 1
            newDots[newDot.dotIndex] = newDot
        }
        return newDots
    }

    func newReproduced(color: DotColors,dots:[Dots]) -> [Dots]{
        if possibleBirthPlaces(dots: dots, color: color).count > 0 {
        let randomNumber = Int.random(in: 0...possibleBirthPlaces(dots: dots, color: color).count-1)
        let newDot = Dots(position: possibleBirthPlaces(dots: dots, color: color)[randomNumber], color: color, indexDot: indexDot)
            var newDots = dots
            newDots[newDot.dotIndex] = newDot
            indexDot += 1
            return newDots
        }
        return dots
    }

}

class interaction {

    func interacting(dot1:Dots,dots: [Dots]) -> [Dots] {
        guard let atackedDot = dot1.brain.actDot else {return dots}

        var dotss = dots
        if atackedDot.colorEnum == DotColors.red && atackedDot.passive == true {
            atackedDot.defense -= 1
            atackedDot.passive = false
        }else {
        atackedDot.defense -= dot1.atack
        }
        dotss[atackedDot.dotIndex] = atackedDot
        if atackedDot.defense < 1 {

            var newDot = Dots(position: atackedDot.position, color: DotColors.white, indexDot: indexDot)
            switch dot1.colorEnum {

            case .blue:
                newDot = Dots(position: atackedDot.position, color: DotColors.blue, indexDot: indexDot)
            case .red:
                dot1.passive = true
                dot1.defense += 1
            case .green:
                dot1.defense += 3
            case .yellow:
                dot1.defense += 1
            case .white:
                break
            }
            indexDot += 1
            dotss[dot1.dotIndex] = dot1
            dotss[newDot.dotIndex] = newDot
        }
        return dotss
    }

//    func changeDeadDots(dotss: [Dots]) -> [Dots] {
//        var dots = dotss
//        if newDots.count == 0 {
//            deadDots.forEach {
//                let newDot = Dots(position: $0.position, color: [DotColors.blue,DotColors.green,DotColors.red,DotColors.yellow].randomElement()!, indexDot: indexDot)
//                newDots.append(newDot)
//            }
//        }
//        newDots.forEach {
//            guard let dot = deadDots.first else {return}
//            $0.position = dot.position
//            $0.dotIndex = dot.dotIndex
//            dots[dot.dotIndex] = $0
//            deadDots.removeFirst()
//            newDots.removeFirst()
//        }
//        return dots
//    }

//    func death(dots: [Dots]) {
//        deadDots.append(contentsOf:  Fittest().getWorstDots(dots: dots))
//    }



}

class Fittest {
    func predictChampionColor() {

    }

    private func sortDots(dots:[Dots]) -> [Dots] {
        var sortableDots = dots
        return sortableDots
    }

    func getBestDots(dots: [Dots]) -> [Dots] {
        let sortableDots = sortDots(dots: dots)
        func getTopTen() -> [Dots] {
            var topTenDots: [Dots] = []
            for a in 0...9 {
                topTenDots.append(sortableDots[a])
            }
            return topTenDots
        }
        return getTopTen()
    }

    func getWorstDots(dots: [Dots]) -> [Dots] {
        let sortableDots = sortDots(dots: dots)
        func getLastTen() -> [Dots] {
            var topTenWorstDots: [Dots] = []
            for a in sortableDots.count-10...sortableDots.count-1 {
                topTenWorstDots.append(sortableDots[a])
            }
            return topTenWorstDots
        }
        return getLastTen()
    }

}

var indexDot: Int = 0

func passTurn(dots: [Dots]) -> [Dots] {

    return nextGeneration(dots: dots)
}


class Dots: Identifiable {
    var brain: Brain = Brain()
    var indexDot: Int
    var points = 0
    var defense = 0
    var atack = 0
    var position: Vector
    var color: Color
    var colorEnum: DotColors
    let numberOfColumns: Int = 9
    var state: DotState
    var dotIndex: Int
    var passive = true

    init(position: Vector,color: DotColors,indexDot: Int) {
        self.indexDot = indexDot
        self.color = Color(color.rawValue)
        self.colorEnum = color
        self.position = position
        self.state = DotState.center
        self.dotIndex = position.x*9 + position.y
        self.state = getState(position: position)

        switch colorEnum {

        case .blue:
            atack = 2
            defense = 2
        case .red:
            atack = 3
            defense = 3
        case .green:
            atack = 1
            defense = 1
        case .yellow:
            atack = 4
            defense = 4
        case .white: break
        }
    }

//    func getHateColor() -> Color {
//
//    }

    func getState(position: Vector) -> DotState {
        if position.y == 0 {
            if position.x == 0 {
                return DotState.leftAndTopcorner
            }
            if position.x == numberOfColumns - 1 {
                return DotState.leftAndBotCorner
            }
            return DotState.leftCorner
        }
        if position.y == numberOfColumns-1 {
            if position.x == 0 {
                return DotState.rightAndTopCorner
            }
            if position.x == numberOfColumns - 1 {
                return DotState.rightAndBotCorner
            }
            return DotState.rightCorner
        }
        if position.x == 0 {
            return DotState.topCorner
        }
        if position.x == numberOfColumns-1 {
            return DotState.bottomCorner
        }
        return DotState.center
    }

    func turn(color: Color){
//        switch state {
//
//        case .leftAndTopcorner:
//            <#code#>
//        case .center:
//            <#code#>
//        case .topCorner:
//            <#code#>
//        case .bottomCorner:
//            <#code#>
//        case .rightCorner:
//            <#code#>
//        case .leftCorner:
//            <#code#>
//        case .leftAndBotCorner:
//            <#code#>
//        case .rightAndTopCorner:
//            <#code#>
//        case .rightAndBotCorner:
//            <#code#>
//        }
    }


}

var items: [GridItem] {
  Array(repeating: .init(.adaptive(minimum: 120)), count: 9)
}


//
//var dots: [Dots] = []




func incrementDots() -> [Dots] {
    var dots: [Dots] = []
for x  in 0...8 {
    for y in 0...8 {
        if x <= 1 && y <= 1 {
            dots.append(Dots(position: Vector(x: x, y: y), color: DotColors.blue, indexDot: indexDot))
        }else if x >= 7 && y <= 1 {
            dots.append(Dots(position: Vector(x: x, y: y), color: DotColors.red, indexDot: indexDot))
        }else if x <= 1 && y >= 7 {
            dots.append(Dots(position: Vector(x: x, y: y), color: DotColors.yellow, indexDot: indexDot))
        }else if x >= 7 && y >= 7 {
            dots.append(Dots(position: Vector(x: x, y: y), color: DotColors.green, indexDot: indexDot))
        }else {
        dots.append(Dots(position: Vector(x: x, y: y), color: DotColors.white, indexDot: indexDot))
        }
        indexDot += 1
    }
}
    dots.forEach {
        $0.brain.getSideOponents(dot: $0, dots: dots)
    }
    return dots
}

func nextGeneration(dots: [Dots]) -> [Dots] {
    var returnDots = dots
    dots.forEach {
        $0.brain.reInitBrain(dot: $0, dots: returnDots)
        returnDots = interaction().interacting(dot1: $0, dots: returnDots)

    }

    return returnDots
}

struct SoundView: View {
    @State var selection: Int = 999
    @State var generation: Int
    @State var dots: [Dots]
    @State var greenReproduce = 1
    @State var redReproduce = 1
    @State var yellowReproduce = 1
    @State var blueReproduce = 1

    var body: some View {
     //   ForEach(dots,id:\.id) { a in
        VStack {
            
            HStack {
                ForEach(DotColor.allCases,id:\.rawValue) { color in
            Circle()
                .foregroundColor(Color(.clear).color(colorEnum: color))
                .onTapGesture {
                    if selection < 81 {
                        switch color {

                        case .blue:
                            dots[selection].colorEnum = DotColors.blue
                        case .red:
                            dots[selection].colorEnum = DotColors.red
                        case .green:
                            dots[selection].colorEnum = DotColors.green
                        case .yellow:
                            dots[selection].colorEnum = DotColors.yellow
                        case .purple:
                            dots[selection].colorEnum = DotColors.red
                        case .orange:
                            dots[selection].colorEnum = DotColors.green
                        case .pink:
                            dots[selection].colorEnum = DotColors.blue
                        case .brown:
                            dots[selection].colorEnum = DotColors.yellow
                        case .black:
                            dots[selection].colorEnum = DotColors.red
                        case .white:
                            dots[selection].colorEnum = DotColors.white
                        }
                        dots[selection].color = Color(.clear).color(colorEnum: color)
                    }
                }
                }
            }
            LazyVGrid(columns: items, spacing: 5) {
                ForEach(self.dots,id:\.id) { dot in
                    ZStack {
                        Circle().foregroundColor(Color(.clear).color(colorEnum: dot.colorEnum))
                    .frame(width: 40, height: 40, alignment: .center).onTapGesture(perform: {
                        selection = dot.dotIndex
                        print(selection)
                        print(dot.dotIndex)
                        })
                        if selection == dot.dotIndex {
                            Circle()
                                .stroke(Color.black, lineWidth: 4)
                            .frame(width: 40, height: 40)
                        }
                }
                }
            }
            Circle().frame(width: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, height: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                .onTapGesture {
                    if self.dots.count < 3 {
                    self.dots = incrementDots()
                    }else {
                        Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true, block: {_ in
                            dots = passTurn(dots: dots)
                            if blueReproduce % 2 == 0 {
                                dots = generator().newReproduced(color: DotColors.blue, dots: dots)
                            }
                            if greenReproduce % 1 == 0 {
                                dots = generator().newReproduced(color: DotColors.green, dots: dots)
                            }
                            if yellowReproduce % 4 == 0 {
                                dots = generator().newReproduced(color: DotColors.yellow, dots: dots)
                            }
                            if redReproduce % 3 == 0 {
                                dots = generator().newReproduced(color: DotColors.red, dots: dots)
                            }
                            blueReproduce += 1
                            greenReproduce += 1
                            yellowReproduce += 1
                            redReproduce += 1
                            dots = generator().mutation(dots: dots)
                        })

                    }
                }
        }
        .background(Color.black.opacity(0.6))
    }
}


struct SoundView_Previews: PreviewProvider {
    static var previews: some View {

        SoundView(generation: 0, dots: [])
    }
}


//Regras


// Pode se movimentar em 4 Direcoes, mas apenas duas por rodada
// Topo , Esquerda , Direita e Baixo

// Pode se Defender ou Atacar

// Atacar alguem que nao se defendeu em sua direcao, Vc mata ele e ganha X pontos dele

// Atacar alguem que se defendeu em sua direcao, vc morre pra ele, perdendo todos seus pontos pra ele

// Nao Matar Ninguem, voce perde 50% dos seus pontos

// Nao matar ninguem duas vezes, você morre


// Cada cor tem uma peculiaridade inicial, e os coloridos sao mutacoes sem previsoes possiveis








// BLUE reproduz a cada 2 rodadas
// Amigo do verde enquanto houver outras cores
// 2 de vida
// 2 de ataque
// ataca quem o atacar como prioridade
// não se reproduz quando houver inimigos proximos
// transforma o oponente em sua cor ao matar
// Red 3
// yellow 2
// green 0

// RED reproduz a cada 3 rodadas
// 3 atack
// 3 vida
// recebe 1 de dano no primeiro ataque
// Amigo de si mesmo
// Ataca quem o atacar como prioridade
// não se reproduz quando houver inimigos proximos
// regenera a vida e passiva ao matar
// Green 3
// yellow 2
// blue 1

// Green reproduz a cada rodada
// 1 Atack
// 1 Vida
// Amigo do azul enquanto houver Outras cores
// se reproduz mesmo quando houver inimigos proximos
// ganha 3 de vida para cada ponto assassinado
// yellow 3
// red 2
// blue 0

// Yellow reproduz a cada 4 rodadas
// 4 ataack
// 4 Vida
// Amigo de si mesmo
// Ataca quem o atacar como prioridade
// se reproduz apenas quando não houver inimigos proximos
// se regenera quando mata algum ponto
// blue 3
// green 2
// red 1



// GENERATOR -> RANDOMIZADOR ( O MUNDO FAZ)

// JULGADOR ->FILTRADOR (A GRNTE FAZ)

// SER ->


// VERDE -> AZUL -> ROSA

//FITTEST
