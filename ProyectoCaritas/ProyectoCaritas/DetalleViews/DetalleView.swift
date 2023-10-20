//
//  DetalleView.swift
//  ProyectoCaritas
//
//  Created by Alumno on 20/10/23.
//

import SwiftUI

struct DetalleView: View {
    var body: some View {
        VStack(alignment: .center){
            HeaderView(titulo: "Juan Perez")
            VStack{
                HStack(alignment: .center){
                    Image(systemName: "mappin.circle.fill")
                        .font(.largeTitle)
                        .foregroundColor(ColorPrincipal)
                        
                    Text("Aulas 3, Av. Eugenio Garza Sada Sur, Tecnológico, 64700")
                        .font(.title)
                        .padding(.leading, 10)
                    Spacer()
                }.padding(.bottom, 15)
                HStack(alignment: .center){
                    Image(systemName: "iphone.gen3")
                        .font(.largeTitle)
                        .foregroundColor(ColorPrincipal)
                        
                    
                    Text("818 999 9999")
                        .font(.title)
                        .padding(.leading, 10)
                    Spacer()
                    
                }.padding(.bottom, 15)
                
                HStack(alignment: .center){
                    Image(systemName: "phone.fill")
                        .font(.largeTitle)
                        .foregroundColor(ColorPrincipal)
                    
                    Text("818 345 9824")
                        .font(.title)
                        .padding(.leading, 10)
                    Spacer()
                    
                }.padding(.bottom, 15)
                
                
                
            }.padding(.horizontal, 40)
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
        DetalleView()
    }
}
