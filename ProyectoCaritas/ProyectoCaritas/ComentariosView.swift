//
//  ComentariosView.swift
//  ProyectoCaritas
//
//  Created by J. Lugo on 21/10/23.
//

import SwiftUI

struct opcion: Identifiable {
    let id: Int
    let text: String
}

struct ComentariosView: View {
    var recibo: String
    var token: String
    @Environment(\.dismiss) private var dismiss
    @State private var confirmation = false
    @State private var done = false
    @State private var selectedOpcion: opcion?
    @State private var text: String = ""
    let opciones: [opcion] = [
        opcion(id: 1, text: "No se encontraba en casa"),
        opcion(id: 2, text: "Ya no vive ahi"),
        opcion(id: 3, text: "No desea continuar ayudando"),
        opcion(id: 4, text: "Indispuesto"),
        opcion(id: 5, text: "No se ubicó el domicilio")
    ]

    var body: some View {
        VStack {
            
            HeaderView(titulo: "NO COBRADO")
                .padding(.bottom, 90)
            
            List(opciones) { opcion in
                Button(action: ({
                    self.text = opcion.text
                    self.confirmation = true
                })
                )
                {
                    HStack{
                        
                   Spacer()
                    
                    Text(opcion.text)
                        .font(.system(size: 25))
                        .padding(.vertical, 20)
                        
                    Spacer()
                        
                    }
                }
                .tint(ColorPrincipal)
                .buttonStyle(.borderedProminent)
                .listRowSeparator(.hidden)
                .frame(width: 350)
                .padding(.bottom, 10)
                
            }
            .listStyle(.plain)
            .navigationTitle("Opciones")
            
            Spacer()

          
            .alert("¿Estas seguro de que deseas enviar los comentarios?", isPresented: $confirmation) {
                Button("Si") {
                    sendComments(recibo: recibo, comentarios: text, token: token)
                    done.toggle()
                }
                Button("No") { self.confirmation = false }
            }
            .alert("Comentarios enviados exitosamente", isPresented: $done) {
                Button("Ok") {
                    dismiss()
                }
            }
        }
    }
    
    func confirm() {
        confirmation.toggle()
    }
}

struct ComentariosView_Previews: PreviewProvider {
    static var previews: some View {
        ComentariosView(recibo: "", token: "")
    }
}
