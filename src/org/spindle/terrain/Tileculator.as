package org.spindle.terrain 
{
	/**
	 * ...
	 * @author 
	 */
	public class Tileculator 
	{		
		public function Tileculator() 
		{
			
		}
		
		public static function getTile(str:String):int
		{
			var foundPattern:String = "";
			
			for (var pattern:String in LandMappings)
			{
				var correct:Boolean = true;
				var i:int = 0;
				while (correct && i < 8)
				{
					if (pattern.charAt(i) != str.charAt(i) && pattern.charAt(i) != 'x')
						correct = false;
					
					i++;
				}
				
				if (correct)
					foundPattern = pattern;
			}
			return LandMappings[foundPattern]	
		}
		
		internal static const LandMappings:Object = {
			//Mijloc
			
			//top middle
			'x1x11x0x': 62,
			
			//left middle
			'x1x01x1x': 41,
			
			//middle
			'00000000': 26,	
				
			//pen down
			'x1x00x0x': 67,
			//pen up
			'x0x00x1x': 27,
			//pen left
			'x0x01x0x': 46,
			//pen right
			'x0x10x0x': 48,
			
			//middle
			'11111111': 42,	
			
			//right middle
			'x1x10x1x': 43,
			
			//bottom middle
			'x0x11x1x': 22,
			
			//top left corner
			'x0x01x1x': 21,			
			'01111111': 45,
			
			//top right corner
			'x0x10x1x': 23,			
			'11011111': 44,
			
			//bottom left corner
			'x1x01x0x': 61,			
			'11111011': 25,
			
			//bottom right corner
			'x1x10x0x': 63,			
			'11111110': 24,
			
			//horiz bridge
			'x0x11x0x': 26,
			
			//vert bridge
			'x1x00x1x': 28,
				
			'01011xxx': 44,
			'xxx11010': 25,
			'01x1x01x': 25,
			'x10x1x10': 24,
			
			'01111110': 25,
			'11011011': 25
		}
	}

}