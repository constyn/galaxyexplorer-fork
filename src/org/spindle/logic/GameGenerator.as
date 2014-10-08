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
		
		public function GameGenerator() 
		{
			
		}
		
		public function createLevel(worldWidth:uint, worldHeight:uint, model:Model):Entity 
		{
			var tileEntity:Entity = new Entity();
			var tiles:Tilemap = new Tilemap(Assets.SPRITES, worldWidth * Assets.TILE_SIZE, worldHeight * Assets.TILE_SIZE, Assets.TILE_SIZE, Assets.TILE_SIZE);
			var str:String;
			var tile:Number;
			var tileHeight:Number
			
			for (var j:uint = 1; j < worldWidth - 1; j++) {
				for (var i:uint = 1; i < worldHeight - 1; i++) {
					if (model.character.xPos == i && model.character.yPos == j)
						tiles.setTile(i, j, 106, 1);
				}
			}
			tiles.setTile(1, 1, 0);
			tileEntity.addGraphic(tiles);
			return tileEntity;
		}		
	}
}