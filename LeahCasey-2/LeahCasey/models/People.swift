//
//  People.swift
//  Table Screen App
//
//  Created by Malaikah Hafeez on 24/02/2025.
//

import Foundation

class People{
    
    var people : [Person]
    
    init(people: [Person]) {
        self.people = people
    }
    
    init(xmlfile:String){
        // make xml people parser
        let peopleparser = XMLPeopleParsing(fileName: xmlfile)
        peopleparser.parsing()
        
        self.people = peopleparser.peopleData
    }
    
    func count()->Int{return people.count}
    func getPerson(index:Int)->Person{return people[index]}
    
}
