//
//  LoginWindow.swift
//  ProyectoCaritas
//
//  Created by Luis Portilla on 10/18/23.
//

import SwiftUI

struct LoginWindow: View {
    
    let ColorP = Color(red: 0/255, green: 59/255, blue: 92/255)
    let ColorS = Color(red: 0/255, green: 156/255, blue: 166/255)
    @State private var IdUsername: String = ""
    @State private var IdPassword: String = ""
    
    // Offsets for animation
    @State private var caritas40Offset: CGFloat = UIScreen.main.bounds.width
    @State private var usernameOffset: CGFloat = -UIScreen.main.bounds.width
    @State private var passwordOffset: CGFloat = UIScreen.main.bounds.width
    @State private var buttonOffset: CGFloat = UIScreen.main.bounds.height
    
    var body: some View {
        ZStack{
            Rectangle()
                .ignoresSafeArea()
                .foregroundColor(ColorP)
            
            VStack{
            
                
                Image("CaritasLogo")
                    .padding(.top, 80)
                Spacer()
               /*
                Image("Caritas40")
                    .offset(x: caritas40Offset)
                    .onAppear {
                        withAnimation(.spring().delay(0.2)) {
                            caritas40Offset = 0
                        }
                    }
                */
                
                Text("Cáritas Relief")
                    .font(.custom("CaritasFont", size: 40))
                    .foregroundColor(.white)
                    .offset(x: caritas40Offset)
                    .onAppear {
                        withAnimation(.spring().delay(0.2)) {
                            caritas40Offset = 0
                        }
                    }
                
                Spacer()
                
                TextField("Username", text: $IdUsername)
                    .font(.system(size: 20))
                    .textFieldStyle(.roundedBorder)
                    .padding(.horizontal, 60)
                    .offset(x: usernameOffset)
                    .onAppear {
                        withAnimation(.spring().delay(0.4)) {
                            usernameOffset = 0
                        }
                    }
                
                TextField("Password", text: $IdPassword)
                    .font(.system(size: 20))
                    .textFieldStyle(.roundedBorder)
                    .padding(.horizontal, 60)
                    .padding(.bottom, 10)
                    .offset(x: passwordOffset)
                    .onAppear {
                        withAnimation(.spring().delay(0.6)) {
                            passwordOffset = 0
                        }
                    }
                
                Button("Acceder") {}
                    .font(.title2)
                    .controlSize(.large)
                    .buttonStyle(.borderedProminent)
                    .buttonBorderShape(.capsule)
                    .padding(.bottom, 100)
                    .padding(.top, 60)
                    .tint(ColorS)
                    .offset(y: buttonOffset)
                    .onAppear {
                        withAnimation(.spring().delay(0.8)) {
                            buttonOffset = 0
                        }
                    }
                
                Spacer()
            }
        }
    }
}

struct LoginWindow_Previews: PreviewProvider {
    static var previews: some View {
        LoginWindow()
    }
}

