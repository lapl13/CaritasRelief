//
//  DonacionesView.swift
//  ProyectoCaritas
//
//  Created by Alumno on 19/10/23.
//

import SwiftUI
import Foundation

struct DonacionesView: View {
    @State var token:String
    @State var recolector:Int
    @State private var visited = true
    @State var recibos:[recibosActivos]
    
    var body: some View {
       
        
        NavigationStack{
            VStack{
                HeaderView(titulo: "DONACIONES").padding(.bottom,20)
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
                
                List{
                    ForEach(recibos){reciboItem in
                        if(reciboItem.cobrado == 2){
                            NavigationLink{
                                
                                DetalleView(donante: reciboItem.donante,recibo: reciboItem,recolector:recolector,token: token)
                                
                            }label:{
                                DonacionView(donante: reciboItem.donante,recibo: reciboItem)
                                    
                            }
                        }else{
                            DonacionView(donante: reciboItem.donante,recibo: reciboItem)
                                .padding(.trailing, 17)
                            
                        }
                    }.onMove {indexSet, offset in
                        recibos.move(fromOffsets: indexSet, toOffset: offset)
                    
                        for i in 0...recibos.count-1 {
                            print(i)
                            print(reordenarRecibo(idRecibo: Int(recibos[i].id)!, posicion: i, token: token))
                        }
                    }
                
        
                }
                .onAppear(){
                    recibos = getRecibos(token: token, recolector: recolector).recibosActivos
                }
                .listStyle(.plain)
                
            }
        }
        .navigationBarHidden(true)
    }
}

struct DonacionesView_Previews: PreviewProvider {
    static var previews: some View {
        DonacionesView(token: "",recolector: 1, recibos: [])
        
    }
}
