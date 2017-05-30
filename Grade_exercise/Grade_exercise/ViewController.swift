//
//  ViewController.swift
//  Grade_exercise
//
//  Created by User on 2017. 5. 29..
//  Copyright © 2017년 Ji-Yong Jeong. All rights reserved.
//

import UIKit
import Foundation


class ViewController: UIViewController {
    
    override func viewDidLoad() {
    
        super.viewDidLoad()
        var resultString: String = "성적결과표\n"
       //var avg: Double = 0.0
        var studentArray: Array<Student> = Array()
        let jsondata = jsonTocode()
        //jsondata is students.json
        //print(jsondata)
        convertStudentObject(jsonData:jsondata, studentList: &studentArray)
        // student list check
        //print(studentArray.count)
        let totalavg = totalAvg(jsondata: studentArray)
        resultString += "\n전체평균 : \(totalavg)\n\n"
        resultString += "개인별 학점\n"
        
        resultString += studentGrade(jsondata: studentArray)
        resultString += "\n\n수료생\n"
        
    
    
        
        
        resultString += passedList(jsondata: studentArray)
        print(resultString)
    }
    
    func jsonTocode() -> Array<[String: AnyObject]>? {
        let path = Bundle.main.path(forResource: "students", ofType: "json")
        let url = URL(fileURLWithPath: path!)
        //print(url)
        do {
            let data = try Data(contentsOf: url)
            if let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? Array<[String: AnyObject]> {
                //print(json)
                return json }
        }catch{
            print(error)
        }
        return nil
    }


    
    // studnets.json --> Student Class Object
    
     func convertStudentObject(jsonData: Array<[String: AnyObject]>? , studentList: inout Array<Student>){
        guard let jsonData2 = jsonData else {
            print(" json is empty" )
            return
        }
        for list in jsonData2 {
            let name = list["name"] as? String //name
            let grade = list["grade"] as? [String: AnyObject] //grade dict
            
            let database = grade?["database"] as? Int
            let algorithm = grade?["algorithm"] as? Int
            let operating_system = grade?["operating_system"] as? Int
            let networking = grade?["networking"] as? Int
            let data_structure = grade?["data_structure"] as? Int
            
            
            //StudentCLass Initailize
            let studentObj = Student(name: name, database: database, algorithm: algorithm, operating_system: operating_system, networking: networking, data_structure: data_structure)
            
            
            // studentarray use inout for append
            studentList.append(studentObj)
        }
    }
    
    // 전체평균
    func totalAvg(jsondata: Array<Student>) -> Double {
        
        var stArray = jsondata
        var avg: Double = 0.0
        for i in stArray {
             avg = avg + i.average!
        }
        avg = avg / Double(jsondata.count)
        avg = Roundcheck.RoundCheck(number: avg, places: 2)
        
        print(avg)
        
        return avg
    }
    
    func studentGrade(jsondata: Array<Student>) -> String {
        //StudentNameSort
        var stArray = jsondata.sorted{
            $0.name! < $1.name!
        }
        
        var str: String = ""
        //Personal Grade print
        for j in stArray {
            
            switch j.name!.characters.count {
            case 4 :
                str += "\(j.name!)       : \(j.getGrade(average: j.average!))\n"
            case 5 :
                str += "\(j.name!)      : \(j.getGrade(average: j.average!))\n"
            default :
                str += str
            }
        }
        //print(str) //checking
     return str
    }
    
    func passedList(jsondata: Array<Student>) -> String {
        var str: String = ""
        var stArray = jsondata
        var strArray: Array<Student> = Array()
        for k in stArray {
            if k.getPass(average: k.average!) {
               strArray.append(k)
            }
        }
        var passedlistSort = strArray.sorted{
            $0.name! < $1.name!
        }
        for s in passedlistSort {
            
            str += "\(s.name!), "
        }
        str = String(str.characters.dropLast(2))
        return str
    }
 
    
}





class Roundcheck{
    class func RoundCheck(number:Double,places:Int) -> Double{
        let divisor = pow(10.0, Double(places))
        return round(number * divisor) / divisor
    }
}

struct Student{
    var name:String?
    
    var data_structure:Int?
    var algorithm:Int?
    var networking:Int?
    var database:Int?
    var operating_system:Int?
    
    
    var average:Double?
    var grade:String?
    
    var count: Int = 0    //subject count
    var totalGrade: Int = 0  // sum of grades
    
    
    init(name:String?,database:Int?,algorithm:Int?,operating_system:Int?,networking:Int?,data_structure:Int?) {
     
        self.name = name
        self.database = database
        self.algorithm = algorithm
        self.operating_system = operating_system
        self.networking = networking
        self.data_structure = data_structure
        
        if let n:Int = database{
            totalGrade += n
            count += 1
        } else {
            print("\(self.name!) = Not taken database")
        }
        
        if let n = algorithm{
            totalGrade += n
            count += 1
        } else {
            print("\(self.name!) = Not taken algorithm")
        }
        if let n = operating_system{
            totalGrade += n
            count += 1
        } else {
            print("\(self.name!) = Not taken operating_system")
        }
        if let n = networking{
            totalGrade += n
            count += 1
        } else {
            print("\(self.name!) = Not taken networking")
        }
        if let n = data_structure{
            totalGrade += n
            count += 1
        } else {
            print("\(self.name!) = Not taken data_structure")
        }
    
        average = Double(totalGrade) / Double(count)
        //etGrade(average: Double)
    }
         func getPass(average: Double) -> Bool {
            if average >= 70.0 {
                return true
            }
            else{
                return false
            }
        
        }
        func getGrade(average: Double) -> String {
            switch average{
            case 90.0 ... 100.0:
                return "A"
            case 80.0 ... 90.0 :
               return "B"
            case 70.0 ... 80.0 :
                return "C"
            case 60.0 ... 70.0 :
              return  "D"
            default:
              return "F"
            
            }
        }
    
}
/*

        writeFileFromString(fileName: "result.txt", directory: homeDirectory, data: resultString)
    }
    
    static func writeFileFromString(fileName:String,directory:String,data:String){
        let path = URL(fileURLWithPath: directory, isDirectory: true).appendingPathComponent(fileName)
        do{
            try data.write(to: path, atomically: false, encoding: String.Encoding.utf8)
        }catch{
            print("write error")
        }
        print("완료")
    }

*/
