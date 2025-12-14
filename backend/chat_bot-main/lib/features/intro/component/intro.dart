import 'package:smart_home/gen/assets.gen.dart';

class Intro {
  final String animationPath;
  final String title;
  final String description;
  final bool isLast;
  Intro({
    required this.animationPath,
    this.title = '',
    this.description = '',
    this.isLast = false,
  });

  factory Intro.first() {
    return Intro(
      animationPath: Assets.images.robotImage.path,
      title: ' Unlock the Power Of Future AI',
      description: 'Chat with the smartest AI Future Experience power of AI with us',
    );
  }
  factory Intro.second() {
    return Intro(
      animationPath: Assets.images.roboImage.path,
      title: '   Chat With Your Favourite Ai',
      description: 'Chat with the smartest AI Future Experience power of AI with us',
    );
  }
  factory Intro.third() {
    return Intro(
      animationPath: Assets.images.robotImg.path,
      title: 'Boost Your Mind Power with Ai',
      description: 'Chat with the smartest AI Future Experience power of AI with us',
    );
  }
  factory Intro.fourth(){
    return Intro(
      animationPath: Assets.images.logo.path,
      title: 'Welcome to BrainBot',
      isLast: true,
    );
  }
}
