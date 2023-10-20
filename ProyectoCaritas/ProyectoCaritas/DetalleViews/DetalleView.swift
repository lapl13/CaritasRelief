//
//  DetalleView.swift
//  ProyectoCaritas
//
//  Created by Alumno on 20/10/23.
//

import SwiftUI

struct DetalleView: View {
    var donante:donantesHoy
    @State private var listaRecibos = getRecibos(token:"eyJhbGciOiJodHRwOi8vd3d3LnczLm9yZy8yMDAxLzA0L3htbGRzaWctbW9yZSNobWFjLXNoYTI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiJKR29tZXoxMTAiLCJpYXQiOiIxMC8yMC8yMDIzIDU6Mjk6MzFQTSIsImp0aSI6IjJlNzA4OTE0LTk5OTgtNDkyMC04NTRjLTIyNTJhZTc3MGZkMiIsInJvbGUiOiJ1c2VyIiwiZXhwIjoxNjk3OTA5MzcxfQ._uhlYWpPV7xz9vUkqfMrH4Iz3oHTPcNSRGmHnPTWBVg")
    var body: some View {
        VStack(alignment: .center){
            HeaderView(titulo: "\(donante.nombres) \(donante.apellidos)")
            VStack{
                HStack(alignment: .center){
                    Image(systemName: "mappin.circle.fill")
                        .font(.largeTitle)
                        .foregroundColor(ColorPrincipal)
                        
                    Text(donante.direccion)
                        .font(.title)
                        .padding(.leading, 10)
                    Spacer()
                }.padding(.bottom, 15)
                HStack(alignment: .center){
                    Image(systemName: "iphone.gen3")
                        .font(.largeTitle)
                        .foregroundColor(ColorPrincipal)
                        
                    
                    Text(donante.telCelular)
                        .font(.title)
                        .padding(.leading, 10)
                    Spacer()
                    
                }.padding(.bottom, 15)
                
                HStack(alignment: .center){
                    Image(systemName: "phone.fill")
                        .font(.largeTitle)
                        .foregroundColor(ColorPrincipal)
                    
                    Text(donante.telCasa)
                        .font(.title)
                        .padding(.leading, 10)
                    Spacer()
                    
                }.padding(.bottom, 15)
                
                
                
            }.padding(.horizontal, 30)
            List(){
                ReciboView()
                    .listRowSeparator(.hidden)
                ReciboView()
                    .listRowSeparator(.hidden)
                ReciboView()
                    .listRowSeparator(.hidden)
            }
            .listStyle(.plain)
            
        }
    }
}

struct DetalleView_Previews: PreviewProvider {
    static var previews: some View {
        @State var donante:donantesHoy = donantesHoy(id: "", nombres: "", apellidos: "", direccion: "", telCelular: "", telCasa: "")
        DetalleView(donante: donante)
    }
}
