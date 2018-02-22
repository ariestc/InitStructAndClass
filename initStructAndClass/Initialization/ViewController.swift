//
//  ViewController.swift
//  Initialization
//
//  Created by wangliang on 2018/2/22.
//  Copyright © 2018年 wangliang. All rights reserved.
//

import UIKit

/********        Struct       *********/
//https://www.raywenderlich.com/119922/swift-tutorial-initialization-part-1

struct RocketConfiguration {

    let name:String = "Athena 9 Heavy"
    let numberOfFirstStageCores:Int = 3
    let numberOfSecondStageCores:Int = 1
    
    var numberOfStageReuseLandingLegs:Int?
}

struct RocketStageConfiguration {
    
    let propellantMass: Double
    let liquidOxygenMass:Double
    let nominalBurnTime: Int
}

extension RocketStageConfiguration {
    
    init(propellantMass: Double, liquidOxygenMass: Double) {
        self.propellantMass = propellantMass
        self.liquidOxygenMass = liquidOxygenMass
        self.nominalBurnTime = 180
    }
}

struct Weather {
    
    let temperatureCelsius: Double
    let windSpeedKilometersPerHour: Double
    
    init(temperatureCelsius:Double,windSpeedKilometersPerHour: Double) {
        
        self.temperatureCelsius=(temperatureCelsius - 32) / 1.8
        
        self.windSpeedKilometersPerHour=windSpeedKilometersPerHour * 1.609344
    }
}

struct GuidanceSensorStatus {
    
    var currentZAngularVelocityRadiansPerMinute: Double
    let initialZAngularVelocityRadiansPerMinute: Double
    var needsCorrection: Bool
    
    init(zAngularVelocityDegreesPerMinute: Double,needsCorrection: Bool) {
        
        let radiansPerMinute = zAngularVelocityDegreesPerMinute * 0.01745329251994
        self.currentZAngularVelocityRadiansPerMinute=radiansPerMinute
        self.initialZAngularVelocityRadiansPerMinute=radiansPerMinute
        self.needsCorrection=needsCorrection
    }
    
    init(zAngularVelocityDegreesPerMinute: Double,needsCorrection: Int) {
        
        self.init(zAngularVelocityDegreesPerMinute: zAngularVelocityDegreesPerMinute, needsCorrection: (needsCorrection > 0))
    }
    
}


struct CombustionChamberStatus {
    
    var temperatureKelvin: Double
    var pressureKiloPascals: Double
    
    init(temperatureKelvin: Double,pressureKiloPascals:Double) {
        
        print("Phase 1 init")
        self.temperatureKelvin=temperatureKelvin
        self.pressureKiloPascals=pressureKiloPascals
        
        print("CombustionChamberStatus finish init")
        
        print("Phase 2 init")
    }
    
    //Delegating initializer
    init(temperatureCelsius: Double, pressureAtmospheric: Double) {
        
        print("Phase 1  delegate init")
        
        let temperatureKelvin = temperatureCelsius + 273.15
        
        let pressureKiloPascals = pressureAtmospheric * 101.325
        
        self.init(temperatureKelvin: temperatureKelvin, pressureKiloPascals: pressureKiloPascals)
        
        print("Phase 2  delegate init")
    }
}

struct TankStatus {
    
    var  currentVolume: Double
    var currentLiquidType: String?
    
    //failable initializers.
    init?(currentVolume: Double,currentLiquidType: String?) {
        
        if currentVolume < 0 {
            return nil
        }
        
        if currentVolume > 0 && currentLiquidType == nil {
            
            return nil
        }
        self.currentVolume=currentVolume
        self.currentLiquidType=currentLiquidType
    }
}

struct Astronaut {
    
    let name: String
    let age: Int
    
    //throwable initializers
    init(name: String,age: Int) throws {
        
        if name.isEmpty {
            
            throw InvalidAstronautDataError.EmptyName
        }
        
        if age<18 || age>70 {
            throw InvalidAstronautDataError.InvalidAge
        }
        
        self.name=name
        self.age=age
    }
}

enum InvalidAstronautDataError: Error {
    case EmptyName
    case InvalidAge
}

/********        Class        *********/
//https://www.raywenderlich.com/121603/swift-tutorial-initialization-part-2

class  RocketComponent {
    
    let model: String
    let serialNumber: String
    let reusable: Bool
    
    //Designated Initializer
    init(model: String,serialNumber: String,reusable: Bool) {
        
        self.model=model
        self.serialNumber=serialNumber
        self.reusable=reusable
    }
    
    //Convenience Initializers
    convenience init(model: String,serialNumber: String){
        
        self.init(model: model, serialNumber: serialNumber,reusable:false)
    }
    
//    init?(identifier: String,reusable: Bool) {
//
//        let identifierComponents = identifier.components(separatedBy: "-")
//        guard identifierComponents.count == 2 else {
//
//            return nil
//        }
//
//        self.reusable=reusable
//        self.model=identifierComponents[0]
//        self.serialNumber=identifierComponents[1]
//    }
    
    static func decompose(identifier: String) ->
        (model: String, serialNumber: String)? {
            let identifierComponents = identifier.components(separatedBy: "-")
            guard identifierComponents.count == 2 else {
                return nil
            }
            return (model: identifierComponents[0], serialNumber: identifierComponents[1])
    }
    
    convenience init?(identifier: String,reusable: Bool){
        
//        let identifierComponents = identifier.components(separatedBy: "-")
//        guard identifierComponents.count == 2 else {
//
//            return nil
//        }
//
//        self.init(model: identifierComponents[0], serialNumber: identifierComponents[1], reusable: reusable)
        
        guard let (model, serialNumber) = RocketComponent.decompose(identifier: identifier) else {
            return nil
        }
        self.init(model: model, serialNumber: serialNumber, reusable: reusable)
    }
    
}

class Tank: RocketComponent {
    
    //包装材料
//    let encasingMaterial: String = "Aluninum"//铝
    
    var encasingMaterial: String
    
    //SubClass designated initializer
    init(model: String, serialNumber: String, reusable: Bool, encasingMaterial: String) {
        
        //子类只能初始化自己引入的属性
        self.encasingMaterial=encasingMaterial
        
        //将其余的工作委派给超类指定的初始化器
        super.init(model: model, serialNumber: serialNumber, reusable: reusable)
    }
    
    override init(model: String, serialNumber: String, reusable: Bool) {
        
        self.encasingMaterial="Sam"
        
        super.init(model: model, serialNumber: serialNumber, reusable: reusable)
    }
    
}

class LiquidTank: Tank {
    
    let liquidType: String
    
    init(model: String, serialNumber: String, reusable: Bool, encasingMaterial: String ,liquidType: String) {
        
        self.liquidType=liquidType
        
        super.init(model: model, serialNumber: serialNumber, reusable: reusable, encasingMaterial: encasingMaterial)
    }
    
   convenience init(model: String, serialNumberInt: Int, reusable: Bool, encasingMaterial: String ,liquidType: String)
    {
        let stringSerialNumber = String(serialNumberInt)
        
        self.init(model: model, serialNumber: stringSerialNumber, reusable: reusable, encasingMaterial: encasingMaterial, liquidType: liquidType)
        
    }
    
    convenience init(model: String, serialNumberInt: Int, reusable: Int, encasingMaterial: String ,liquidType: String)
    {
        let boolReusable = reusable > 0
        
        self.init(model: model, serialNumberInt: serialNumberInt, reusable: boolReusable, encasingMaterial: encasingMaterial, liquidType: liquidType)
    }
    
//    //RocketComponent use Designated initializer
//    override init(model: String, serialNumber: String, reusable: Bool) {
//
//        self.liquidType = "LOX"
//        //super
//        super.init(model: model, serialNumber: serialNumber,
//                   reusable: reusable, encasingMaterial: "Aluminum")
//    }
//
//    //Tank use Designated initializer
//    override init(model: String, serialNumber: String, reusable: Bool,
//                  encasingMaterial: String) {
//        self.liquidType = "LOX"
 //       //super
//        super.init(model: model, serialNumber: serialNumber, reusable:
//            reusable, encasingMaterial: encasingMaterial)
//    }
    
    //RocketComponent use Convenience initializer
    convenience override init(model: String, serialNumber: String, reusable: Bool) {
        
        //self
        self.init(model: model, serialNumber: serialNumber, reusable: reusable,
                  encasingMaterial: "Aluminum", liquidType: "LOX")
    }
    
    //Tank use Convenience initializer
    convenience override init(model: String, serialNumber: String, reusable: Bool,encasingMaterial: String) {
        
        //self
        self.init(model: model, serialNumber: serialNumber,
                  reusable: reusable, encasingMaterial: "Aluminum")
    }
    
    convenience init?(identifier: String, reusable: Bool, encasingMaterial: String, liquidType: String) {
        
//        let identifierComponents = identifier.components(separatedBy: "-")
//
//        guard identifierComponents.count == 2 else {
//            return nil
//        }
//
//        self.init(model: identifierComponents[0], serialNumber: identifierComponents[1],reusable: reusable, encasingMaterial: encasingMaterial, liquidType: liquidType)
        
        guard let (model, serialNumber) = RocketComponent.decompose(identifier: identifier) else {
            return nil
        }
        self.init(model: model, serialNumber: serialNumber, reusable: reusable,
                  encasingMaterial: encasingMaterial, liquidType: liquidType)
    }
}


class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    
//        let payload = RocketComponent(model: "RT-1", serialNumber: "234", reusable: false)
//
//        print(payload) //Initialization.RocketComponent
//
//        let fairing = RocketComponent(model: "Serpent", serialNumber: "0")
//
//        print(fairing) //Initialization.RocketComponent
        
//        let component = RocketComponent(identifier: "R2-D21", reusable: true)
//
//        let noComponent = RocketComponent(identifier: "", reusable: true)
//
//        print(component)//Optional(Initialization.RocketComponent)
//        print(noComponent)//nil
        
//        let component = RocketComponent(identifier: "R2-D21", reusable: true)
//        print(component)
        
  //       //SubClass has designated initializer So Subclass stops inheriting all initializers, both designated and convenience
//        let fuelTank = Tank(model: "Athena", serialNumber: "003", reusable: true)
//        //a designated initializer in a subclass cannot delegate up to a superclass convenience initializer
//        let liquidOxygenTank = Tank(identifier: "Lox-012", reusable: true)
//
//        print(fuelTank)//Initialization.Tank
//
//        print(liquidOxygenTank)//Optional(Initialization.Tank)
        
//
//        let rp1Tank = LiquidTank(model: "Hermes", serialNumberInt: 5, reusable: 1, encasingMaterial: "Aluminum", liquidType: "LOX")
//
//        print(rp1Tank)//Initialization.LiquidTank
        
//        let tank = Tank(model: "Aries", serialNumber: "007", reusable: true, encasingMaterial: "victory")
//
//        print(tank)//Initialization.Tank
        
        //override
//        let tank01 = Tank(model: "PHP", serialNumber: "003", reusable: true)
//
//        print(tank01)//Initialization.Tank
        
        
//        let liquidTank = LiquidTank(model: "Julice", serialNumber: "005", reusable: false)
//
//        print(liquidTank)//Initialization.LiquidTank
        
//        let liquidTank01 = LiquidTank(model: "Cocoa", serialNumber: "005", reusable: false)
//
//        print(liquidTank01)//Initialization.LiquidTank
        
       // let loxTank = LiquidTank(identifier: "LOX-1", reusable: true)
        
//        let loxTank = LiquidTank(identifier: "LOX-1", reusable: true)
//
//        print(loxTank)//Optional(Initialization.LiquidTank)
        
        
//        let convenienceLiquidTank =
//        LiquidTank(model: "haha", serialNumber: "aa", reusable: false)
//
//        print(convenienceLiquidTank) //Initialization.LiquidTank
        
        
        let athenaFuelTank = LiquidTank(identifier: "Athena-9", reusable: true,
        encasingMaterial: "Aluminum", liquidType: "RP-1")
        
        print(athenaFuelTank)//Optional(Initialization.LiquidTank)
        
    }
    
    func StructureTest() {
        
        let rocketC = RocketConfiguration()
        
        print("rocketC=\(rocketC)");
        
        
        let stageOneConfiguration01=RocketStageConfiguration(propellantMass: 119.1, liquidOxygenMass: 276.0, nominalBurnTime: 180);
        
        let stageOneConfiguration02=RocketStageConfiguration(propellantMass: 119.1, liquidOxygenMass: 276.0);
        
        print("stage=\(stageOneConfiguration01)");
        
        print("stage=\(stageOneConfiguration02)");
        
        let currentWeather =
            Weather(temperatureCelsius: 87, windSpeedKilometersPerHour: 2)
        
        print(currentWeather)
        
        let combustion = CombustionChamberStatus(temperatureCelsius: 32, pressureAtmospheric: 0.96)
        
        print(combustion)
        
        let tankStatus = TankStatus(currentVolume: 0.0, currentLiquidType: nil)
        
        print(tankStatus!)
        
        
        if let tankStatus =
            TankStatus(currentVolume: -10.0, currentLiquidType: nil)
        {
            print("Nice, tank status created.")
        }else
        {
            print("Oh no, an initialization failure occurred.")
        }
        
        let johnny = try?Astronaut(name: "Johnny Cosmoseed", age: 58)
        
        print(johnny!)
        
        let johnny01 = try? Astronaut(name: "Johnny Cosmoseed", age: 17)
        
        print(johnny01)//nil
        
        do {
            
            let johnny=try Astronaut(name: "Aries", age: 17)
            
            print(johnny)
            
        } catch  {
            
            print(error) //InvalidAge
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

