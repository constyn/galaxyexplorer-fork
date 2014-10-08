package org.spindle.entities 
{
    import net.flashpunk.Entity;
    import net.flashpunk.FP;
    import net.flashpunk.Graphic;
    import net.flashpunk.graphics.Graphiclist;
    import net.flashpunk.graphics.Image;
    import net.flashpunk.graphics.Text;
    import net.flashpunk.tweens.misc.NumTween;
    import net.flashpunk.utils.Ease;
	/**
	 * ...
	 * @author 
	 */
	public class TextConsole extends Entity
	{				
		public var texts:Array;
 
        public function TextConsole()
        {
            super();
			texts = [];
        }
  
        public function addText(text:String):void
        {
			trace(texts)
			var str:String = '';
			texts.push(text);
			for (var i:int = texts.length -1; i >= 0; i-- )
			{
				str += "\n\n" + texts[i];
			}				
			
			var title:Text = new Text(str);
			var ent:Entity = new Entity();
            title.color = 0xffffff;
			title.size = 8;
			title.wordWrap = true;
			title.width = 150;
            graphic = Graphic(title);
            this.x = 0;
            this.y = 10
        }		
	}
}