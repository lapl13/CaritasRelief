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
    
        @State var recibos:[recibosActivos] = getRecibosActivos(token: token, recolector: recolector)
        

        
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
                
                List(){
                
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
                    }
                    .onMove {indexSet, offset in
                        recibos.move(fromOffsets: indexSet, toOffset: offset)
                        
                        var list:[Int] = [1, 2, 3, 4]
                        
                        list.move(fromOffsets: indexSet, toOffset: offset)
                        print(indexSet.first!)
                        print(offset)
//                        var temp:recibosActivos
                        print(recibos[indexSet.first!])
                        print(recibos[offset])
                        recibos.swapAt(indexSet.first!, offset)
                        
                        /*
                        temp = recibos[indexSet.first!]
                        recibos[indexSet.first!] = recibos[offset]
                        recibos[offset] = temp
                        */
                        print("----------------------")
                        print(recibos[indexSet.first!])
                        print(recibos[offset])
                        print(list)
                        
                        if let data = try? PropertyListEncoder().encode(recibos) {
                               
                                UserDefaults.standard.set(data, forKey: "recibos")
                                print("Si se pudo recibir")
                            }
                       
                    }
                }
                .listStyle(.plain)
                .onAppear(){
                    
                    recibos = getRecibosActivos(token: token, recolector: recolector)
                    print("Se cargan los recibos!!!!")
                    
                    
                    
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
