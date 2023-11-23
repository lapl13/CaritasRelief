//
//  DetalleView.swift
//  ProyectoCaritas
//
//  Created by Alumno on 20/10/23.
//

import SwiftUI

struct DetalleView: View {
    var donante:Donante
    var recibo:recibosActivos
    var recolector:Int
    @Environment(\.presentationMode) var presentationMode
    @State var token:String
        var body: some View {
            NavigationStack{
                VStack(alignment: .center){
                    ZStack{
                        HeaderView(titulo: "\(donante.nombres) \(donante.apellidos)").padding(.bottom,50)
                        HStack{
                            Button(action: {
                                                    // Handle the back action
                                                    presentationMode.wrappedValue.dismiss()
                                                }) {
                                                    Image(systemName: "chevron.left")
                                                        .resizable()
                                                        .aspectRatio(contentMode: .fit)
                                                        .frame(width: 20, height: 20)
                                                        .foregroundColor(.white)
                                                }
                                                .padding()
                        }.offset(x:-175,y:-15)
                        
                    }
                    VStack{
                        HStack(alignment: .center){
                            Image(systemName: "mappin.circle.fill")
                                .font(.largeTitle)
                                .foregroundColor(ColorPrincipal)
                            
                            Link("\(donante.direccion)", destination: URL(string: "http://maps.apple.com/?q=\(donante.latitude),\(donante.longitude)")!)
                                    .font(.title)
                                    .padding(.leading, 10)
                                    
                            
                            Spacer()
                        }.padding(.bottom, 15)
                        HStack(alignment: .center){
                            Image(systemName: "iphone.gen3")
                                .font(.largeTitle)
                                .foregroundColor(ColorPrincipal)
                            
                            
                            Link("\(donante.telCelular)", destination: URL(string: "tel:\(donante.telCelular))")!)
                                .font(.title)
                                .padding(.leading, 10)
                            Spacer()
                            
                        }.padding(.bottom, 15)
                        
                        HStack(alignment: .center){
                            Image(systemName: "phone.fill")
                                .font(.largeTitle)
                                .foregroundColor(ColorPrincipal)
                            
                            Link("\(donante.telCasa)", destination: URL(string: "tel:\(donante.telCasa)")!)
                                .font(.title)
                                .padding(.leading, 10)
                            Spacer()
                            
                        }.padding(.bottom, 15)
                        
                        
                        
                        
                    }.padding(.horizontal, 30)
                        .padding(.top, 20)
                    if(recibo.cobrado == 2){
                        ReciboView(recibo: recibo,token: token)
                            .padding(.horizontal, 20)
                    }else{
                        Text("No tiene cobros pendientes")
                            .font(.title)
                    }
                    Spacer()
                }
            }
            .navigationBarHidden(true)
    }
}

struct DetalleView_Previews: PreviewProvider {
    static var previews: some View {
        @State var donante:Donante = Donante(id: "1", nombres: "", apellidos: "", direccion: "", latitude: 0.0, longitude: 0.0, telCelular: "", telCasa: "")
        @State var recibo:recibosActivos = recibosActivos( cantidad: 200.0, id: "1", cobrado: 2, donante: donante)
        DetalleView(donante: donante, recibo: recibo, recolector: 1 ,token: "")
    }
}
