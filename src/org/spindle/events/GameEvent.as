package org.spindle.events 
{
	import flash.events.Event;
	/**
	 * ...
	 * @author 
	 */
	public class GameEvent extends Event
	{
		public var data:Object;
		
		public function GameEvent(type:String, data:Object = null , bubble:Boolean = false, cancelable:Boolean = false) 
		{
			super(type, bubble, cancelable)
			this.data = data;
		}
		
	}

}