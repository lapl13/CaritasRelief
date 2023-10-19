//
//  DonacionView.swift
//  ProyectoCaritas
//
//  Created by Alumno on 19/10/23.
//

import SwiftUI

struct DonacionView: View {
    var body: some View {
        VStack{
            VStack(alignment: .leading){
                VStack(alignment: .leading){
                    HStack(alignment: .center){
                        //Nombre de donante
                        Text("Juan Pérez")
                            .font(.largeTitle)
                            .bold()
                        Spacer()
                        //Si hay mas de un recibo mostrar cantidad de recibos si solo hay uno mostrar la cantidad de donacion
                        
                        
                        //cantidad de donacion
                        Text("$200")
                            .font(.title)
                            .foregroundColor(Color(red: 0.003, green: 0.208, blue: 0.327))
                        
                        //numero de recibos
                        HStack{
                            Text("2")
                            Image(systemName: "doc.plaintext")
                            
                            
                        }
                        .font(.title)
                        .foregroundColor(Color(red: 0.003, green: 0.208, blue: 0.327))
                        
                        
                    }.padding(.bottom, 8)
                    
                    //direccion
                    Text("Aulas 3, Av. Eugenio Garza Sada Sur, Tecnológico, 64700")
                        .font(.title2)
                }
                .padding(.horizontal, 20)
                //Barra de estado
                //aqui se tiene que cambiar el color de lo0s dos rectangulos para actualizar la barra de estado
                ZStack(alignment: .top){
                    Rectangle()
                        .fill(.red)
                        .frame(width: .infinity, height: 10)
                    RoundedRectangle(cornerRadius: 12)
                        .fill(.red)
                        .frame(width: .infinity, height: 20)
                }
                    
                
            }
            .padding(.top, 20)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(.gray, lineWidth: 1)
            )
            
            .background(.white)
            
            
            
        }
    }
}

struct DonacionView_Previews: PreviewProvider {
    static var previews: some View {
        DonacionView()
    }
}
