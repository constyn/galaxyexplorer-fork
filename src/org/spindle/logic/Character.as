package org.spindle.logic 
{
	import org.spindle.constants.Assets;
	/**
	 * ...
	 * @author 
	 */
	public class Character 
	{
		public var xPos:uint;
		public var yPos:uint;
		
		public function Character() 
		{
			
		}
		
		public function reset(map:Array):void
		{			
			for (var j:uint = 0; j < Assets.WORLD_WIDTH - 1; j++) {
				for (var i:uint = 0; i < Assets.WORLD_HEIGHT - 1; i++) {
					if (map[j][i] == 22)
					{
						xPos = i;
						yPos = j;
						return;
					}
				}
			}
		}
		
	}

}