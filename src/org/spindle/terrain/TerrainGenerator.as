/**
 * Created by cornel on 9/23/14.
 */
package org.spindle.terrain {
import net.flashpunk.Entity;
import net.flashpunk.FP;
import net.flashpunk.graphics.Tilemap;

import org.spindle.constants.Assets;

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


        for (var j:uint = 1; j < worldHeight - 1; j++) {
            for (var i:uint = 1; i < worldWidth - 1; i++) {
                tileHeight = (map[j][i] / 10);
                str = getSurroundings(map, j, i);
                if (map[j][i] < 10) {
                    str = getSurroundings(map, j, i).substr(0, 3);
                    tile = Mappings.WaterMappings[str];
                    //tile = Tileculator.getTile(str)
                    if (tile) {
                        tiles.setTile(i, j, tile);
                    } else {
                        tiles.setTile(i, j, 64);
                    }
                } else if (map[j][i] === 100) {
                    str = getSurroundings(map, j, i, 100);
                    if (Tileculator.matches(str, 'x0xxxx0x')) {
                        tile = 71;
                    } else if (Tileculator.matches(str, 'x0xxxx1x') || Tileculator.matches(str, 'x1xxxx1x') ) {
                        tile = 50;
                    } else {
                        tile = 70;
                    }

                    tiles.setTile(i, j, tile)
                } else {
                    //tileHeight =  0.6+(map[j][i] / 40);
                    tile = Tileculator.getTile(str)
                    if (tile) {
                        tiles.setTile(i, j, tile);
                    } else trace('Unknown ' + str);
                }
            }
        }
        tiles.setTile(1, 1, 0);
        var fx:uint;
        var fy:uint;
        for (var i:uint = 1; i < tiles.width - 1; i++) {
            for (var j:uint = 1; j < tiles.height - 1; j++) {
                fx = Math.random() < 0.3 ? (i - 1 + Math.round(Math.random() * 2)) : i;
                fy = Math.random() < 0.3 ? (j - 1 + Math.round(Math.random() * 2)) : j;
                tiles.setPixel(i, j, randomNoiseValue(tiles.getPixel(fx, fy)));
            }
        }
        tileEntity.addGraphic(tiles);
        tileEntity.layer = 5;
        return tileEntity;
    }

    public function randomNoiseValue(value:uint):int {
        var darken:uint = Math.round(240 + 15 * Math.random());
        var red:uint = value >> 24 & darken;
        var green:uint = value >> 16 & darken;
        var blue:uint = value >> 8 & darken;
        var alpha:uint = value & 0xFF;
        var result:uint = red << 24 | green << 16 | blue << 8 | alpha;

        return result;
    }

    private function doGenerate(worldWidth:uint, worldHeight:uint, isleSize:uint, compactness:uint):Array {

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
            var mx:Number = 1 + Math.round(FP.random * (worldWidth - 10));
            var my:Number = 1 + Math.round(FP.random * (worldHeight - 10));


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
                    avg = Math.round((
                            map[j - 1][i - 1] + map[j - 1][i] + map[j - 1][i + 1] +
                            map[j][i - 1] + map[j][i + 1] +
                            map[j + 1][i - 1] + map[j - 1][i] + map[j + 1][i + 1]
                            ) / 8);

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


        /***************************************/
        /*             Structures              */
        /***************************************/

        function addWall(px:uint, py:uint) {
            if (px < worldWidth - 1 && py < worldHeight - 1 && map[py][px] > 10 && map[py][px] < 40 && FP.random < 0.7) {
                map[py][px] = 100;
            }
        }

        var numStructures:uint = 3;

        for (var i:uint = 0; i < numStructures; i++) {

            var sx:uint = FP.rand(worldWidth / 2);
            var sy:uint = FP.rand(worldHeight / 2);
            var sw:uint = isleSize / 4 + FP.rand(isleSize / 2);
            var sh:uint = isleSize / 4 + FP.rand(isleSize / 2);

            for (var si:uint = sx; si < sx + sw; si++) {
                addWall(si, sy);
                addWall(si, sy+sh);
            }

            for (var sj:uint = sy; sj < sy + sh; sj++) {
                addWall(sx, sj);
                addWall(sx+sw, sj);
            }


        }

        return map;
    }


}
}
