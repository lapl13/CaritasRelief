//
//  ReciboView.swift
//  ProyectoCaritas
//
//  Created by Alumno on 20/10/23.
//

import SwiftUI

struct ReciboView: View {
    var body: some View {
        VStack{
            VStack(alignment: .leading){
                VStack(alignment: .leading){
                    HStack(alignment: .center){
                        
                        Text("#98475")
                            .font(.largeTitle)
                            .bold()
                        Spacer()
                        
                        Text("$200")
                            .font(.title)
                            .foregroundColor(Color(red: 0.003, green: 0.208, blue: 0.327))
                        
                        
                        
                            .font(.title)
                            .foregroundColor(Color(red: 0.003, green: 0.208, blue: 0.327))
                        
                        
                    }.padding(.bottom, 8)
                    
                    
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 20)
                HStack{
                    Spacer()
                    Button(action: confirmar){
                    
                        Image(systemName: "xmark")
                            .font(.title)
                            .padding(.horizontal,50 )
                    }.buttonStyle(.borderedProminent)
                        .tint(.red)
                    Button(action: confirmar){
                        
                        Image(systemName: "checkmark")
                            .padding(.horizontal,50 )
                            .font(.title)

                    }
                    .buttonStyle(.borderedProminent)
                    .tint(ColorPrincipal)
                    
                    
                    
                    
                    Spacer()
    
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
    
    func confirmar(){
        
    }
}

struct ReciboView_Previews: PreviewProvider {
    static var previews: some View {
        ReciboView()
    }
}
