//
//  ContentView.swift
//  ProyectoCaritas
//
//  Created by Luis Portilla on 10/18/23.
//

import SwiftUI

struct ContentView: View {
    @State private var list:Array<Recibo> = []
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            Text("Hello, world!")
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
