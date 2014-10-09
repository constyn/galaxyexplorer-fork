package org.spindle.logic 
{
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Tilemap;
	import org.spindle.constants.Assets;
	import org.spindle.model.Model;
	/**
	 * ...
	 * @author 
	 */
	public class GameGenerator 
	{
		
		private var ageMapping:Array = [ { days:0, skin:106}, { days:3, skin:107 }, { days:7, skin:108 },
										 { days:14, skin:126 }, { days:30, skin:127 }, { days:60, skin:128 },
										 { days:365, skin:146 }, { days:3650, skin:147 }, { days:7000, skin:148 }
									   ]
		
		public function GameGenerator() 
		{
			
		}
		
		public function createLevel(worldWidth:uint, worldHeight:uint, model:Model):Entity 
		{			
			var tileEntity:Entity = new Entity();
			tileEntity.layer = 3
			var tiles:Tilemap = new Tilemap(Assets.SPRITES, worldWidth * Assets.TILE_SIZE, worldHeight * Assets.TILE_SIZE, Assets.TILE_SIZE, Assets.TILE_SIZE);
			var str:String;
			var tile:Number;
			var tileHeight:Number
			
			for (var j:uint = 1; j < worldWidth - 1; j++) {
				for (var i:uint = 1; i < worldHeight - 1; i++) {
					if (model.character.xPos == i && model.character.yPos == j)
					{		
						var selectedSkin:uint;
						for each(var states:Object in ageMapping)
						{
							if (states.days <= model.character.daysOnIsland)
								selectedSkin = states.skin
						}
						
						tiles.setTile(i, j, selectedSkin, 1);						
					}
				}
			}
			tiles.setTile(1, 1, 0);
			tileEntity.addGraphic(tiles);
			return tileEntity;
		}		
	}
}