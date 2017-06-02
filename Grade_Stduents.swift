import Foundation


class Main {
	
	 func start(){
		var outputString: String = "성적결과표\n\n"
		var studentArray: Array<Student> = Array() 
	
		
		let jsondata = jsonToCode()
		
		convertStudentObject(jsondata: jsondata, studentList: &studentArray)
		let totalavg = totalAvg(jsondata: studentArray)
		outputString += "전체 평균 : \(totalavg)\n\n개인별 학점\n"	
		outputString += personalGrade(jsondata: studentArray)	
		outputString += "\n수료생\n"	
		outputString += passedList(jsondata: studentArray)
		print(outputString)
        print("\n\n======================== Finish =========================\n\n")
		outputStringWritetoFile(str: outputString)		
	}
	
	 func outputStringWritetoFile(str: String){
		let homeDirectory = NSHomeDirectory()
		let fileName = "result.txt"
		let path = URL(fileURLWithPath: "\(homeDirectory)/\(fileName)")
		do{
			try str.write(to: path, atomically: true, encoding: String.Encoding.utf8)
		}catch let error as NSError{
			print("Failed to write To URL")
			print(error)
		} 
	
	}


	// students.json bring to .swift
	  func jsonToCode() -> Array<[String: AnyObject]>? {
		let homeDirectory = NSHomeDirectory()
		 
		let file =  "\(homeDirectory)/students.json"

		let path = URL(fileURLWithPath: file)
		do{
			let data = try Data(contentsOf: path)
			if let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? Array<[String: AnyObject]> {
			return json }
		}catch {
		print(error)
		}
     	return nil
	}      //end of func jsonToCode()

	

	//students.json -> Student Class object , type dict
        func convertStudentObject(jsondata: Array<[String: AnyObject]>? , studentList: inout Array<Student>){
										// inout -> for call by reference
		guard let jsondata2 = jsondata else {
			print("json is empty")
			return
		} //quick quit, chaining
	
	for list in jsondata2 {
		let name = list["name"] as? String
		let grade = list["grade"] as? [String:AnyObject] 


		let database = grade? ["database"] as? Int
		let algorithm = grade? ["algorithm"] as? Int
		let operating_system = grade? ["operating_system"] as? Int
		let networking = grade? ["networking"] as? Int
		let data_structure = grade? ["data_structure"] as? Int


		//initailiaze 
		let studentObj = Student(name: name, database: database, algorithm: algorithm, operating_system: operating_system, networking: networking, data_structure: data_structure)

		//studentArray use inout for append
		studentList.append(studentObj)  
		}
	} //end of func convertStudentObject
	
	

	 func roundCheck(number: Double, size: Int) -> Double {
		let div = pow(10.0, Double(size))
		return round( number * div ) / div

	} // end of roundCheck ex) 49.4444  ->    49.44



	 func totalAvg(jsondata: Array<Student>) -> Double {
		let stArray = jsondata
		var avg: Double = 0.0

		for i in stArray {
			avg += i.average!
		}
		
		
		avg /= Double(stArray.count)	
		avg = roundCheck(number: avg, size: 2)
		return avg
		
	} //end of totalAvg 

	 func personalGrade(jsondata: Array<Student>) -> String {
		
		//namesort
		let nameArray = jsondata.sorted{
			$0.name! < $1.name!
		}
	
		var str: String = ""


		for student in nameArray {

			switch student.name!.characters.count {
				case 4:
					str += "\(student.name!)       : \(student.getGrade(average: student.average!))\n"
				case 5:
					str += "\(student.name!)      : \(student.getGrade(average: student.average!))\n"

				default:
					print("name count is not 4,5")
			}
		}
	   return str

	} //end of personalGrade	

	 func passedList(jsondata: Array<Student>) -> String {
	
		var str: String = ""
		let stArray = jsondata
		var passedStudentArray: Array<Student> = Array()
		for k in stArray {
			if k.getPassed(average: k.average!){
				passedStudentArray.append(k)}
		}
		
		let passedStudentArraySorted = passedStudentArray.sorted{
			$0.name! < $1.name!
		}
		
		for passedstd in passedStudentArraySorted {
		
		str += "\(passedstd.name!), "
		}
	
		str = String(str.characters.dropLast(2)) //last char ',' + ' '  delete
		return str

	}


	



} //end of Main class

class Student {


	var name: String?
	var data_structure: Int?
	var algorithm: Int?
	var networking: Int?
	var database: Int?
	var operating_system: Int?

	var average: Double?
	var grade: String?


	var count: Int = 0 
	var totalGrade: Int = 0 

	init(name: String?, database: Int?, algorithm: Int?, operating_system: Int?, networking: Int?, data_structure: Int? ) {
		self.name = name
		self.database = database 
        	self.database = database
        	self.algorithm = algorithm
        	self.operating_system = operating_system
        	self.networking = networking
        	self.data_structure = data_structure
        
        if let num:Int = database{
            totalGrade += num
            count += 1
        } else {
            //print("\(self.name!) = Not taken database")
        }
        
        if let num = algorithm{
            totalGrade += num
            count += 1
        } else {
            //print("\(self.name!) = Not taken algorithm")
        }
        if let num = operating_system{
            totalGrade += num
            count += 1
        } else {
            //print("\(self.name!) = Not taken operating_system")
        }
        if let num = networking{
            totalGrade += num
            count += 1
        } else {
           // print("\(self.name!) = Not taken networking")
        }
        if let num = data_structure{
            totalGrade += num
            count += 1
        } else {
            //print("\(self.name!) = Not taken data_structure")
        }
    
        average = Double(totalGrade) / Double(count)     // setGrade(average:Double)
    }  //end of init

	func getGrade(average: Double) -> String {
		switch average {
			case 90.0 ... 100.0 :
				return "A"
			case 80.0 ... 90.0 : 
				return "B"
			case 70.0 ... 80.0 :
				return "C"
			case 60.0 ... 70.0 :
				return "D"
			default:
				return "F"
		}
	} //end of func_getGrade

	func getPassed(average: Double) -> Bool {
		if average >= 70.0 {
			return true
		}
		else {
			return false
		}
	} //end of Passed
} //end of class_student


//== print __ result

let result: Main = Main()
result.start()













