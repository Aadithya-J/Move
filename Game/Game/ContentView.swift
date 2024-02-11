//
//  ContentView.swift
//  Game
//
//  Created by Aadithya Jayakaran on 08/02/24.
//

import SwiftUI

struct ContentView: View {
    @State var lists = [[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0]]
    @State var currentVals = 0
    @State private var isGameViewActive = false
    
    func start2(){
        let n = self.lists.count
        for i in 0..<n {
            for j in 0..<n {
                self.lists[i][j] = Int.random(in: 0..<30)
            }
        }
        self.currentVals = self.lists[0][0]
    }
    var body: some View {
        NavigationStack{
            NavigationView(content: {
                VStack{
                    
                    Button(action: {
                        start2()
                        isGameViewActive = true
                    }) {
                        ZStack{
                            RoundedRectangle(cornerRadius: 10.0)
                                .fill(Color.green)
                                .padding()
                            
                            HStack{
                                Image(systemName: "play.fill")
                                    .font(.title)
                                    .foregroundColor(.white)
                                Text("Start")
                                    .padding()
                                    .foregroundColor(.white)
                                    .font(.title)
                                
                            }
                            .padding()
                            
                        }
                        .frame(width: 200, height: 25, alignment: .center)
                        
                    }
                    .background(
                        NavigationLink(
                            value: isGameViewActive,
                            label: {
                                EmptyView()
                            }
                        )
                        .hidden()
                    )
                    .navigationDestination(
                        isPresented: $isGameViewActive,
                        destination: {
                            gameview(list: lists, currentVal: currentVals)
                        }
                    )

                    
                    ZStack{
                        VStack{
                            ZStack{
                                
                                RoundedRectangle(cornerRadius: 15.0)
                                    .stroke(Color.black,lineWidth: 3)
                                    .frame(width: 380,height: 250,alignment: .center)
                                
                                VStack{
                                    Text("Reach Destination within 50 moves to win")
                                        .padding(5)
                                    Text("Numbers in the grid are in a range of 0 to 30")
                                        .padding(5)
                                    Text("Rolled numbers are in a range of 0 to 10")
                                        .padding(5)
                                    Text("click on rolled number to skip/reroll")
                                        .padding(5)
                                    Text("If your current number goes out of range")
                                    Text("the game will be modulo it by 31")
                                }
                                
                            }
                            .padding(100)
                            
                        }
                        
                    }
                }
            })
        }
        
        
    }
}

        
struct gameview: View{
    
    @Environment(\.presentationMode) var presentationMode
    
    @State var list = [[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0]]
    @State var value = 0
    @State var movesPlayed = 0
    @State var currentVal = 0
    @State var range = 0
    @State var Lost = false
    @State var Won = false
    @State var index = [0,0]
    @State var indexList = []
    
    @State var uparrow = false
    @State var downarrow = false
    @State var rightarrow = false
    @State var leftarrow = false
    
    func incrementMoves(){
        if(self.movesPlayed >= 9){
            self.Lost = true
        }
        self.movesPlayed += 1
        gameloop()
    }
    
    func gameloop(){
        let i = index[0]
        let j = index[1]
        if(i == 3 && j == 3){
            self.Won = true
        }
        let val = self.currentVal
        if(i > 0 && list[i-1][j] == val){
            self.uparrow = true
        }else{
            self.uparrow = false
        }
        if(i < 3 && list[i+1][j] == val){
            self.downarrow = true
        }else {
            self.downarrow = false
        }
        if(j > 0 && list[i][j-1] == val){
            self.leftarrow = true
        }else{
            self.leftarrow = false
        }
        if(j < 3 && list[i][j+1] == val){
            self.rightarrow = true
        }else{
            self.rightarrow = false
        }
    }
    @State var homepage = false
    
    var body: some View{
        if(Lost){
            VStack{
                Spacer()
                
                Image("youlose").scaledToFill()
                
                Spacer()

                Button {
                    presentationMode.wrappedValue.dismiss()
                    
                } label: {
                    Text("Retry")
                        .foregroundColor(/*@START_MENU_TOKEN@*/.white/*@END_MENU_TOKEN@*/)
                        .frame(width: 100, height: 40)
                        .background(/*@START_MENU_TOKEN@*//*@PLACEHOLDER=View@*/Color.red/*@END_MENU_TOKEN@*/)
                        .cornerRadius(15.0)
                    
                }
                
                Spacer()
            }
            
            .navigationBarBackButtonHidden(true)
            .background(/*@START_MENU_TOKEN@*//*@PLACEHOLDER=View@*/Color.black/*@END_MENU_TOKEN@*/)
            
            
        }
        else if (Won){
            VStack{
                Spacer()
                
                Image("gamewon").scaledToFill()
                
                Spacer()
                
                Button {
                    presentationMode.wrappedValue.dismiss()
                    
                } label: {
                    Text("Play Again")
                        .foregroundColor(/*@START_MENU_TOKEN@*/.white/*@END_MENU_TOKEN@*/)
                        .frame(width: 100, height: 40)
                        .background(/*@START_MENU_TOKEN@*//*@PLACEHOLDER=View@*/Color.green/*@END_MENU_TOKEN@*/)
                        .cornerRadius(15.0)
                    
                }
                
                Spacer()
            }
            
            .navigationBarBackButtonHidden(true)
            .background(/*@START_MENU_TOKEN@*//*@PLACEHOLDER=View@*/Color.black/*@END_MENU_TOKEN@*/)
        }
        else{
            let n = self.list.count
        VStack{
            Text("Current Value: " + String(currentVal))
                .frame(width: 250, height: 35, alignment: .center)
                .padding()
                .overlay(
                    RoundedRectangle(cornerRadius: 10.0)
                    .stroke(Color.blue,lineWidth: 3)
                    .padding(6)
                )
                .font(.title)
                .foregroundColor(.blue)
            Spacer()
            VStack {
                ForEach(0..<n, id: \.self) { i in
                    HStack{
                        let n = self.list.count
                        ForEach(0..<n,id: \.self){ j in
                            if(i == self.index[0] && j == self.index[1]){
                                CardView(content: list[i][j] ,color: .green).aspectRatio(2/3, contentMode: .fit)
                                    .foregroundColor(.green)
                            }
                            else{
                                CardView(content: list[i][j] ).aspectRatio(2/3, contentMode: .fit)
                            }
                            
                        }
                    }
                }
            }
            .padding()
            
            HStack{
                Spacer()
                Button(action: {
                    self.currentVal = self.currentVal + self.value
                    incrementMoves()
                    self.value = Int.random(in: 0..<10)
                    if(self.currentVal >= 31){
                        self.currentVal = self.currentVal%31
                    }
                    
                }, label: {
                    Text("+")
                        .frame(width: 25, height: 25, alignment: .center)
                        .padding()
                        .overlay(
                            Circle()
                            .stroke(Color.purple, lineWidth: 3)
                            .padding(6)
                            .offset(x: 0, y: 2)
                        )
                        .font(.largeTitle)
                        .foregroundColor(.purple)
                })
                
                Spacer()
                
                Button(action: {
                    self.currentVal = abs(self.currentVal -  self.value)
                    incrementMoves()
                    self.value = Int.random(in: 0..<10)
                    if(self.currentVal >= 31){
                        self.currentVal = self.currentVal%31
                    }
                }, label: {
                    Text("-")
                        .frame(width: 25, height: 25, alignment: .center)
                        .padding()
                        .overlay(
                            Circle()
                            .stroke(Color.purple, lineWidth: 3)
                            .padding(6)
                            .offset(x: 0, y: 2)
                        )
                        .font(.largeTitle)
                        .foregroundColor(.purple)
                })
                
                Spacer()
                
                
                Button(action: {
                    self.currentVal = self.currentVal * self.value
                    incrementMoves()
                    self.value = Int.random(in: 0..<10)
                    if(self.currentVal >= 31){
                        self.currentVal = self.currentVal%31
                    }
                }, label: {
                    Text("x")
                        .frame(width: 25, height: 25, alignment: .center)
                        .padding()
                        .overlay(
                            Circle()
                            .stroke(Color.purple, lineWidth: 3)
                            .padding(6)
                            .offset(x: 0, y: 2)
                        )
                        .font(.largeTitle)
                        .foregroundColor(.purple)
                })
                
                Spacer()
                
                Button(action: {
                    if(self.value != 0){
                        self.currentVal = self.currentVal/self.value
                    }
                    incrementMoves()
                    self.value = Int.random(in: 0..<10)
                    if(self.currentVal >= 31){
                        self.currentVal = self.currentVal%31
                    }
                }, label: {
                    Text("÷")
                        .frame(width: 25, height: 25, alignment: .center)
                        .padding()
                        .overlay(
                            Circle()
                            .stroke(Color.purple, lineWidth: 3)
                            .padding(6)
                            .offset(x: 0, y: 2)
                        )
                        .font(.largeTitle)
                        .foregroundColor(.purple)
                })
                
                Spacer()
                
                Button(action: {
                    var x = 1
                    for _ in 0..<self.value {
                        x*=self.currentVal
                        if(x >= range){
                            x = x%31
                        }
                    }
                    self.currentVal = x
                    incrementMoves()
                    self.value = Int.random(in: 0..<10)
                    
                }, label: {
                    Text("^")
                        .offset(x: 0, y: 5)
                        .frame(width: 25, height: 25, alignment: .center)
                        .padding()
                        .overlay(
                            Circle()
                            .stroke(Color.purple, lineWidth: 3)
                            .padding(6)
                        )
                        .font(.largeTitle)
                        .foregroundColor(.purple)
                })
                
                Spacer()
                
            }
            .foregroundColor(.blue)
                        
            HStack{
                Spacer()
                
                Button(action: {
                    self.value = Int.random(in: 0..<10)
                    incrementMoves()
                }, label: {
                    Text(String(value))
                        .frame(width: 80, height: 25, alignment: .center)
                        .padding()
                        .overlay(
                            RoundedRectangle(cornerRadius: 10.0)
                            .stroke(Color.purple,lineWidth: 3)
                            .padding(6)
                        )
                        .foregroundColor(.purple)
                        
                })

                Spacer()
                
                Text("Moves: " + String(movesPlayed))
                    .frame(width: 80, height: 25, alignment: .center)
                    .padding()
                    .overlay(
                        RoundedRectangle(cornerRadius: 10.0)
                        .stroke(Color.purple,lineWidth: 3)
                        .padding(6)
                    )
                    .foregroundColor(.purple)
                
                Spacer()
                
            }
        }

        .padding()
        
        ZStack{
            RoundedRectangle(cornerRadius: /*@START_MENU_TOKEN@*/25.0/*@END_MENU_TOKEN@*/)
                .stroke(Color.white)
                .frame(width: 400,height: 80)
        
            HStack{
                if(self.downarrow || self.uparrow || self.rightarrow || self.leftarrow){
                    if(self.downarrow){
                        Button {
                            self.index[0] += 1
                            gameloop()
                        } label: {
                            ZStack{
                                Circle()
                                    .stroke(.green,lineWidth: 3.0)
                                    .frame(width: 50,height:50)
                                Image(systemName: "arrowshape.down")
                                    .font(.title)
                            }
                            
                        }
                    }
                    if(self.uparrow){
                        Button {
                            self.index[0] -= 1
                            gameloop()
                        } label: {
                            ZStack{
                                Circle()
                                    .stroke(.green,lineWidth: 3.0)
                                    .frame(width: 50,height:50)
                                Image(systemName: "arrowshape.up")
                                    .font(.title)
                            }
                            
                        }
                    }
                    if(self.leftarrow){
                        Button {
                            self.index[1] -= 1
                            gameloop()
                        } label: {
                            ZStack{
                                Circle()
                                    .stroke(.green,lineWidth: 3.0)
                                    .frame(width: 50,height:50)
                                Image(systemName: "arrowshape.left")
                                    .font(.title)
                            }
                            
                        }
                    }
                    if(self.rightarrow){
                        Button {
                            self.index[1] += 1
                            gameloop()
                        } label: {
                            ZStack{
                                Circle()
                                    .stroke(.green,lineWidth: 3.0)
                                    .frame(width: 50,height:50)
                                Image(systemName: "arrowshape.right")
                                    .font(.title)
                            }
                            
                        }
                    }
                    
                    
                }
            }
        }
    }
    }
}

struct CardView: View {
    var content = 10
    var color : Color = .yellow
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10.0)
                .stroke(color,lineWidth: 4)
            ZStack {
                RoundedRectangle(cornerRadius: 10.0)
                    .fill(.white)
                Text(String(content))
            }
            
        }
    }
}



#Preview {
    ContentView()
}
    

