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
var Recibos:[Recibo] = []
var Donantes:[donantesHoy] = []

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
    let recibos: [Recibo]
}


struct ReceiptDataClass:Codable{
    let recibos:[Recibo]
}

struct Recibo:Codable, Identifiable{
    let id: String
    let idDonante, cantidad: Int
    let cobrado: Bool
    let fecha: String
    let comentarioHorario: String
    let activo: Bool
    let donante: Persona
}

struct Persona:Codable{
    let nombres:String
    let apellidos:String
    let direccion:String
}

//API Calls
func login(username: String, password: String) -> User? {
    var user: User?
    
    let body = """
    {
        "username": "\(username)",
        "password": "\(password)"
    }
    """
    
    guard let url = URL(string: "http://10.14.255.88:8804/auth/login") else {
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


func getRecibos(token:String) -> [Recibo] {
    let graphQLQuery = """
        {
          recibos(where: { recolector: { id: { eq: 2 } } }) {
            id
            idDonante
            cantidad
            cobrado
            fecha
            comentarioHorario
            activo
            recolector {
              nombres
              apellidos
            }
            donante {
              nombres
              apellidos
              direccion
            }
          }
        }
        """
    guard let url = URL(string: "http://10.14.255.88:8084/graphql") else {
        return []
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
        return []
    }

    var lista: [Recibo] = []

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
                lista = response.data.recibos
            } catch {
                print("Error decoding GraphQL response: \(error)")
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
struct DonanteResponse:Codable{
    let data:DonanteDataResponse
}

struct DonanteDataResponse:Codable{
    let donantesHoy:[donantesHoy]
}

struct donantesHoy:Codable, Identifiable{
    let id:String
    let nombres:String
    let apellidos:String
    let direccion:String
    let telCelular:String
    let telCasa:String
}

//API Calls
func getDonantes() -> [donantesHoy]{
    let query = """
    {
      donantesHoy(date: "2023-10-22", idRecolector: 1){
        id,
        nombres,
        apellidos,
        direccion,
        telCelular,
        telCasa
      }
    }
    """
    

    guard let url = URL(string: "http://10.14.255.88:8084/graphql") else{
        return []
    }
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    request.setValue("Bearer eyJhbGciOiJodHRwOi8vd3d3LnczLm9yZy8yMDAxLzA0L3htbGRzaWctbW9yZSNobWFjLXNoYTI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiJKR29tZXoxMTAiLCJpYXQiOiIxMC8yMC8yMDIzIDU6Mjk6MzFQTSIsImp0aSI6IjJlNzA4OTE0LTk5OTgtNDkyMC04NTRjLTIyNTJhZTc3MGZkMiIsInJvbGUiOiJ1c2VyIiwiZXhwIjoxNjk3OTA5MzcxfQ._uhlYWpPV7xz9vUkqfMrH4Iz3oHTPcNSRGmHnPTWBVg", forHTTPHeaderField: "Authorization")
    let requestBody = ["query": query]
    do {
        let jsonData = try JSONSerialization.data(withJSONObject: requestBody)
        request.httpBody = jsonData
    } catch {
        print("Error creating request body: \(error)")
        return []
    }
    
    var lista:[donantesHoy] = []
    
    let semaphore = DispatchSemaphore(value: 0)
    
    let task = URLSession.shared.dataTask(with: request){
        data,response,error in
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
                let response = try jsonDecoder.decode(DonanteResponse.self, from: data)
                lista = response.data.donantesHoy
            } catch {
                print("Error decoding GraphQL response: \(error)")
            }
        }
    }
    task.resume()
    
    semaphore.wait()
    return lista
    
    
}
