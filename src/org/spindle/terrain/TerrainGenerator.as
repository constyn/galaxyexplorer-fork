/**
 * Created by cornel on 9/23/14.
 */
package org.spindle.terrain {
import net.flashpunk.Entity;
import net.flashpunk.FP;
import net.flashpunk.graphics.Tilemap;
import org.spindle.constants.Assets;
import org.spindle.model.Model;

public class TerrainGenerator {

    private static function getSurroundings(map:Array, j:uint, i:uint, limit:uint = 10):String {
        return ""
                + (map[j - 1][i - 1] < limit ? 0 : 1)
                + (map[j - 1][i] < limit ? 0 : 1)
                + (map[j - 1][i + 1] < limit ? 0 : 1)
                + (map[j][i - 1] < limit ? 0 : 1)
                + (map[j][i + 1] < limit ? 0 : 1)
                + (map[j + 1][i - 1] < limit ? 0 : 1)
                + (map[j + 1][i] < limit ? 0 : 1)
                + (map[j + 1][i + 1] < limit ? 0 : 1);
    }

    public function createLevel(worldWidth:uint, worldHeight:uint, isleSize:uint, compactness:uint, model:Model):Entity {


        var tileEntity:Entity = new Entity();
		tileEntity.layer = 3
        var tiles:Tilemap = new Tilemap(Assets.SPRITES, worldWidth * Assets.TILE_SIZE, worldHeight * Assets.TILE_SIZE, Assets.TILE_SIZE, Assets.TILE_SIZE);
        var str:String;
        var map:Array = doGenerate(worldWidth, worldHeight, isleSize, compactness);		
        var tile:Number;
        var tileHeight:Number


        for (var j:uint = 1; j < worldWidth - 1; j++) {
            for (var i:uint = 1; i < worldHeight - 1; i++) {
                tileHeight = (map[j][i] / 10);
                str = getSurroundings(map, j, i);
                if (map[j][i] < 10) {
                    str = getSurroundings(map, j, i).substr(0, 3);
                    tile = Mappings.WaterMappings[str];
					//tile = Tileculator.getTile(str)
                    if (tile) {
                        tiles.setTile(i, j, tile, tileHeight);
                    } else {
                        tiles.setTile(i, j, 64, tileHeight);
                    }
                } else if (map[j][i] === 100) {
                    //ctx.fillStyle = "rgb(125,125,125)";
                    tiles.setTile(i, j, 34)
                } else if (map[j][i] === 101) {
                    tiles.setTile(i, j, 35);
                } else {
                    tileHeight = (map[j][i] / 10);
                    tile = Tileculator.getTile(str)
                    if (tile) {
                        tiles.setTile(i, j, tile, tileHeight);
                    } else trace('Unknown ' + str);
                }
				model.map[j][i] = tile;
            }
        }
        tiles.setTile(1, 1, 0);
		
		for (var i:uint = 1; i < tiles.width - 1; i++) {
            for (var j:uint = 1; j < tiles.height - 1; j++) {
                var fx = Math.random() < 0.3 ? (i - 1 + Math.round(Math.random() * 2)) : i;
                var fy = Math.random() < 0.3 ? (j - 1 + Math.round(Math.random() * 2)) : j;
                tiles.setPixel(i, j, randomNoiseValue(tiles.getPixel(fx, fy)));
            }
        }
		
        tileEntity.addGraphic(tiles);
        return tileEntity;
    }
	
	private function randomNoiseValue(value:uint):int 
	{
        var darken:uint = Math.round(240 + 15 * Math.random());
        var red:uint = value >> 24 & darken;
        var green:uint = value >> 16 & darken;
        var blue:uint = value >> 8 & darken;
        var alpha:uint = value & 0xFF;
        var result:uint = red << 24 | green << 16 | blue << 8 | alpha;

        return result;
    }
	
	public function createFOW(worldWidth:uint, worldHeight:uint, initX:uint, initY:uint, model:Model ):Entity {
		
		var tileEntity:Entity = new Entity();
		tileEntity.layer = 2
        var tiles:Tilemap = new Tilemap(Assets.SPRITES, worldWidth * Assets.TILE_SIZE, worldHeight * Assets.TILE_SIZE, Assets.TILE_SIZE, Assets.TILE_SIZE);
        var str:String;	
        var map:Array = makeShadowMap(worldWidth, worldHeight, initX, initY, model);
        var tile:Number;
        var tileHeight:Number
		
        for (var j:uint = 1; j < worldWidth - 1; j++) {
            for (var i:uint = 1; i < worldHeight - 1; i++) {
                tileHeight = (map[j][i] / 10);
                str = getSurroundings(map, j, i, 2);
                if (map[j][i] > 1) {
					tile = Tileculator.getShadowTile(str)
                    if (tile) {
                        tiles.setTile(i, j, tile, 1);
                    } else {
                        tiles.setTile(i, j, 1000, tileHeight);
                    }             
				} 
				else
				{
					model.exploredMap[j][i] = 1;
				}
            }
        }
        tiles.setTile(1, 1, 0);
		
        tileEntity.addGraphic(tiles);
        return tileEntity;
	}
	
	private function makeShadowMap(worldWidth:uint, worldHeight:uint, initX:uint, initY:uint, model:Model):Array 
	{
		var map:Array = [];
        var row:Array;
        for (var j:uint = 0; j < worldHeight; j++) {
            row = [];
            for (var i:uint = 0; i < worldWidth; i++) {				
				if(!model.exploredMap[j][i])
					row.push(int(FP.distance(initX, initY, i, j)));
				else
					row.push(1);
            }
            map.push(row);
        }
		
		return map;
	}

    private function doGenerate(worldWidth:uint, worldHeight:uint, isleSize:uint, compactness:uint):Array 
	{
        var isleWidth:Number = isleSize;
        var map:Array = [];
        var passes:Number = 50;
        var row:Array;
        for (var j:uint = 0; j < worldHeight; j++) {
            row = [];
            for (var i:uint = 0; i < worldWidth; i++) {
                row.push(5);
            }
            map.push(row);
        }

        var genPass:Number = isleWidth * compactness;
        while (genPass > 0) {
            var mx:Number = 5 + Math.round(FP.random * (worldWidth - 10));
            var my:Number = 5 + Math.round(FP.random * (worldHeight - 10));


            if ((FP.random < 0.2 && mx < isleWidth && my < isleWidth) ||
                    Math.pow(Math.abs(isleWidth / 2 - mx), 2) + Math.pow(Math.abs(isleWidth / 2) - my, 2) < isleWidth * isleWidth / 4) {
                map[my][mx] = 15 + Math.round(FP.random * 5);
                genPass--;
            }

        }

        function filter(lastpass:Boolean = false):void {
            var filterQueue:Array = [];
            var temp:Array;
            var avg:Number;

            for (var j:uint = 1; j < worldHeight - 1; j++) {
                for (var i:uint = 1; i < worldWidth - 1; i++) {
                    avg = (
                            map[j - 1][i - 1] + map[j - 1][i] + map[j - 1][i + 1] +
                            map[j][i - 1] + map[j][i + 1] +
                            map[j + 1][i - 1] + map[j - 1][i] + map[j + 1][i + 1]
                            ) / 8;

                    if (lastpass && map[j][i] > avg) {
                        filterQueue.push([j, i, avg]);
                    } else if (FP.random < 0.3 && map[j][i] > 0) {
                        filterQueue.push([j, i, map[j][i]--])
                    } else if (avg > map[j][i])
                        filterQueue.push([j, i, avg]);
                }
            }

            for (i = 0; i < filterQueue.length; i++) {
                temp = filterQueue[i];
                map[temp[0]][temp[1]] = temp[2];
            }
        }

        while (passes--)
            filter();
        filter(true);


        return map;
    }
}
}
