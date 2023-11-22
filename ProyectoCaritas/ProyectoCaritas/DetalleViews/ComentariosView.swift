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
    @Environment(\.presentationMode) var presentationMode
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
        NavigationStack{
            VStack {
                ZStack{
                    HeaderView(titulo: "NO COBRADO")
                        .padding(.bottom, 90)
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
                    }.offset(x:-175,y:-27.5)
                }
                
                
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
                            presentationMode.wrappedValue.dismiss()
                        }
                    }
            }
        }.navigationBarHidden(true)
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
