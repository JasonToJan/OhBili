export class ResUtils {
  static getLevel(level: number): Resource {
    switch (level) {
      case 0:
        return $r('app.media.dy_level_0');
      case 1:
        return $r('app.media.dy_level_1');
      case 2:
        return $r('app.media.dy_level_2');
      case 3:
        return $r('app.media.dy_level_3');
      case 4:
        return $r('app.media.dy_level_4');
      case 5:
        return $r('app.media.dy_level_5');
      default:
        return $r('app.media.dy_level_6');
    }
  }

  static getShadowColor(color: number): number {
    let red = (color >> 16) & 0xFF
    let green = (color >> 8) & 0xFF
    let blue = color & 0xFF
    let g = red * 0.299 + green * 0.587 + blue * 0.114;
    if (g >= 192) {
      return 0x000000;
    } else {
      return 0xffffff;
    }
  }
}