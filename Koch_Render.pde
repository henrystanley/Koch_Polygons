// Default koch parameters
int Res = 7000;
int Iter = 11;
int PolySides = 3;
float[][] Fractures = { {0.0, -0.3}, {0.5, 0.0} };

// Line segment class
class Segment {
  
  float x, y;
  PVector to;
  
  Segment(float _x, float _y, float _tox, float _toy) {
    x = _x;
    y = _y;
    to = new PVector(_tox, _toy);
  }
  
  // Segment splitting method
  Segment[] fracture(float[][] fract) {
    Segment[] new_segs = new Segment[fract.length+1];
    float fromx = x; float fromy = y;
    for(int i = 0; i < fract.length; i++) {
      new_segs[i] = new Segment( fromx, fromy, x + (fract[i][0] * (to.x - x)), y + (fract[i][0] * (to.y - y)));
      new_segs[i].to.x = (new_segs[i].to.x) + (fract[i][1] * (to.y - y));
      new_segs[i].to.y = (new_segs[i].to.y) - (fract[i][1] * (to.x - x));
      fromx = new_segs[i].to.x;
      fromy = new_segs[i].to.y;
    }
    new_segs[new_segs.length-1] = new Segment(fromx, fromy, to.x, to.y);
    return new_segs;
  }
}

// Koch polygon class
class Poly {
  
  int n_sides, x, y;
  float size;
  float[][] fracture_pattern;
  Segment[] sides;
  
  // Constructs new polygon and calculates starting segment positions
  Poly(int _n, float _s, float[][] _f, int _x, int _y) {
    n_sides = _n;
    size = _s;
    fracture_pattern = _f;
    x = _x;
    y = _y;
    sides = new Segment[n_sides];
    if (n_sides > 1) {
      float vertex_angle = 1.0/n_sides;
      for(int i = 0; i < n_sides; i++) {
        sides[i] = new Segment(x-(size * cos(((i*vertex_angle)+0.25)*TAU)),
                               y-(size * sin(((i*vertex_angle)+0.25)*TAU)),
                               x-(size * cos((((i+1)*vertex_angle)+0.25)*TAU)),
                               y-(size * sin((((i+1)*vertex_angle)+0.25)*TAU)));
      }
    }
    // Current vertex placement technique doesn't work for n_sides=1, hence this branch
    else {
      sides[0] = new Segment(x-(size * cos(0.25*TAU)),
                             y-(size * sin(0.25*TAU)),
                             x-(size * cos(0.75*TAU)),
                             y-(size * sin(0.75*TAU)));
    }
  }
  
  // Calculates total segments after n interations
  int numOfIterSegments(int iters) {
    return int(n_sides*pow(fracture_pattern.length+1, iters));
  }
  
  // Iteration method (destructive)
  void iterate() {
   Segment[] new_sides = new Segment[sides.length*(fracture_pattern.length+1)];
   for(int k = 0; k < sides.length; k++) {
      Segment[] fractured = sides[k].fracture(fracture_pattern);
      for(int s = 0; s < fractured.length; s++) {
        new_sides[(k*(fractured.length)) + s] = fractured[s];
        //println("Calculating " + countnum + " of " + totalcalc);
      }
    }
    sides = new_sides;
  }

  // Polygon rendering method
  void render() {
    int side_num = sides.length;
    float percent = 100.0 / side_num;
    for(int i = 0; i < side_num; i++) {
      line(sides[i].x, sides[i].y, sides[i].to.x, sides[i].to.y);
      print("\rRendering segments: " + (int(i*percent)+1) + "% done...");
    }
  }
}

// Config file class
class Config {
  
  StringDict items;
  
  Config(String file_name) {
    String[] item_pairs = loadStrings(file_name);
    items = new StringDict();
    for(int i = 0; i < item_pairs.length; i++) {
      String[] pair = split(item_pairs[i], '=');
      items.set(pair[0], pair[1]);
    }
  }
  
  String value_of(String field) {
    if (items.hasKey(field)) {return items.get(field);}
    else {return "";} 
  }
}

// Parses something like this: { {0.0, -0.3}, {0.5, 0.0} }, into float[][]
// This is a working, but abhorrent function 
float[][] fractureParse(String str) {
  String top_parenths_removed = str.substring(1, str.length()-1);
  String[][] tuple_matches = matchAll(top_parenths_removed, "\\{(.*?)\\}");
  float[][] fracture_capture = new float[tuple_matches.length][2];
  for (int i = 0; i < tuple_matches.length; i++) {
    String[] tuple = split(tuple_matches[i][1], ", ");
    fracture_capture[i][0] = float(tuple[0]);
    fracture_capture[i][1] = float(tuple[1]);
  }
  return fracture_capture;
}

void setup() {
  
  // Config file reading and parsing
  Config cfg = new Config("Koch.cfg");
  String cfg_res = cfg.value_of("resolution");
  if (cfg_res != "") {Res = int(cfg_res);}
  String cfg_iter = cfg.value_of("iterations");
  if (cfg_iter != "") {Iter = int(cfg_iter);}
  String cfg_poly = cfg.value_of("polygon_sides");
  if (cfg_poly != "") {PolySides = int(cfg_poly);}
  String cfg_frac = cfg.value_of("fracture_pattern");
  if (cfg_poly != "") {Fractures = fractureParse(cfg_frac);}
  
  // Image Rendering
  size(Res, Res);
  background(30);
  stroke(255);
  fill(0);
  Poly koch_poly = new Poly(PolySides, Res*0.3, Fractures, Res/2, Res/2);
  println("Calculating Polygon...");
  for(int i = 0; i < Iter; i++) {
    koch_poly.iterate();
    print("\rDone with iteration " + (i+1) + " of " + Iter);
  }
  println("\nRendering Polygon...");
  koch_poly.render();
  println("\nSaving...");
  save("Poly.png");
  println("Done.");
  exit();
}
