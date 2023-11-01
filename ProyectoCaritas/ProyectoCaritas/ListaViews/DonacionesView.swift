//
//  DonacionesView.swift
//  ProyectoCaritas
//
//  Created by Alumno on 19/10/23.
//

import SwiftUI

struct DonacionesView: View {
    @State private var visited = true
    @State private var listaDonantes = getDonantes()
    var body: some View {
        NavigationStack{
            VStack{
                HeaderView(titulo: "DONACIONES")
                /*
                Picker("Visita", selection: $visited) {
                    Text("Visitado")
                        .tag(true)
                    
                    Text("No visitado").tag(false)
                }
                .pickerStyle(.segmented)
                .padding(.horizontal, 20)
                .padding(.bottom, 10)
                
                */
                
                List(listaDonantes){donanteItem in
                    NavigationLink{
                        
                        DetalleView(donante: donanteItem)
                        
                    }label:{
                        DonacionView(donante: donanteItem)
                    }
        
                }
                .listStyle(.plain)
                
                
                
            }
        }
    }
}

struct DonacionesView_Previews: PreviewProvider {
    static var previews: some View {
        DonacionesView()
    }
}
