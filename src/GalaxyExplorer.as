package {

import flash.events.Event;
import flash.utils.Endian;
import net.flashpunk.Engine;
import net.flashpunk.Entity;
import net.flashpunk.FP;
import net.flashpunk.graphics.Text;
import net.flashpunk.World;
import net.flashpunk.utils.Input;
import net.flashpunk.utils.Key;
import org.spindle.constants.Assets;
import org.spindle.entities.FloatingText;
import org.spindle.entities.TextConsole;
import org.spindle.events.GameEvent;
import org.spindle.logic.Character;
import org.spindle.logic.GameGenerator;
import org.spindle.logic.GameLogic;
import org.spindle.model.Model;

import org.spindle.terrain.TerrainGenerator;

		[SWF(width='1024', height='768', backgroundColor='#000000', frameRate='30')]
		public class GalaxyExplorer extends Engine {

			private var size:Number = 50;
			private var compactness:Number = 2;
			private var terrainGenerator:TerrainGenerator = new TerrainGenerator();
			private var gameGenerator:GameGenerator = new GameGenerator();
			private var model:Model;
			private var logic:GameLogic;
			private var textConsole:TextConsole;
			private var world:World;

			public function GalaxyExplorer() {
				super(1024, 768, 30, false);
				FP.screen.scale = 2;
				FP.console.enable();
			}

			override public function init():void {
				FP.screen.color = 0x000000;
				model = new Model();
				logic = new GameLogic(model)
				logic.addEventListener("event", onEvent);			
				createLevel(Assets.WORLD_WIDTH, Assets.WORLD_HEIGHT, size);		
				logic.startAdventure();
				model.character.reset(model.map)
				createGameObjects();
				updateFog();
				textConsole = TextConsole(world.create(TextConsole));		
			}

			private function createLevel(worldWidth:uint, worldHeight:uint, isleSize:uint):void {
				world = new World();
				world.add(terrainGenerator.createLevel(worldWidth, worldHeight, isleSize, compactness, model));						
				model.exploredMap = model.initMap(Assets.WORLD_WIDTH, Assets.WORLD_HEIGHT)
				FP.world = world;
			}
			
			private function createGameObjects():void
			{
				world.add(gameGenerator.createLevel(Assets.WORLD_WIDTH, Assets.WORLD_HEIGHT, model));			
			}
			
			private function updateFog():void
			{		
				if(model.fow)
					world.remove(model.fow);	
				
				model.fow = world.add(terrainGenerator.createFOW(Assets.WORLD_WIDTH, Assets.WORLD_HEIGHT, model.character.xPos, model.character.yPos, model));			
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
				   
					//var mx:int = (Input.mouseX / Assets.TILE_SIZE);
					//var my:int = (Input.mouseY / Assets.TILE_SIZE);
					//updateFog(mx, my);
					//FloatingText(FP.world.create(FloatingText)).reset(Input.mouseX, Input.mouseY,"hahaha");
				}
				
				if (shouldRefresh) {
					FP.console.log("World size: " + size);
					createLevel(60, 60, size);
				}
			}
			
			private function onEvent(e:GameEvent):void
			{		
				if(textConsole)
					textConsole.addText(String(e.data))
			}
		}
}
