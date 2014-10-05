package {

import net.flashpunk.Engine;
import net.flashpunk.FP;
import net.flashpunk.World;
import net.flashpunk.utils.Input;
import net.flashpunk.utils.Key;

import org.spindle.entities.Player;

import org.spindle.terrain.TerrainGenerator;

[SWF(width='1024', height='768', backgroundColor='#000000', frameRate='30')]
public class GalaxyExplorer extends Engine {

    private var scale:uint = 2;
    private var size:uint = 70 / scale;
    private var compactness:uint = 2 / scale;
    private var terrainGenerator:TerrainGenerator = new TerrainGenerator();
    private var levelWidth:uint = size;
    private var levelHeight:uint = size * 0.75;


    public function GalaxyExplorer() {
        super(1024, 768, 30, false);
        FP.screen.scale = scale;
        FP.console.enable();
    }

    override public function init():void {
        FP.screen.color = 0x000000;
        createLevel(levelWidth, levelHeight, size);
        FP.console.log("World size: " + size);
    }

    private function createLevel(worldWidth:uint, worldHeight:uint, isleSize:uint):void {
        var world:World = new World();
        world.add(terrainGenerator.createLevel(worldWidth, worldHeight, isleSize, compactness));
        world.add(new Player());
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

        if (shouldRefresh) {
            FP.console.log("World size: " + size);
            createLevel(levelWidth, levelHeight, size);

        }
    }


}
}
