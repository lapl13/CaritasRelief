//
//  ModelData.swift
//  ProyectoCaritas
//
//  Created by J. Lugo on 18/10/23.
//

import Foundation
import SwiftUI

//Global vars

var ColorPrincipal = Color(red:0,green: 156/255,blue: 166/255)
var ColorSecundario = Color(red:0,green: 59/255,blue: 92/255)
var Usuario:User = User(token: "", role: 0, user: [0])
var Recibos:[recibosActivos] = []

//Structures
struct User:Codable{
    let token: String
    let role: Int
    let user: [Int]
}

struct Response: Codable {
    let data: DataResponse
}

struct DataResponse: Codable {
    let recolector: Recolector
}

struct Recolector: Codable, Identifiable {
    let id: String
    let recibosActivos: [recibosActivos]
}

struct recibosActivos:Codable, Identifiable{
    let cantidad:Double
    let id:String
    let donante:Donante
}

struct Donante:Codable, Identifiable{
    let id:String
    let nombres:String
    let apellidos:String
    let direccion:String
    let telCelular:String
    let telCasa:String
}

struct Persona:Codable{
    let nombres:String
    let apellidos:String
    let direccion:String
}

//API Calls
func login(username: String, password: String) -> User? {
    var user: User?
    print(Usuario.token)
    let body = """
    {
        "username": "\(username)",
        "password": "\(password)"
    }
    """
    
    guard let url = URL(string: "http://10.14.255.88:8804/auth/login/user") else {
        return nil
    }
    
    var request = URLRequest(url: url)
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    request.httpMethod = "POST"
    request.httpBody = body.data(using: .utf8)
    
    let semaphore = DispatchSemaphore(value: 0)
    
    let task = URLSession.shared.dataTask(with: request) { data, response, error in
        defer { semaphore.signal() }
        let jsonDecoder = JSONDecoder()
        if let data = data {
            do {
                user = try jsonDecoder.decode(User.self, from: data)
            } catch {
                print(error)
            }
        }
    }
    
    task.resume()
    semaphore.wait()
    
    return user
}


func getRecibos(token:String, recolector:Int) -> Recolector {
    let graphQLQuery = """
        {
            recolector(id:\(recolector)){
                id
                recibosActivos(date: "2023-12-01"){
                    id,
                    cantidad,
                    donante{
                        id,
                        nombres,
                        apellidos,
                        direccion,
                        telCelular,
                        telCasa
                    }
                }
            }
        }
    """
    guard let url = URL(string: "http://10.14.255.88:8084/graphql") else {
        return Recolector(id: "", recibosActivos: [])
    }

    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    
    // Replace "YOUR_AUTH_TOKEN_HERE" with your actual authorization token
    request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

    let requestBody = ["query": graphQLQuery]
    do {
        let jsonData = try JSONSerialization.data(withJSONObject: requestBody)
        request.httpBody = jsonData
    } catch {
        print("Error creating request body: \(error)")
        return Recolector(id: "", recibosActivos: [])
    }

    var lista: Recolector = Recolector(id: "", recibosActivos: [])

    let semaphore = DispatchSemaphore(value: 0)

    let task = URLSession.shared.dataTask(with: request) { data, response, error in
        defer {
            semaphore.signal()
        }

        if let error = error {
            print("Error: \(error)")
            return
        }

        if let data = data {
            let jsonDecoder = JSONDecoder()
            do {
                let response = try jsonDecoder.decode(Response.self, from: data)
                lista = response.data.recolector
                if let data = try? PropertyListEncoder().encode(lista.recibosActivos) {
                        UserDefaults.standard.set(data, forKey: "recibos")
                    }
            } catch {
                print("Error decoding GraphQL response: \(error)")
                print(String(data: data, encoding: .utf8))
                
            }
        }
    }
    task.resume()

    semaphore.wait()
    return lista
}
/*

// Usage:
let recibos = getRecibos()
for recibo in recibos {
    print("Recibo ID: \(recibo.id)")
    // Add additional processing as needed
}
*/

//Some other structs

func cobrarRecibo(recibo:String, token:String)->Bool{
    let query = """
    {
        cobrarRecibo(id: \(recibo))
    }
    """
    
    guard let url = URL(string: "http://10.14.255.88:8084/graphql") else{
        return false
    }
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
    let requestBody = ["query": query]
    do {
        let jsonData = try JSONSerialization.data(withJSONObject: requestBody)
        request.httpBody = jsonData
    } catch {
        print("Error creating request body: \(error)")

        return false
    }
    
    var responseval:Bool = false
    
    let task = URLSession.shared.dataTask(with: request){
        data,response,error in
        let jsonDecoder = JSONDecoder()
        if (data != nil){
            responseval = true
        }else{
            responseval = false
        }
    }
    
    task.resume()
    return responseval
    
}

struct postponeResponse:Codable{
    let data:postponer
}

struct postponer:Codable{
    let postponerRecibo:Bool
}

func sendComments(recibo:String,comentarios:String,token:String){
    let query = """
    {
        postponerRecibo(id: \(recibo), comentario: "\(comentarios)")
    }
    """
    guard let url = URL(string: "http://10.14.255.88:8084/graphql") else{
        return
    }
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
    let requestBody = ["query": query]
    do {
        let jsonData = try JSONSerialization.data(withJSONObject: requestBody)
        request.httpBody = jsonData
    } catch {
        print("Error creating request body: \(error)")

        return
    }
    
    let task = URLSession.shared.dataTask(with: request){
        data,response,error in
        let jsonDecoder = JSONDecoder()
        if (data != nil){
            print(String(data: data!, encoding: .utf8))
            print(recibo)
            print(comentarios)
        }else{
            
            return
        }
    }
    task.resume()
}
