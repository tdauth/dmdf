//struct StructA
	//static constant integer MyConstant = 1
//endstruct

//struct StructB
	//static constant integer MyConstant = StructA.MyConstant
//endstruct
//Report this bug!

//----------------------------------------------------------------------------------------------------

//struct Struct1
	//private boolean Element
//endstruct

//struct Struct2 extends Struct1
	//method TestMethod takes nothing returns nothing
		//set this.Element = true
	//endmethod
//endstruct
//We need the protected keyword!

//library MyTestLibrary
	////! private textmacro MyTextMacro
	////! endtextmacro
//endlibrary
//We need private textmacros in libraries

//----------------------------------------------------------------------------------------------------

//type MyArray extends integer array[100]
//Mit .create erzeugen
//Mit .size Größe abfragen

//Missing enums:
//enum Number
	//One = 1
	//Two = 2
//endenum

//Das keyword class wäre angebrachter:
//class MyClass
	//integer Bla = 0 //Automatisch private
//endclass

//function string::operator< takes string String1, string String2 returns boolean
	//return (StringLength(String1) < StringLength(String2))
//endfunction

//----------------------------------------------------------------------------------------------------

//interface ParentStructInterface
	//method test takes nothing returns nothing
//endinterface

//struct ParentStruct extends ParentStructInterface
	//method test takes nothing returns nothing
		//call DisplayTimedTextToPlayer(Player(0), 0.0, 0.0, 300.0, "JAAAAAAAAAA")
	//endmethod
//endstruct

//struct ChildStruct extends ParentStruct
	//method test takes nothing returns nothing
		//call DisplayTimedTextToPlayer(Player(0), 0.0, 0.0, 300.0, "BLAAAAAAAAA")
	//endmethod
//endstruct

//function testIt takes nothing returns nothing
	//local ChildStruct this = ChildStruct.create()
	//call this.test()
	//call ParentStruct(this).test() //We can't use the superclass method, fixed since new release (super, stub)
//endfunction

//----------------------------------------------------------------------------------------------------

//struct Bla
//endstruct

//struct TestStruct
	//static constant integer max = 100
	//Bla array element[TestStruct.max] //We can't use struct constants if we have an array of custom type elements
//endstruct

//----------------------------------------------------------------------------------------------------

//struct MyStruct
	//MyStruct.myFunctionInterface action

	//function interface myFunctionInterface takes nothing returns nothing //Structs can't contain a function interface

	//static method testFunction takes nothing returns nothing //Structs can't contain a function which uses a function interface
	//endmethod

	//static method create takes nothing returns MyStruct
		//local MyStruct this = MyStruct.allocate()
		//set this.action = MyStruct.testFunction.MyStruct.myFunctionInterface //Doesn't work
		//return this
	//endmethod
//endstruct

//----------------------------------------------------------------------------------------------------

//struct MyStruct extends array[MyStruct.maxSize] //Invalid
	//public static constant integer maxSize = 10
//endstruct
