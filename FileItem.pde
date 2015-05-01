// Code from Visualizing Data, First Edition, Copyright 2008 Ben Fry.


class FileItem extends SimpleMapItem {
  FolderItem parent;    
  File file;
  String name;
  String path;
  String lessText;
  String[] thisText;
  String[] fileDecider;
  PImage img;
  int level;
  
  color c;
  float hue;
  float brightness;
    
  float textPadding = 8;
    
  float boxLeft, boxTop;
  float boxRight, boxBottom;


  FileItem(FolderItem parent, File file, int level, int order) {
    this.parent = parent;
    this.file = file;
    this.order = order;
    this.level = level;
      
    name = file.getName();
    size = file.length();
    path = file.getAbsolutePath();
    if(name.endsWith("jpg") || name.endsWith("png")) {
    img = loadImage(path);
    }
    if(name.endsWith("txt")) {
      thisText = loadStrings(path);
      if(thisText != null) {
        //lessText = thisText[0];
        for(int i=0; i <= 2; i++) {
          lessText += (thisText[i] + " ");
        }
      }
    }
    //}
    
    modTimes.add(file.lastModified());
  }

  
  void updateColors() {
    if (parent != null) {
      hue = map(order, 0, parent.getItemCount(), 0, 360);
    }
    brightness = modTimes.percentile(file.lastModified()) * 100;

    colorMode(HSB, 360, 100, 100);
    if (parent == zoomItem) {
      c = color(hue, 80, 80);
    } else if (parent != null) {
      c = color(parent.hue, 80, brightness);
    }
    colorMode(RGB, 255);
  }
  
  
  void calcBox() {
    boxLeft = zoomBounds.spanX(x, 0, width);
    boxRight = zoomBounds.spanX(x+w, 0, width);
    boxTop = zoomBounds.spanY(y, 0, height);
    boxBottom = zoomBounds.spanY(y+h, 0, height);
  }


  void draw() {
    calcBox();

    fill(c);
    rect(boxLeft, boxTop, boxRight, boxBottom);
    if(img != null) {
      image(img, boxLeft, boxTop);
    }
    if(lessText != null) {
      textAlign(LEFT);
      fill(255);
      text(lessText, boxLeft, boxTop,boxRight,boxBottom);
      //fill(100);
      //rect(boxLeft,boxBottom-(height-20),boxright,boxTop
    }
    if (textFits()) {
      drawTitle();
    } else if (mouseInside()) {
      rolloverItem = this;
    }
   }
    
    
  void drawTitle() {
    fill(255, 200);
    
    float middleX = (boxLeft + boxRight) / 2;
    float middleY = (boxTop + boxBottom) / 2;
    if (middleX > 0 && middleX < width && middleY > 0 && middleY < height) {
      if (boxLeft + textWidth(name) + textPadding*2 > width) {
        textAlign(RIGHT);
        text(name, width - textPadding, boxBottom - textPadding);
      } else {
        textAlign(LEFT);
        text(name, boxLeft + textPadding, boxBottom - textPadding);
      }
    }
  }


  boolean textFits() {
    float wide = textWidth(name) + textPadding*2;
    float high = textAscent() + textDescent() + textPadding*2;
    return (boxRight - boxLeft > wide) && (boxBottom - boxTop > high); 
  }
    
 
  boolean mouseInside() {
    return (mouseX > boxLeft && mouseX < boxRight && 
            mouseY > boxTop && mouseY < boxBottom);    
  }


  boolean mousePressed() {
    if (mouseInside()) {
      if (mouseButton == LEFT) {
        parent.zoomIn();
        if(name.endsWith("exe") || name.endsWith("jpg") || name.endsWith("png") || name.endsWith("txt"));
        {
          open(path);
        }
        return true;

      } else if (mouseButton == RIGHT) {
        if (parent == zoomItem) {
          parent.zoomOut();
        } else {
          parent.hideContents();
        }
        return true;
      }
    }
    return false;
  }
}
