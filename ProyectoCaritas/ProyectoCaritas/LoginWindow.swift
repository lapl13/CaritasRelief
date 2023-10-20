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
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

struct LoginWindow_Previews: PreviewProvider {
    static var previews: some View {
        LoginWindow()
    }
}
