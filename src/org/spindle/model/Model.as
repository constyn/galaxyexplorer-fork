package org.spindle.model 
{
	import net.flashpunk.Entity;
	import org.spindle.constants.Assets;
	import org.spindle.logic.Character;
	/**
	 * ...
	 * @author 
	 */
	public class Model 
	{
		
		public var exploredMap:Array;
		public var texts:Array;
		public var items:Array;
		public var character:Character;
		public var fow:Entity;
		public var gameObjs:Entity;
		public var map:Array;
		public var alreadyMoved:Boolean;
		
		
		public function Model() 
		{
			init()
			
		}
		
		private function init():void {
			exploredMap = initMap(Assets.WORLD_HEIGHT, Assets.WORLD_WIDTH)
			map = initMap(Assets.WORLD_HEIGHT, Assets.WORLD_WIDTH)		
			texts = [];
			items = [];
		}
		
		public function initMap(h:uint,w:uint):Array
		{
			var row:Array;
			var m:Array = [];
			for (var j:uint = 0; j < h; j++) {
				row = [];
				for (var i:uint = 0; i < w; i++) {
					row.push(0)
				}
				m.push(row);
			}
			
			return m;
		}		
	}
}