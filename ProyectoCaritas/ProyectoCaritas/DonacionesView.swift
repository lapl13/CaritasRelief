//
//  DonacionesView.swift
//  ProyectoCaritas
//
//  Created by Alumno on 19/10/23.
//

import SwiftUI

struct DonacionesView: View {
    @State private var visited = true
    var body: some View {
        VStack{
            HeaderView()
            Picker("Visita", selection: $visited) {
                    Text("Visitado")
                        .tag(true)
                        
                    Text("No visitado").tag(false)
            }
            .pickerStyle(.segmented)
            .padding(.horizontal, 20)
            .padding(.bottom, 10)
            
            List{
                DonacionView()
                    .listRowSeparator(.hidden)
                DonacionView()
                    .listRowSeparator(.hidden)
                DonacionView()
                    .listRowSeparator(.hidden)
                DonacionView()
                    .listRowSeparator(.hidden)
            }
            .listStyle(.plain)
            
            
            
        }
        
    }
}

struct DonacionesView_Previews: PreviewProvider {
    static var previews: some View {
        DonacionesView()
    }
}
