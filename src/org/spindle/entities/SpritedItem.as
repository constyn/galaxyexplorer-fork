/**
 * Created by cornel on 10/5/14.
 */
package org.spindle.entities {
import net.flashpunk.Entity;

public class SpritedItem extends Entity {

    public function removeMe():void {
        world.recycle(this)
    }

    protected function getSprite(x:int, y:int):int {
        return y * 20 + x;
    }
}
}
