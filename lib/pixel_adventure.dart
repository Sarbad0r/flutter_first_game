import 'dart:async';
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter_first_game/levels/level_one.dart';

//with HasKeyboardHandlerComponents -> we saying that our game has keyboard events
class PixelAdventure extends FlameGame with HasKeyboardHandlerComponents{
  //background for our game word (for example there would be a black
  // bar for each right and left side. That is why we put background color for removing these black bars)

  @override
  Color backgroundColor() => const Color(0xFF211f30);

  //camera component for setting camera right position
  late final CameraComponent cameraComponent;

  //the world that we want to load for our game
  late final World world;

  @override
  FutureOr<void> onLoad() async {
    //load all images in cache
    await images.loadAllImages();

    //init the late world variable
    world = LevelOne(levelName: 'Level_2.tmx');
    //init the camera (Note: before creating the world in Tiled app there will show width and height of the world)
    cameraComponent = CameraComponent.withFixedResolution(width: 640, height: 360, world: world);
    //setting right position for camera
    cameraComponent.viewfinder.anchor = Anchor.topLeft;
    //add load the game in list
    //first loads camera than the world
    addAll([cameraComponent, world]);
    return super.onLoad();
  }
}
