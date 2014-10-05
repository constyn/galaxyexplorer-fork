/**
 * Created by cornel on 10/5/14.
 */
package org.spindle.entities {
import net.flashpunk.graphics.Spritemap;
import net.flashpunk.utils.Input;
import net.flashpunk.utils.Key;

import org.spindle.constants.Assets;

import org.spindle.constants.Types;

public class Player extends SpritedItem {


    public static const LEFT:String = "goingLeft";
    public static const RIGHT:String = "goingRight";
    public static const UP:String = "goingUp";
    public static const DOWN:String = "goingDown";

    public static const STAND_LEFT:String = "goingLeft";
    public static const STAND_RIGHT:String = "goingRight";
    public static const STAND_UP:String = "goingUp";
    public static const STAND_DOWN:String = "goingDown";

    public var xDirection:Number = 0;
    public var yDirection:Number = 1;

    private var speed:uint = 2;

    public var sprite:Spritemap = new Spritemap(Assets.SPRITES, Assets.TILE_SIZE, Assets.TILE_SIZE);
    protected var defaultAnim:String = "anim";

    public function Player() {

        x = 150;
        y = 50;

        sprite.add(LEFT, [getSprite(1, 7), getSprite(1, 8)], 10, true);
        sprite.add(RIGHT, [getSprite(2, 7), getSprite(2, 8)], 10, true);
        sprite.add(DOWN, [getSprite(3, 7), getSprite(3, 8)], 10, true);
        sprite.add(UP, [getSprite(4, 7), getSprite(4, 8)], 10, true);

        sprite.add(STAND_LEFT, [getSprite(1, 7)]);
        sprite.add(STAND_RIGHT, [getSprite(2, 7)]);
        sprite.add(STAND_DOWN, [getSprite(3, 7)]);
        sprite.add(STAND_UP, [getSprite(4, 7)]);

        updateState(STAND_DOWN);
        type = Types.PLAYER;
        name = Types.PLAYER;
        layer = 5;

        setHitbox(16, 16);
        setOrigin(0, 0);

        graphic = sprite;



    }

    private function updateState(state:String):void {
        if (state == sprite.currentAnim) return;

        switch (state) {
            case STAND_LEFT:
            case STAND_RIGHT:
            case STAND_UP:
            case STAND_DOWN:
                break
            case RIGHT:
                xDirection = 1;
                break;
            case LEFT:
                xDirection = -1;
                break;
            case UP:
                yDirection = -1;
                break;
            case DOWN:
                yDirection = 1;
                break;

        }
        sprite.play(state);
    }


    override public function update():void {
        super.update();
        var moving:Boolean = false;
        if (Input.check(Key.DOWN)) {
            updateState(DOWN);
            moving = true;
            y+=speed;
        }

        if (Input.check(Key.UP)) {
            updateState(UP);
            moving = true;
            y-=speed;
        }

        if (Input.check(Key.LEFT)) {
            updateState(LEFT);
            moving = true;
            x-=speed;
        }

        if (Input.check(Key.RIGHT)) {
            updateState(RIGHT);
            moving = true;
            x+=speed;
        }


        if (!moving) {
            if (yDirection == -1) {
                updateState(STAND_UP)
            } else if (yDirection == 1) {
                updateState(STAND_DOWN)
            } else if (xDirection == -1) {
                updateState(STAND_LEFT)
            } else if (xDirection == 1) {
                updateState(STAND_RIGHT);
            }
            xDirection = 0;
            yDirection = 0;
        }

    }
}
}
