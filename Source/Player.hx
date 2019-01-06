package;

import openfl.display.Tile;

class Player extends Tile {
    public var realX : Int;
	public var realY : Int;
	var idleCount : Int;
	static var MAX_IDLE_COUNT = 10;
	static var MOVE_SPEED = 6;
    public function new() {
        super();
		id = 4;
		idleCount = MAX_IDLE_COUNT;
		randomStartPosition();
    }
	
	public function randomStartPosition() : Void {
		//var mapData = @:privateAccess Main.instance.mapData;
		//for (j in 0...mapData.length) {
			//var row = mapData[j];
			//for (i in 0...row.length) {
				//
			//}
		//}
		realX = 3;
		realY = 1;
		x = realX * Main.TILE_SIZE;
		y = realY * Main.TILE_SIZE;
	}
	
	public function move(direction) : Void {
		if (isMoving()) return;
		trace(direction);
		var heading = switch (direction) {
			case Direction.RIGHT: [1, 0];
			case Direction.LEFT: [-1, 0];
			case Direction.UP: [0, -1];
			case Direction.DOWN: [0, 1];
			case _:	[0, 0];
		}
		if (checkCollision(heading[0], heading[1]) == false) {
			realX += heading[0];
			realY += heading[1];
		}
	}
	
	public function isMoving() : Bool {
		return x != realX * Main.TILE_SIZE && y != realY * Main.TILE_SIZE;
	}
	
	public function checkCollision(dx, dy) : Bool {
		var mapData = @:privateAccess Main.instance.mapData;
		var bombMap = @:privateAccess Main.instance.bombMap;
		var checkX = realX + dx;
		var checkY = realY + dy;
		if (mapData[checkY][checkX] != 1) {
			return true;
		}
		if (bombMap.exists('$checkX-$checkY')) {
			return true;
		}
		return false;
	}
	
	public inline function distancePerFrame() : Float {
		return Main.TILE_SIZE / MOVE_SPEED;
	}
	
	public function updateMove() {
		if (x < realX * Main.TILE_SIZE) {
			x += distancePerFrame();
			if (x > realX * Main.TILE_SIZE) x = realX * Main.TILE_SIZE;
		}
		if (x > realX * Main.TILE_SIZE) {
			x -= distancePerFrame();
			if (x < realX * Main.TILE_SIZE) x = realX * Main.TILE_SIZE;
		}
		if (y > realY * Main.TILE_SIZE) {
			y -= distancePerFrame();
			if (y < realY * Main.TILE_SIZE) y = realY * Main.TILE_SIZE;
		}
		if (y < realY * Main.TILE_SIZE) {
			y += distancePerFrame();
			if (y > realY * Main.TILE_SIZE) y = realY * Main.TILE_SIZE;
		}
	}
	
	public function update() : Void {
		if (idleCount > 0) {
			idleCount--;
		} else {
			idleCount = MAX_IDLE_COUNT;
			id = id != 4 ? 4 : 5;
		}
		updateMove();
		
	}

}