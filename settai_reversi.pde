int c_width = 0, c_height = 0; // セルの幅と高さ
int c_stroke = 10; // セルの線の太さ
int s_diam = 0; // 石の直径
int s_stroke = 4; // 石の線の太さ

Stone s1, s2;

void setup()
{
  frameRate(30);
  //fullScreen(P3D);
  size(1280, 640, P3D);
  calcSize();

  s1 = new Stone(1, 1);
  s2 = new Stone(4, 8);
}

void draw()
{
  dispBoard();
  dispStone(s1);
  dispStone(s2);
}

void calcSize()
{
 c_height = (int)(height / 2 * 0.22); // 最後の係数でマス目のサイズを調整、0.2～0.25の間で指定。0.25で画面高さにぴったり。
 c_width = c_height;
 c_stroke = (int)(width * 0.004);
 s_diam = (int)(c_height * 0.8); // 石の大きさはマス目に対して80%とする。
 s_stroke = (int)(width * 0.002);

 println("c_stroke: " + c_stroke + " | s_stroke: " + s_stroke);
}

void dispBoard()
{
  // 背景の描画
  color background_color = color(211, 211, 211);
  background(background_color);

  // マス目の描画
  color cell_color = color(34, 139, 34);
  fill(cell_color);
  strokeWeight(c_stroke);
  stroke(0);
  for (int i = -4; i < 4; i++) {
    for (int j = -4; j < 4; j++) {
      int x = (int)(width / 2) + (c_width * i);
      int y = (int)(height / 2) + (c_height * j);
      rect(x, y, c_width, c_height);
    }
  }
}

void dispStone(Stone s)
{
  // マス目の始点（左上）から石の位置*マス目の幅の分だけ右に動かして描画する
  int draw_x = (int)(width / 2) + (c_width * -4) + (s.x - 1) * c_width + (int)(c_width / 2);
  // マス目の始点（左上）から石の位置*マス目の高さの分だけ下に動かして描画する
  int draw_y = (int)(height / 2) + (c_height * -4) + (s.y - 1) * c_height + (int)(c_height / 2);

  color stone_color = color(255);
  fill(stone_color);
  //noStroke();
  strokeWeight(s_stroke);
  stroke(0);
  ellipse(draw_x, draw_y, s_diam, s_diam);
}

void mouseReleased()
{
  println("click.");
}