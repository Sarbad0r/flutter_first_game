import 'dart:async';

import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

enum PlayerDirection { left, right, none, jump, fall }

//if sprite has a lot of animations use this class to extend
class Player extends SpriteAnimationGroupComponent
    with HasGameRef<PixelAdventure>, KeyboardHandler {
  String character;

  Player({Vector2? position, required this.character})
      : super(position: position); //init position of sprite with super

  PlayerDirection playerDirection = PlayerDirection.none;
  double moveSpeed = 100;
  Vector2 velocity = Vector2.zero();
  bool isFacingRight = true;

  late final SpriteAnimation spriteAnimation;
  late final SpriteAnimation runningSpriteAnimation;
  late final SpriteAnimation jumpSpriteAnimation;
  late final SpriteAnimation doubleJumpSpriteAnim;
  late final SpriteAnimation fallSpriteAnimation;
  late final SpriteAnimation hitSpriteAnimation;
  late final SpriteAnimation wallJumpSpriteAnimation;

  final double stepTime = 0.05;

  double horizontalDirection = 0;
  double verticalDirection = 0;

  bool isWorkingTwice = false;

  @override
  FutureOr<void> onLoad() async {
    _loadAllAnimations(); //function for loading player
    return super.onLoad();
  }

  @override
  void update(double dt) {
    velocity = Vector2(horizontalDirection, verticalDirection);

    position += velocity * dt;

    super.update(dt);
    if (horizontalDirection < 0 && scale.x > 0) {
      flipHorizontallyAroundCenter();
      current = PlayerStates.running;
    } else if (horizontalDirection > 0 && scale.x < 0) {
      flipHorizontallyAroundCenter();
      current = PlayerStates.running;
    } else if (verticalDirection < 0) {
      current = PlayerStates.jump;
    }
  }

  @override
  bool onKeyEvent(RawKeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    if (clickedUp) return false;
    if (isWorkingTwice) return false;
    isWorkingTwice = true;
    horizontalDirection = 0;

    if (keysPressed.contains(LogicalKeyboardKey.keyA) ||
        keysPressed.contains(LogicalKeyboardKey.arrowLeft)) {
      horizontalDirection = -100;
    } else if (keysPressed.contains(LogicalKeyboardKey.keyD) ||
        keysPressed.contains(LogicalKeyboardKey.arrowRight)) {
      horizontalDirection = 100;
    } else if (keysPressed.contains(LogicalKeyboardKey.keyW) ||
        keysPressed.contains(LogicalKeyboardKey.arrowUp)) {
      verticalDirection = -100;
      fall();
    }  else {
      horizontalDirection = 0;
      verticalDirection = 0;
      current = PlayerStates.idle;
    }

    workingTwiceEventChecker();
    return true;
  }

  void workingTwiceEventChecker() async {
    await Future.delayed(Duration.zero);
    isWorkingTwice = false;
  }

  bool clickedUp = false;

  void fall() async {
    await Future.delayed(const Duration(milliseconds: 300));
    verticalDirection = 100;
    await Future.delayed(const Duration(milliseconds: 300));
    verticalDirection = 0;
    current = PlayerStates.idle;
    clickedUp = false;
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
