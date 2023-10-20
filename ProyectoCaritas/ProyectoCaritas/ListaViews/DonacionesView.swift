//
//  DonacionesView.swift
//  ProyectoCaritas
//
//  Created by Alumno on 19/10/23.
//

import SwiftUI

struct DonacionesView: View {
    @State private var visited = true
    @State private var listaRecibos = getRecibos(token :"eyJhbGciOiJodHRwOi8vd3d3LnczLm9yZy8yMDAxLzA0L3htbGRzaWctbW9yZSNobWFjLXNoYTI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiJKR29tZXoxMTAiLCJpYXQiOiIxMC8yMC8yMDIzIDU6Mjk6MzFQTSIsImp0aSI6IjJlNzA4OTE0LTk5OTgtNDkyMC04NTRjLTIyNTJhZTc3MGZkMiIsInJvbGUiOiJ1c2VyIiwiZXhwIjoxNjk3OTA5MzcxfQ._uhlYWpPV7xz9vUkqfMrH4Iz3oHTPcNSRGmHnPTWBVg")
    var body: some View {
        NavigationStack{
            VStack{
                HeaderView(titulo: "DONACIONES")
                Picker("Visita", selection: $visited) {
                    Text("Visitado")
                        .tag(true)
                    
                    Text("No visitado").tag(false)
                }
                .pickerStyle(.segmented)
                .padding(.horizontal, 20)
                .padding(.bottom, 10)
                
                
                
                List(listaRecibos){reciboItem in
                    NavigationLink{
                        
                        Text("HOLA")
                        
                    }label:{
                        DonacionView(recibo: reciboItem)
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
