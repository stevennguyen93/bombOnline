package;


import openfl.display.Sprite;
import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.geom.Rectangle;
import openfl.events.Event;
import openfl.display.Tilemap;
import openfl.display.Tileset;
import openfl.display.TileContainer;
import openfl.display.Tile;
import openfl.events.KeyboardEvent;
import openfl.ui.Keyboard;
import openfl.Assets;

class Main extends Sprite {
	
	public static inline var TILE_SIZE 	= 32;
	public static inline var MAP_WIDTH 	= 15;
	public static inline var MAP_HEIGHT = 11;

	public static var instance(default, null): Main;

	var tilemap(default, null) : Tilemap;
	var player(default, null) : Player;
	var mapData(default, null) : Array<Array<Int>>;
	var bombMap(default, null) : Map<String, Bomb> = new Map<String, Bomb>();
	var requestedDirection = Direction.NONE;

	public function new () {
		
		super ();
		
		instance = this;
		mapData = [
			[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
			[0,1,1,1,1,1,1,1,1,1,1,1,1,1,0],
			[0,1,0,1,0,1,0,1,0,1,0,1,0,1,0],
			[0,1,1,1,1,1,1,1,1,1,1,1,1,1,0],
			[0,1,0,1,0,1,0,1,0,1,0,1,0,1,0],
			[0,1,1,1,1,1,1,1,1,1,1,1,1,1,0],
			[0,1,0,1,0,1,0,1,0,1,0,1,0,1,0],
			[0,1,1,1,1,1,1,1,1,1,1,1,1,1,0],
			[0,1,0,1,0,1,0,1,0,1,0,1,0,1,0],
			[0,1,1,1,1,1,1,1,1,1,1,1,1,1,0],
			[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
		];

		var bitmapData = Assets.getBitmapData('assets/Tileset.png');
		var tileset = new Tileset(
			bitmapData,
			[
				new Rectangle(0, 0, TILE_SIZE, TILE_SIZE),						// Wall
				new Rectangle(TILE_SIZE, 0, TILE_SIZE, TILE_SIZE),				// Ground
				new Rectangle(TILE_SIZE * 2, 0, TILE_SIZE, TILE_SIZE),			// Soft-wall
				new Rectangle(0, TILE_SIZE, TILE_SIZE, TILE_SIZE),				// Bomb
				new Rectangle(TILE_SIZE, TILE_SIZE, TILE_SIZE, TILE_SIZE),  	// Player idle 1
				new Rectangle(TILE_SIZE * 2, TILE_SIZE, TILE_SIZE, TILE_SIZE), 	// Player idle 2
			]
		);

		tilemap = new Tilemap(MAP_WIDTH * TILE_SIZE, MAP_HEIGHT * TILE_SIZE, tileset, false);

		tilemap.scaleX = 2;
		tilemap.scaleY = 2;

		addChild(tilemap);
		placeRandomSoftWallToMap();
		createMapFromData(mapData);
		
		player = new Player();
		
		tilemap.addTile(player);

		addEventListener(Event.ENTER_FRAME, onUpdate);
		stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
		stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
	}
	
	public function placeRandomSoftWallToMap() : Void {
		for (j in 0...mapData.length) {
			var row = mapData[j];
			for (i in 0...row.length) {
				if (row[i] == 1) {
					if (Math.random() > 0.8) row[i] = 2;
				}
			}
		}
	}

	public function createMapFromData(mapData : Array<Array<Int>>) : Void {
		trace(mapData[0]);
		for (j in 0...mapData.length) {
			var row = mapData[j];
			for (i in 0...row.length) {
				var tile = new Tile(row[i]);
				tile.x = i * TILE_SIZE;
				tile.y = j * TILE_SIZE;
				tilemap.addTile(tile);
			}
		}
	}
	
	public function addBomb(x, y) : Void {
		var bomb = new Bomb(x, y);
		tilemap.addTile(bomb);
		tilemap.removeTile(player);
		tilemap.addTile(player);
		bombMap.set('$x-$y', bomb);
	}

	public function onKeyDown(e:KeyboardEvent) : Void {
		switch (e.keyCode) {
			case Keyboard.LEFT: requestedDirection = Direction.LEFT;
			case Keyboard.RIGHT: requestedDirection = Direction.RIGHT;
			case Keyboard.UP: requestedDirection = Direction.UP;
			case Keyboard.DOWN: requestedDirection = Direction.DOWN;
		}
		if (e.keyCode == Keyboard.SPACE) {
			addBomb(Std.int(player.realX), Std.int(player.realY));
		}
	}

	public function onKeyUp(e:KeyboardEvent) : Void {
		requestedDirection = Direction.NONE;
	}
	
	public function onUpdate(e:Event) : Void {
		if (requestedDirection != Direction.NONE) {
			player.move(requestedDirection);
			requestedDirection = Direction.NONE;
		}
		player.update();
		for (key in bombMap.keys()) {
			var bomb = bombMap.get(key);
			bomb.update();
		}
	}
	
	
}