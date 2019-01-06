package;

import openfl.display.Tile;

class Bomb extends Tile {
	static inline var EXPLOSION_MAX_COUNT = 90;
	static inline var PULSE_MAX_COUNT = 10;
	var explosionCount = 0;
	var pulseCount = 0;
	var realX : Int;
	var realY : Int;
    public function new(x, y) {
        super(3);
		this.originX = Main.TILE_SIZE / 2;
		this.originY = Main.TILE_SIZE / 2;
		this.x = x * Main.TILE_SIZE + this.originX;
		this.y = y * Main.TILE_SIZE + this.originY;
		this.realX = x;
		this.realY = y;
		explosionCount = EXPLOSION_MAX_COUNT;
        //@:privateAccess Main.instance;
    }
	
	public function update() : Void {
		if (pulseCount > 0) {
			pulseCount--;
		} else {
			scaleX = scaleX == 1.0 ? 1.1 : 1.0;
			scaleY = scaleY == 1.0 ? 1.1 : 1.0;
			pulseCount = PULSE_MAX_COUNT;
		}
		if (explosionCount > 0) {
			explosionCount--;
		} else {
			trace('Boom!');
			var boobMap = @:privateAccess Main.instance.bombMap;
			@:privateAccess Main.instance.tilemap.removeTile(this);
			boobMap.remove('$realX-$realY');
		}
	}

}