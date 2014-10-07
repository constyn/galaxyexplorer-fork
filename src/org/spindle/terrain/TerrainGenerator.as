/**
 * Created by cornel on 9/23/14.
 */
package org.spindle.terrain {
import net.flashpunk.Entity;
import net.flashpunk.FP;
import net.flashpunk.graphics.Tilemap;

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

    public function createLevel(worldWidth:uint, worldHeight:uint, isleSize:uint, compactness:uint):Entity {


        var tileEntity:Entity = new Entity();
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
            }
        }
        tiles.setTile(1, 1, 0);
        tileEntity.addGraphic(tiles);
        return tileEntity;
    }
	
	public function createFOW(worldWidth:uint, worldHeight:uint, initX:uint, initY:uint):Entity {
		var tileEntity:Entity = new Entity();
        var tiles:Tilemap = new Tilemap(Assets.SPRITES, worldWidth * Assets.TILE_SIZE, worldHeight * Assets.TILE_SIZE, Assets.TILE_SIZE, Assets.TILE_SIZE);
        var str:String;	
        var map:Array = makeShadowMap(worldWidth, worldHeight, initX, initY);
        var tile:Number;
        var tileHeight:Number


        for (var j:uint = 1; j < worldWidth - 1; j++) {
            for (var i:uint = 1; i < worldHeight - 1; i++) {
                tileHeight = (map[j][i] / 10);
                str = getSurroundings(map, j, i);
                if (map[j][i] > 3) {
                    str = getSurroundings(map, j, i).substr(0, 3);
                    tile = 65
					//tile = Tileculator.getTile(str)
                    if (tile) {
                        tiles.setTile(i, j, tile, tileHeight);
                    } else {
                        tiles.setTile(i, j, 64, tileHeight);
                    }             
				} 
            }
        }
        tiles.setTile(1, 1, 0);
        tileEntity.addGraphic(tiles);
        return tileEntity;
	}
	
	private function makeShadowMap(worldWidth:uint, worldHeight:uint, initX:uint, initY:uint):Array 
	{
		var map:Array = [];
        var row:Array;
        for (var j:uint = 0; j < worldHeight; j++) {
            row = [];
            for (var i:uint = 0; i < worldWidth; i++) {
                row.push(int(FP.distance(initX,initY,i,j)));
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

    /**
     private function generateStructures() {

         var structuresArr = [];
         for (var w = 0; w < numStructures; w++) {
            var ry = Math.round(((worldHeight / 2 - isleWidth / 2) + Math.round(FP.random * isleWidth)));
            var rx = Math.round((( worldWidth / 2 - isleWidth / 2) + Math.round(FP.random * isleWidth)));
            var sw = 4 + Math.round(FP.random * 10);
            var sh = 4 + Math.round(FP.random * 10);

            function addWall(ly, lx, num, chances) {
                if (!chances) chances = 0.2;
                for (var i = 0; i < structuresArr.length; i++) {
                    if (lx < structuresArr[i].sx || lx > structuresArr[i].ex || ly < structuresArr[i].sy || ly > structuresArr[i].ey) {

                    } else {
                        return;
                    }
                }

                if (map[lx][ly] > 9 && FP.random > chances) {
                    map[ly][lx] = num;
                }
            }


            if (ry + sh > worldHeight - 1) {
                sh = worldHeight - ry - 1;
            }

            if (rx + sw > worldWidth - 1) {
                sw = worldWidth - rx - 1;
            }


            for (var j = ry; j <= ry + sh; j++) {
                addWall(j, rx, 100);
                addWall(j, rx + sw, 100);
                //map[j][rx] = map[j][rx]>9 ? 100 : map[j][rx];
                //map[j][rx+sw] = map[j][rx+sw]>9 ? 100 : map[j][rx+sw];
            }


            for (var i = rx; i <= rx + sw; i++) {
                addWall(ry, i, 100);
                addWall(ry + sh, i, 100);
                //map[ry][i] = map[ry][i] > 9 ?  100 : map[ry][i];
                //map[ry+sh][i] = map[ry+sh][i] > 9 ? 100 : map[ry+sh][i];
            }

            for (var j = ry + 1; j <= ry + sh - 1; j++) {
                for (var i = rx + 1; i <= rx + sw - 1; i++) {
                    addWall(j, i, 101, 0.06);
                }
            }


            structuresArr.push({
                sx: rx,
                sy: ry,
                ex: rx + sw,
                ey: ry + sh
            })


        }

    }
     */
}
}
