int c_width = 0, c_height = 0; // セルの幅と高さ
int c_stroke = 10; // セルの線の太さ
int s_diam = 0; // 石の直径
int s_stroke = 4; // 石の線の太さ

final int MY_STATUS = 1; // 自分の石を表すステータス
final int ENEMY_STATUS = -1; // 相手の石を表すステータス

int[][] cells = {
  {0, 0, 0, 0, 1, 0, 0, 0},
  {0, 0, 0, 0, -1, 0, 0, 0},
  {0, 0, 0, -1, -1, 0, 1, 0},
  {0, 0, 0, 1, -1, -1, 0, 0},
  {0, 0, 1, -1, 0, -1, -1, 1},
  {0, 0, 0, -1, -1, 0, 0, 0},
  {0, 0, -1, 0, 1, 0, 0, 0},
  {0, 1, 0, 0, 0, 0, 0, 0}
};

ArrayList<Stone> stones = new ArrayList<Stone>();

boolean isFlipped = false;
ArrayList targets;
int count = 0;

void setup()
{
  frameRate(30);
  //fullScreen(P3D);
  size(1024, 640, P3D);
  calcSize();
  init();  
}

void draw()
{
  if (isFlipped == true) {
    animatedStones();
  }

  dispBoard();

  for (Stone s : stones) {
    dispStone(s);
  }
}

void init()
{
  // 初期表示
  for (int i = 0; i < 8; i++) {
    for (int j = 0; j < 8; j++) {
      if (cells[j][i] == MY_STATUS) {
        stones.add(new Stone(i, j, MY_STATUS));
      } else if (cells[j][i] == ENEMY_STATUS) {
        stones.add(new Stone(i, j, ENEMY_STATUS));
      }
    }
  }
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
  int draw_x = (int)(width / 2) + (c_width * -4) + s.x * c_width + (int)(c_width / 2);
  // マス目の始点（左上）から石の位置*マス目の高さの分だけ下に動かして描画する
  int draw_y = (int)(height / 2) + (c_height * -4) + s.y * c_height + (int)(c_height / 2);

  int draw_z = 0;

  //color stone_color = (s.status == MY_STATUS) ? color(0) : color(255);
  // 以下はデバッグ用、実際には上の1行だけでよい
  color stone_color = color(255);
  if (s.status == MY_STATUS) {
    stone_color = color(0);
  } else if (s.status == ENEMY_STATUS) {
    stone_color = color(255);
  } else if (s.status == 2) {
    stone_color = color(100);
  }
  fill(stone_color);
  strokeWeight(s_stroke);
  stroke(0);
  
  pushMatrix();
  translate(draw_x, draw_y, draw_z);
  ellipse(0, 0, s_diam, s_diam);
  popMatrix();

}

void animatedStones()
{
  // 石をひっくり返すときの演出

  // ひっくり返す石がなくなったらスキップ
  if (targets.isEmpty() == true) {
    isFlipped = false;
    count = 0;
    return;
  }

  // 一定期間ごとに石をひっくり返す演出を入れる
  if (count == 10) {
    int[] tmp = (int[])targets.get(0);
    printArray(tmp);
    for (Stone s : stones) {
      if (tmp[0] == s.x && tmp[1] == s.y) {
        s.status = 1;
      }
    }
    targets.remove(0);
    count = 0;
  }
  count++;
}

ArrayList search(int x, int y)
{
  ArrayList result = new ArrayList<int[]>();
  // 方向ごとに探索
  for (int j = -1; j <= 1; j++) {
    for (int i = -1; i <= 1; i++) {
      println("i : " + i + " j : " + j);
      result.addAll(this.searchOneDirection(x, y, i, j));
    }
  }
  return result;
}

ArrayList searchOneDirection(int x, int y, int x_direction, int y_direction)
{
  // 一方向に対して探索
  ArrayList<int[]> result = new ArrayList<int[]>();
  int next_x = x + x_direction;
  int next_y = y + y_direction;
  boolean result_tmp = enableStoneFlipped(next_x, next_y);
  while (result_tmp == true) {
    int[] tmp = {next_x, next_y};
    result.add(tmp);
    print("searched.");
    printArray(tmp);

    next_x += x_direction;
    next_y += y_direction;
    result_tmp = enableStoneFlipped(next_x, next_y);
  }
  return result;
}

boolean enableStoneFlipped(int x, int y)
{
  if (x < 0 || x >= 8 || y < 0 || y >= 8) {
    return false;
  }
  println("x : " + x + " y : " + y);

  return (cells[y][x] == ENEMY_STATUS) ? true : false; // 指定する座標が敵の石であればひっくり返せるのでtrueを返す
}

void mouseReleased()
{
  stones.add(new Stone(4, 4, MY_STATUS));
  targets = search(4, 4);

  isFlipped = true;
}