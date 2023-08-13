import 'dart:async';
import 'package:flame/components.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:flutter_first_game/actors/player.dart';

class LevelOne extends World {
  late TiledComponent level;

  @override
  FutureOr<void> onLoad() async {
    //do not write whole path for this line. Flame automatically put assets/tiles/ on behalf of you
    level = await TiledComponent.load('Level_1.tmx', Vector2(16, 16));

    add(level);

    final spawnPoints = level.tileMap.getLayer<ObjectGroup>('SpawnPoint');

    for (var each in spawnPoints?.objects ?? <TiledObject>[]) {
      switch (each.class_) {
        case "Player":
          final player = Player(character: "Mask Dude", position: Vector2(each.x, each.y));
          add(player);
          break;
      }
    }

    return super.onLoad();
  }
}
