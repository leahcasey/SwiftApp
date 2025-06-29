//
//  XMLPeopleParsing.swift
//  People Multi Screen
//
//  Created by Malaikah Hafeez
//

import Foundation

class XMLPeopleParsing:NSObject, XMLParserDelegate{
    
    var fileName:String
    
    init(fileName: String) {self.fileName = fileName}
    
    //MARK: - vars to work parsing
    
    // tmp vars to store person data
    var pName, pPosition, pAge, pNationality, pGoals, pURL, pImage : String!

    
    // spy vars to work in the delegate methods
    var passElement : Int = -1
    var passData : Bool = false
    
    // data objects
    var personData : Person!
    var peopleData = [Person]()
    
    // xml parsing elements
    var parser : XMLParser!
    var tags = ["name", "position","age","nationality","goals","url","image"]
    
    //MARK: - parsing delegate methods
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        // got a start tag that we need to spy if is one of the tags
        if tags.contains(elementName){
            passData = true
            passElement = tags.firstIndex(of: elementName)!
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        // check the spies to decide what to save in p-vars
        if passData{
            switch passElement{
            case 0 : pName = string
            case 1 : pPosition = string
            case 2 : pAge = string
            case 3 : pNationality = string
            case 4 : pGoals = string
            case 5 : pURL = string
            case 6 : pImage = string
            default:
                break
            }
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        // reset the spies to false when elementName is in tags
        if tags.contains(elementName){
            passData = false
            passElement = -1
        }
        
        // check if </person>
        if elementName == "person"{
            // create personData and append it to peopleData
            personData = Person (name: pName, position: pPosition, age: pAge, nationality: pNationality, goals: pGoals, url: pURL, image: pImage, favourite: "nil")
            peopleData.append(personData)
        }
        
    }
    
    func parsing(){
        // get the xml file url
        let bundleURL = Bundle.main.bundleURL
        let fileURL = URL(string: self.fileName, relativeTo: bundleURL)
        
        // make the parser and delegate it
        parser = XMLParser(contentsOf: fileURL!)
        parser.delegate = self
        
        // parse
        parser.parse()
    }
    
    
    
}



