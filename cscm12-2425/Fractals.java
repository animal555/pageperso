import java.util.*;
import java.awt.*;
import javax.swing.*;

public class Fractals {

  public static void main(String[] args) 
  { 
    MyCanvas canvas = new MyCanvas();

    JFrame frame = new JFrame();
    frame.setTitle("Some fractal probably once you're done");
    frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);

    frame.getContentPane().add(canvas);
    frame.setVisible(true);
  }
}

class Turtle
{
  Graphics graphics;
  double orientation;
  int x;
  int y;


  public Turtle(Graphics g)
  {
    graphics = g;
    int height = (int)g.getClipBounds().getHeight();
    int width = (int)g.getClipBounds().getWidth();
    // By default, position the turtle in the middle of the screen facing right
    x = width/2;
    y = height/2;
    orientation = 0;
  }

  public Turtle(Graphics g, int initX, int initY, double initOrientation)
  {
    graphics = g;
    int height = (int)g.getClipBounds().getHeight();
    x = initX;
    y = height - initY;
    orientation = initOrientation;
  }
  
  public void turnLeft(double angle)
  {
    orientation += angle;
  }

  public void walk(double dist)
  {
    int nextX = x + (int)(Math.cos(orientation) * dist);
    int nextY = y - (int)(Math.sin(orientation) * dist);        
    graphics.drawLine(x,y,nextX,nextY);
    x = nextX;
    y = nextY;
  }

  public void fly(double dist)
  {
    int nextX = x + (int)(Math.cos(orientation) * dist);
    int nextY = y + (int)(Math.sin(orientation) * dist);        
    x = nextX;
    y = nextY;
  }

  public void walkEquilateralTriangle(double dist)
  {
    walk(dist);
    turnLeft(2 * Math.PI / 3);
    walk(dist);
    turnLeft(2 * Math.PI / 3);
    walk(dist);
    turnLeft(2 * Math.PI / 3);
  }

  public void turnRight()
  {
    // Your code goes there
  }

  public void turnAround()
  {
    // Your code goes there
  }

  public void randomWalk(double dist, int nbSteps)
  {
    //The next two lines are just here to remind you how to use Random
    //You can modify them :)
    Random rand = new Random();
    int randomIntegerLessThanFour = rand.nextInt() % 4;
    // Your code goes there
  }


  public void walkKoch1(double dist)
  {
    // Your code goes there
  }

  public void walkKoch(double dist, int order)
  {
    // Your code goes there
  }

  public void walkKochFlake(double dist, int order)
  {
    // Your code goes there
  }
}


class MyCanvas extends Canvas
{
  public MyCanvas()
  {
  }

  public void paint (Graphics graphics)
  {
    Graphics g = graphics;
    g.setColor(Color.BLACK);
    int width = (int)g.getClipBounds().getWidth();
    int height = (int)g.getClipBounds().getHeight();
    g.fillRect(0,0,width,height);
    g.setColor(Color.WHITE);

    // your code goes there to test your functions :)
    // what's below is for illustration

    Turtle t = new Turtle(graphics);
    t.walkEquilateralTriangle(200);
  }
}
