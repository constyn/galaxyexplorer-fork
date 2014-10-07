package {

import flash.utils.Endian;
import net.flashpunk.Engine;
import net.flashpunk.Entity;
import net.flashpunk.FP;
import net.flashpunk.World;
import net.flashpunk.utils.Input;
import net.flashpunk.utils.Key;
import org.spindle.constants.Assets;
import org.spindle.model.Model;

import org.spindle.terrain.TerrainGenerator;

[SWF(width='1024', height='768', backgroundColor='#000000', frameRate='30')]
public class GalaxyExplorer extends Engine {

    private var size:Number = 50;
    private var compactness:Number = 2;
    private var terrainGenerator:TerrainGenerator = new TerrainGenerator();
	private var fow:Entity;
	private var model:Model;

    public function GalaxyExplorer() {
        super(1024, 768, 30, false);
        FP.screen.scale = 2;
        FP.console.enable();
    }

    override public function init():void {
        FP.screen.color = 0x000000;
		model = new Model();
        createLevel(Assets.WORLD_WIDTH, Assets.WORLD_HEIGHT, size);	
    }

    private function createLevel(worldWidth:uint, worldHeight:uint, isleSize:uint):void {
        var world:World = new World();
        world.add(terrainGenerator.createLevel(worldWidth, worldHeight, isleSize, compactness));
		fow = world.add(terrainGenerator.createFOW(worldWidth, worldHeight, 15, 15, model));
        FP.world = world;
    }


    override public function update():void {
        super.update();
        var shouldRefresh:Boolean = false;
        if (Input.check(Key.R)) {
            shouldRefresh = true;
        } else if (Input.check(Key.NUMPAD_ADD)) {
            size++;
            shouldRefresh = true;
        } else if (Input.check(Key.NUMPAD_SUBTRACT)) {
            size--;
            shouldRefresh = true;
        }
		else if (Input.mousePressed) {
           
			var mx:int = (Input.mouseX / Assets.TILE_SIZE);
			var my:int = (Input.mouseY / Assets.TILE_SIZE);
		    FP.world.remove(fow);
		    fow = FP.world.add(terrainGenerator.createFOW(Assets.WORLD_WIDTH, Assets.WORLD_HEIGHT, mx, my, model));
        }

        if (shouldRefresh) {
            FP.console.log("World size: " + size);
            createLevel(60, 60, size);

        }
    }


}
}
