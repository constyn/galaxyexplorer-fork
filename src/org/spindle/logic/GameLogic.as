package org.spindle.logic 
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import net.flashpunk.FP;
	import org.spindle.constants.Assets;
	import org.spindle.events.GameEvent;
	import org.spindle.model.Model;
	/**
	 * ...
	 * @author 
	 */
	public class GameLogic extends EventDispatcher
	{
		private var model:Model;
		
		
		public function GameLogic(model:Model) 
		{
			this.model = model;
		}
		
		private function init():void
		{
			
		}
		
		public function startAdventure():void
		{
			model.items.push(getRandomItem());
			model.character = getRandomChar();
			model.texts.push(getRandomText());
			
			FP.alarm(3, showText)
			
		}
		
		private function showText():void
		{
			dispatchEvent(new GameEvent("event", "you wake up on a sandy beach")) 
		}
		
		private function getRandomText():String 
		{
			return '';
		}
		
		private function getRandomChar():Character 
		{
			var char:Character = new Character();	
			return char;
		}
		
		private function getRandomItem():Item 
		{
			return new Item();
		}
		
		
		
	}

}