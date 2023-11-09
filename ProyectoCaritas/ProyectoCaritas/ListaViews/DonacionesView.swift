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
    var body: some View {
    
        var recibos:[recibosActivos] = getRecibos(token: token, recolector: recolector).recibosActivos
        
       
        
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
                
                List{
                    ForEach(recibos){reciboItem in
                        NavigationLink{
                            
                            DetalleView(donante: reciboItem.donante,recibo: reciboItem,recolector:recolector,token: token)
                            
                        }label:{
                            DonacionView(donante: reciboItem.donante,recibo: reciboItem)
                        }
                    }.onMove {indexSet, offset in
                        recibos.move(fromOffsets: indexSet, toOffset: offset)
                        if let data = try? PropertyListEncoder().encode(recibos) {
                                UserDefaults.standard.set(data, forKey: "recibos")
                            }
                       
                    }
                
        
                }
                .listStyle(.plain)
                .onAppear(){
                    let defaults = UserDefaults.standard
                    if let data = defaults.data(forKey: "recibos") {
                        let array = try! PropertyListDecoder().decode([recibosActivos].self, from: data)
                        recibos = array
                        }
                    
                }
                
                
                
            }
        }
    }
}

struct DonacionesView_Previews: PreviewProvider {
    static var previews: some View {
        DonacionesView(token: "",recolector: 1)
        
    }
}
