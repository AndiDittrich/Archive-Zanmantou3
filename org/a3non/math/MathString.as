package org.a3non.math{
	
/**
 * Some utilities to handle equations/math strings
 * 
 */
public class MathString{		
	
	private var s:String = "";

	/**
	 * operator definitions
	 */
	public static var OPERATOR_PLUS:String = "+";
	public static var OPERATOR_MINUS:String = "-";
	public static var OPERATOR_MUL:String = "*";
	public static var OPERATOR_DIV:String = "/";
	
	
	public function MathString(s:String){
		this.s = s;
	}
	
	/**
	 * only integers with +/- operations are supported
	 */
	public function parse():int{
		var result:int = 0;
		var b:String = "";
		var c:String = "";
		
		// initial operator
		var op:String = "+";
		
		// iterate over all chars of math string
		for (var i:int=0;i<this.s.length;i++){
			// get char of string and parse
			b = this.s.charAt(i);
			
			// check if it's numeric values or an operator
			if (MathString.isNumeric(b)){
				// append if its numeric
				c = c+b;
			}else{
				// check for valid operator
				if (b==MathString.OPERATOR_PLUS || b==MathString.OPERATOR_MINUS){
					// compute new result
					result = this.compute(result, parseInt(c), op);

					// finally store new operator
					op = b;
					
					// clear cache
					c = "";
				}
			}		
		}
		
		// finally compute last section
		result = this.compute(result, parseInt(c), op);

		//return parseInt(this.s);
		return result;
	}
	
	/**
	 * compute engine
	 */
	private function compute(a:int, b:int, op:String):int{
		if (op==MathString.OPERATOR_PLUS){
			return a+b;			
		}
		if (op==MathString.OPERATOR_MINUS){
			return a-b;			
		}
				
		return 0;
	}
	
	/**
	 * util..
	 */
	public static function isNumeric(s:String):Boolean{
		return (s=="0" || s=="1" || s=="2" || s=="3" || s=="4" || s=="5" || s=="6" || s=="7" || s=="8" || s=="9");
	}
}}