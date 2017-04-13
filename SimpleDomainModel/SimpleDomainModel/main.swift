//
//  main.swift
//  SimpleDomainModel
//
//  Created by Ted Neward on 4/6/16.
//  Copyright © 2016 Ted Neward. All rights reserved.
//

import Foundation

print("Hello, World!")

public func testMe() -> String {
  return "I have been tested"
}

open class TestMe {
  open func Please() -> String {
    return "I have been tested"
  }
}


////////////////////////////////////
// Mathematics Protocol!
//
protocol Mathematics {
  static func +(l: Self, r: Self) -> Self
  static func -(l: Self, r: Self) -> Self
}

extension Double {
  var USD : Money {
    return Money(amount: Int(self), currency: "USD")
  }
  
  var GBP : Money {
    return Money(amount: Int(self), currency: "GBP")
  }
  
  var CAN : Money {
    return Money(amount: Int(self), currency: "CAN")
  }
  
  var EUR : Money {
    return Money(amount: Int(self), currency: "EUR")
  }
}



////////////////////////////////////
// Money
//
public struct Money: CustomStringConvertible, Mathematics {
  public var amount : Int
  public var currency : String
  
  public func convert(_ to: String) -> Money {
    var otherAmount = 0
    if to == "USD" {
      if currency == "GBP" {
        otherAmount = amount * 2
      } else if currency == "EUR" {
        otherAmount = amount * 2/3
      } else if currency == "CAN" {
        otherAmount = amount * 4/5
      } else {
        otherAmount = amount
      }
    }
    if to == "GBP" {
      if currency == "USD" {
        otherAmount = amount / 2
      } else if currency == "EUR" {
        otherAmount = amount / 3
      } else if currency == "CAN" {
        otherAmount = amount * 2/5
      } else {
        otherAmount = amount
      }
    }
    if to == "EUR" {
      if currency == "GBP" {
        otherAmount = amount * 3
      } else if currency == "USD" {
        otherAmount = amount * 3/2
      } else if currency == "CAN" {
        otherAmount = amount * 5/6
      } else {
        otherAmount = amount
      }
    }
    if to == "CAN" {
      if currency == "GBP" {
        otherAmount = amount * 5/2
      } else if currency == "EUR" {
        otherAmount = amount * 6/5
      } else if currency == "USD" {
        otherAmount = amount * 5/4
      } else {
        otherAmount = amount
      }
    }
    return Money(amount: otherAmount, currency: to)
  }
  
  public func add(_ to: Money) -> Money {
    if self.currency != to.currency {
      let new = self.convert(to.currency)
      return Money(amount: (new.amount + to.amount), currency: to.currency)
    }
    return Money(amount: (self.amount + to.amount), currency: to.currency)
  }
  
  public func subtract(_ from: Money) -> Money {
    if self.currency != from.currency {
      let new = self.convert(from.currency)
      return Money(amount: (new.amount - from.amount), currency: from.currency)
    }
    return Money(amount: (self.amount - from.amount), currency: from.currency)
  }
  
  public var description : String {
    return "\(self.currency)\(self.amount)"
  }
  
  static func +(l: Money, r: Money) -> Money {
    return r.add(l)
  }
  
  static func -(l: Money, r: Money) -> Money {
    return r.subtract(l)
  }
}

////////////////////////////////////
// Job
//
open class Job: CustomStringConvertible {
  fileprivate var title : String
  fileprivate var type : JobType
  
  public enum JobType {
    case Hourly(Double)
    case Salary(Int)
  }
  
  public init(title : String, type : JobType) {
    self.title = title
    self.type = type
  }
  
  open func calculateIncome(_ hours: Int) -> Int {
    switch self.type {
    case .Hourly(let hourly):
      return Int(hourly * Double(hours))
    case .Salary(let salary):
      return salary
    }
  }
  
  open func raise(_ amt : Double) {
    switch self.type {
    case .Hourly(let hourly):
      self.type = JobType.Hourly(hourly + amt)
    case .Salary(let salary):
      self.type = JobType.Salary(salary + Int(amt))
    }
  }
  
  public var description : String {
    return "\(self.title)"
  }
  
}

////////////////////////////////////
// Person
//
open class Person: CustomStringConvertible {
  open var firstName : String = ""
  open var lastName : String = ""
  open var age : Int = 0
  
  fileprivate var _job : Job? = nil
  open var job : Job? {
    get {return self._job}
    set(value) {
      if self.age > 15 {
        self._job = value
      }
    }
  }
  
  fileprivate var _spouse : Person? = nil
  open var spouse : Person? {
    get {return self._spouse}
    set(value) {
      if self.age >= 18 {
        self._spouse = value
      }
    }
  }
  
  public init(firstName : String, lastName: String, age : Int) {
    self.firstName = firstName
    self.lastName = lastName
    self.age = age
  }
  
  open func toString() -> String {
    return("[Person: firstName:\(firstName) lastName:\(lastName) age:\(age) job:\(String(describing: job)) spouse:\(String(describing: spouse))]")
    
  }
  
  public var description : String {
    return "\(firstName) \(lastName)"
  }
}

////////////////////////////////////
// Family
//
open class Family {
  fileprivate var members : [Person] = []
  
  public init(spouse1: Person, spouse2: Person) {
    if(spouse1.age >= 18 && spouse2.age >= 18) {
      if spouse1._spouse == nil && spouse2._spouse == nil {
        spouse1._spouse = spouse2
        members.append(spouse1)
        spouse2._spouse = spouse1
        members.append(spouse2)
      }
    }
  }
  
  open func haveChild(_ child: Person) -> Bool {
    var childExists = false
    for person: Person in members {
      if(person.age >= 21) {
        var member = true
        for person: Person in members {
          if(person.firstName == child.firstName) {
            member = false
          }
        }
        if(member) {
          members.append(child)
        }
        childExists = true
      }
    }
    return childExists
  }
  
  open func householdIncome() -> Int {
    var income = 0
    for person in members {
      if(person.job != nil) {
        income += person.job!.calculateIncome(2000)
      }
    }
    return income
  }
  
  
  public var description : String {
    var family = ""
    for familyMember in self.members {
      family += familyMember.description + ", "
    }
    return family.substring(to: family.index(family.endIndex, offsetBy: -2))
  }
}





