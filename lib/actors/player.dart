import 'dart:async';

import 'package:flame/components.dart';
import 'package:flutter_first_game/pixel_adventure.dart';

enum PlayerStates {
  idle,
  running,
  jump,
  doubleJump,
  fall,
  hit,
  wallJump,
}

//if sprite has a lot of animations use this class to extend
class Player extends SpriteAnimationGroupComponent with HasGameRef<PixelAdventure> {
  String character;

  Player({Vector2? position, required this.character}) : super(position: position); //init position of sprite with super

  late final SpriteAnimation spriteAnimation;
  late final SpriteAnimation runningSpriteAnimation;
  late final SpriteAnimation jumpSpriteAnimation;
  late final SpriteAnimation doubleJumpSpriteAnim;
  late final SpriteAnimation fallSpriteAnimation;
  late final SpriteAnimation hitSpriteAnimation;
  late final SpriteAnimation wallJumpSpriteAnimation;

  final double stepTime = 0.05;

  @override
  FutureOr<void> onLoad() async {
    _loadAllAnimations(); //function for loading player

    return super.onLoad();
  }

  void _loadAllAnimations() async {
    //load idle animation
    spriteAnimation = _spriteAnimation(animType: "Idle", amount: 11);

    //load running animation
    runningSpriteAnimation = _spriteAnimation(animType: "Run", amount: 12);

    //load jumping animation
    jumpSpriteAnimation = _spriteAnimation(animType: "Jump", amount: 1);

    //load double jump anim
    doubleJumpSpriteAnim = _spriteAnimation(animType: "Double Jump", amount: 6);

    //load fall anim
    fallSpriteAnimation = _spriteAnimation(animType: "Fall", amount: 1);

    //load hit anim
    hitSpriteAnimation = _spriteAnimation(animType: "Hit", amount: 7);

    wallJumpSpriteAnimation = _spriteAnimation(animType: "Wall Jump", amount: 5);

    //list of all animations that takes -> Map<dynamic, SpriteAnimation?>
    animations = {
      PlayerStates.idle: spriteAnimation,
      PlayerStates.running: runningSpriteAnimation,
      PlayerStates.jump: jumpSpriteAnimation,
      PlayerStates.doubleJump: doubleJumpSpriteAnim,
      PlayerStates.fall: fallSpriteAnimation,
      PlayerStates.hit: hitSpriteAnimation,
      PlayerStates.wallJump: wallJumpSpriteAnimation
    };

    //set current animation
    current = PlayerStates.idle;
  }

  SpriteAnimation _spriteAnimation({required String animType, required int amount}) {
    return SpriteAnimation.fromFrameData(
        game.images.fromCache('Main Characters/$character/$animType (32x32).png'), //sprite path
        SpriteAnimationData.sequenced(
          amount: amount, //all moves inside of image
          stepTime: stepTime, // time for changing moves inside of image
          textureSize:
              Vector2.all(32), //image size (as our image is 32x32) we set image as all sides are 32
        ));
  }
}
