import de.bezier.guido.*;
private int NUM_ROWS = 20;
private int NUM_COLS = 20;
private int NUM_MINES = 40;

//Declare and initialize constants NUM_ROWS and NUM_COLS = 20
private MSButton[][] buttons; //2d array of minesweeper buttons
private ArrayList <MSButton> mines = new ArrayList <MSButton>(); //ArrayList of just the minesweeper buttons that are mined

void setup ()
{
  size(800, 800);
  textAlign(CENTER, CENTER);

  // make the manager
  Interactive.make( this );    
  //your code to initialize buttons goes here
  buttons = new MSButton[NUM_ROWS][NUM_COLS];

  for (int r = 0; r < NUM_ROWS; r++)
    for (int c = 0; c < NUM_COLS; c++)
      buttons[r][c] = new MSButton(r, c);
 setMines();

}
public void setMines()
{
  while (mines.size() < NUM_MINES) {
    int r = (int)(Math.random()*NUM_ROWS);
    int c = (int)(Math.random()*NUM_COLS);
    if (mines.contains(buttons[r][c]) == false) {
      mines.add(buttons[r][c]);
    }
  }

}

public void draw ()
{
  background( 0 );
    
  if (isWon() == true)
    displayWinningMessage();
}
public boolean isWon()
{
  int clicks = 0;
  int flaggedMines = 0;
  int nonMine = (NUM_ROWS*NUM_COLS)-NUM_MINES;
   for(int j = 0; j < NUM_ROWS;j++){
       for(int i = 0; i < NUM_COLS;i++){
           if(!mines.contains(buttons[j][i]) &&  buttons[j][i].clicked)
              clicks++;
                if(mines.contains(buttons[j][i]) && buttons[j][i].flagged)
                flaggedMines++;
       }
   }
  if(clicks == nonMine && flaggedMines == NUM_MINES)
  return true;
  else
  return false;
}
public void displayLosingMessage()
{
  stroke(255, 0, 0);
  String [][] lose = {{"Y","O", "U"}, {"L", "O","S","E"},{"S","O"},{"S","A","D"}};
     for(int j = 0; j < NUM_ROWS;j++)
       for(int i = 0; i < NUM_COLS;i++)
           if(mines.contains(buttons[j][i]))
              buttons[j][i].clicked = true;
            
     for(int r = 0; r < lose.length;r++)
       for(int c = 0; c < lose[r].length;c++)
         buttons[r+(NUM_ROWS/2)-2][c+(NUM_COLS/2)-2].setLabel(lose[r][c]); 
   
}
public void displayWinningMessage()
{
  String [][] win = {{"Y","O", "U"}, {"W", "I","N"},{"G","O","O","D"},{"F","O","R"}, {"Y", "O", "U"}};
  for(int r = 0; r < win.length;r++)
       for(int c = 0; c < win[r].length;c++)
         buttons[r+(NUM_ROWS/2)-2][c+(NUM_COLS/2)-2].setLabel(win[r][c]); 
}
public boolean isValid(int r, int c)
{
  if (r >= 0 && r < NUM_ROWS && c >= 0 && c < NUM_COLS)
    return true;
  return false;
}
public int countMines(int row, int col)
{
  int numMines = 0;
  for (int r = -1; r < 2; r++)
    for (int c = -1; c < 2; c++)
      if (isValid(row+r, col+c) && mines.contains(buttons[row+r][col+c]))
        numMines++;

  return numMines;
}
public void keyPressed(){
 if(key == 'r'){
    for(int j = 0; j < NUM_ROWS;j++){
       for(int i = 0; i < NUM_COLS;i++){
         buttons[j][i].clicked = false;
         buttons[j][i].flagged = false;
         buttons[j][i].myLabel = "";
         stroke(0);
       }
      for(int r = 0; r < NUM_ROWS;r++){
       for(int c = 0; c < NUM_COLS;c++){
           if(mines.contains(buttons[r][c]))
              mines.remove(buttons[r][c]);
       }
      }
    }
   setMines();
 }
}
public class MSButton
{
  private int myRow, myCol;
  private float x, y, width, height;
  private boolean clicked, flagged;
  private String myLabel;

  public MSButton ( int row, int col )
  {
    width = 800/NUM_COLS;
    height = 800/NUM_ROWS;
    myRow = row;
    myCol = col; 
    x = myCol*width;
    y = myRow*height;
    myLabel = "";
    flagged = clicked = false;
    Interactive.add( this ); // register it with the manager
  }

  // called by manager
  public void mousePressed () 
  {
    clicked = true;
   
    if (mouseButton == RIGHT) {
      if (flagged)
        flagged = false;
      else
        flagged = true;
    } else if (mines.contains(this)) {
      displayLosingMessage();
    } else if (countMines(myRow, myCol) > 0) {
      setLabel(countMines(myRow, myCol));
    } else {
      //up
      if (isValid(myRow-1, myCol) && buttons[myRow-1][myCol].clicked == false) {
        buttons[myRow-1][myCol].mousePressed();
      }
      //upper left
      if (isValid(myRow-1, myCol-1) && buttons[myRow-1][myCol-1].clicked == false) {
        buttons[myRow-1][myCol-1].mousePressed();
      }
      //down
      if (isValid(myRow+1, myCol) && buttons[myRow+1][myCol].clicked == false) {
        buttons[myRow+1][myCol].mousePressed();
      }
      //lower right
      if (isValid(myRow+1, myCol+1) && buttons[myRow+1][myCol+1].clicked == false) {
        buttons[myRow+1][myCol+1].mousePressed();
      }
      //lower left
      if (isValid(myRow+1, myCol-1) && buttons[myRow+1][myCol-1].clicked == false) {
        buttons[myRow+1][myCol-1].mousePressed();
      }
      //upper right
      if (isValid(myRow-1, myCol+1) && buttons[myRow-1][myCol+1].clicked == false) {
        buttons[myRow-1][myCol+1].mousePressed();
      }
      //left
      if (isValid(myRow, myCol-1) && buttons[myRow][myCol-1].clicked == false) {
        buttons[myRow][myCol-1].mousePressed();
      }
      //right
      if (isValid(myRow, myCol+1) && buttons[myRow][myCol+1].clicked == false&& countMines(myRow, myCol+1) == 0) {
        buttons[myRow][myCol-1].mousePressed();
      }
    }
    //your code here
  }
  public void draw () 
  {    
    if (flagged)
      fill(0);
    else if ( clicked && mines.contains(this) ) 
      fill(255, 0, 0);
    else if (clicked)
      fill( 200 );
    else 
    fill( 100 );

    rect(x, y, width, height);
    fill(0);
    text(myLabel, x+width/2, y+height/2);
  }
  public void setLabel(String newLabel)
  {
    myLabel = newLabel;
  }
  public void setLabel(int newLabel)
  {
    myLabel = ""+ newLabel;
  }
  public boolean isFlagged()
  {
    return flagged;
  }
}
