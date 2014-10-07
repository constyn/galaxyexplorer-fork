package org.spindle.model 
{
	import org.spindle.constants.Assets;
	/**
	 * ...
	 * @author 
	 */
	public class Model 
	{
		
		public function Model() 
		{
			init()
		}
		
		private function init():void {
			var row:Array;
			exploredMap = [];
			for (var j:uint = 0; j < Assets.WORLD_HEIGHT; j++) {
				row = [];
				for (var i:uint = 0; i < Assets.WORLD_WIDTH; i++) {
					row.push(0)
				}
				exploredMap.push(row);
			}
		}
		
		public var exploredMap:Array;
		
	}

}