// these values are "static," which means they do not change.
static int rotationStyle_360degrees=0;
static int rotationStyle_leftRight=1;
static int rotationStyle_dontRotate=2;
static int upArrow=0;
static int downArrow=1;
static int leftArrow=2;
static int rightArrow=3;
// These arrays contain boolean values for each key and arrow key
boolean[] keyIsDown = new boolean[256];
boolean[] arrowIsDown = new boolean[4];
int enemyMoveTimer = 20;
int shieldTimeout = 0;
int health = 50;
int shieldDelay = 0;
int damage = int(random(5));

// User variables and objects are "declared", or listed, here.
// Our sample includes one Stage object, called stage, and one Sprite object, called cat.
Stage stage;
Sprite cat;
Sprite bulletTheCat;
Sprite enemyLaser;
Sprite[] enemies = new Sprite[25];
ArrayList<Sprite> playerLasers = new ArrayList<Sprite>();
int laserTimeout = 0;
ArrayList<Sprite>enemyLasers = new ArrayList<Sprite>();

String  gamestate = "title";


// Setup runs once, and sets some default values
void setup() {
  // first, create a Processing window 500 px by 500 px
  size(500, 500);
  // next, initialize a Stage object with the X-Y grid backdrop
  stage = new Stage(this);
  stage .addBackdrop("images/Title.png");
  stage .addBackdrop ("images/Gameover.png");
  stage .addBackdrop ("images/Star Blue.jpg");
stage .setBackdrop(1);
  // now add a "cat" Sprite object & attach it to our stage. Go to the center of the screen.
  cat = new Sprite(this, stage);
  cat.addCostume("images/rebel.png");
  cat.addCostume("images/rebelshield.png");
  cat.goToXY(width/2, height/2);
  bulletTheCat = new Sprite(this, stage);
  bulletTheCat.addCostume("images/mega buster.png");
  bulletTheCat.hide();
  for (int i=0; i<25; i++) {
    enemies[i] = new Sprite(this, stage);
    enemies[i] .addCostume("images/megman.png");
    enemies[i].goToXY( (i % 5)*50, (int)(i / 5) * 50);
    enemies[i].size = 100;
  }
 
  enemyLaser = new Sprite(this, stage);
  enemyLaser .addCostume("images/mega buster.png");

  enemyLaser.size = 100 ;
}
void updateenemy() {
  for (int i = 0; i < 25; i++) {
    if (enemyMoveTimer == 0) {
      enemyMoveTimer = 20;
      enemies[i].move(10);
      if (enemies[i].pos.x > width || enemies[i].pos.x < 0)enemies[i].direction +=180;
      if (enemies[i].visible && !enemyLaser.visible);
      if (random(0, 100) < 15) {
        fireEnemyLaser(enemies[i].pos.x, enemies[i].pos.y);
        //println("fire enemy");
      }
    } else {
      enemyMoveTimer--;
    }
    enemies[i].draw();
  }
}

void fireEnemyLaser(float laserX, float laserY) {
  if (enemyLasers.size()<3) {
    int newLaser=enemyLasers.size();
    enemyLasers.add(new Sprite(this, stage));
    enemyLasers.get(newLaser).addCostume("images/mega buster.png");
    enemyLasers.get(newLaser).size=100;
    enemyLasers.get(newLaser).pos.x = laserX;
    enemyLasers.get(newLaser).pos.y = laserY;
    enemyLasers.get(newLaser).direction = 270;
  }
}
void moveEnemyLaser() {
  boolean removeThis = false;
  for (int currentLaser = 0; currentLaser < enemyLasers.size (); currentLaser++) {
    enemyLasers.get(currentLaser).move(4);
    //println("enemy laser "+currentLaser+" at "+enemyLasers.get(currentLaser).pos.x+","+enemyLasers.get(currentLaser).pos.y);
    if (enemyLasers.get(currentLaser).touchingSprite(cat)) {
      removeThis= true;
      if (cat.costumeNumber==0){
        health-=damage;
      }
    }
    if (enemyLasers.get(currentLaser).pos.y>height){
      
      removeThis=true;


    }
  

    if (removeThis) {
      enemyLasers.remove(currentLaser);
      currentLaser--;
      removeThis = false;
    } else enemyLasers.get(currentLaser).draw();
  }
}









void updateEnemyLaser() {
  enemyLaser.move(5);
  if (enemyLaser.touchingSprite(cat)) {
    enemyLaser.hide();
  }
  if (enemyLaser.pos.y > height)
    enemyLaser.hide();
  enemyLaser.draw();
}






void fireBulletTheCat() {
  bulletTheCat.goToSprite(cat);
  bulletTheCat.show();
  bulletTheCat.direction= 90;
}

void moveBullet() {
  bulletTheCat.move(5);
  if (bulletTheCat.pos.x < 0) bulletTheCat.hide();
  bulletTheCat.draw();
}


void moveCatByKeyboard() {
  if (arrowIsDown[upArrow] && arrowIsDown[upArrow]) cat.changeXY(-10, -10);
  else if (arrowIsDown[rightArrow] && arrowIsDown[upArrow]) cat.changeXY(10, -10);
  else if (arrowIsDown[leftArrow] && arrowIsDown[upArrow]) cat.changeXY(-10, -10);
  else if (arrowIsDown[downArrow] && arrowIsDown[upArrow]) cat.changeXY(10, -10);
  else if (arrowIsDown[leftArrow] && arrowIsDown[downArrow]) cat.changeXY(-10, 10);
  else  if (arrowIsDown[rightArrow] && arrowIsDown[downArrow]) cat.changeXY(10, 10);
  else  if (arrowIsDown[leftArrow] && arrowIsDown[rightArrow]) cat.changeXY(-10, 10);
  else if (arrowIsDown[upArrow]) cat.changeY(-10);
  else if (arrowIsDown[downArrow]) cat.changeY(10);
  else if (arrowIsDown[leftArrow]) cat.changeX(-10);
  else if (arrowIsDown[rightArrow]) cat.changeX(10);
}

void moveCatByMouse() {
  cat.goToXY(mouseX, mouseY);
          if (health<1) gamestate="gameover";

}

void updatePlayerlaser() {
  if ( bulletTheCat.visible) {
    bulletTheCat.move(5);

    for (int i=0; i<25; i++) {
      if (bulletTheCat.touchingSprite(enemies[i])) {
        bulletTheCat.hide();
        enemies[i].hide();
      }




      if (bulletTheCat.pos.y < 0)bulletTheCat.hide();
      bulletTheCat.draw();
    }
  }
}

void draw() {
  if (gamestate=="title") drawTitleLoop();
  if (gamestate == "playing" || gamestate == "demo") gameloop();
  if (gamestate=="gameover")drawGameOverLoop(); 
}
void drawTitleLoop (){
  stage.setBackdrop(0);
  stage.draw();
}
void drawGameOverLoop() {
  stage.setBackdrop(1);
  stage.draw();
}


void gameloop() {
  updatePlayerlaser();
  moveCatByMouse();
  moveCatByKeyboard();
  updateenemy();
  updateEnemyLaser();
  moveEnemyLaser();
  updateShield();
//enableShields();
if (keyIsDown['s'] ==true && shieldDelay==0) enableShields();




  moveBullet();
  cat.wrapAtEdges(); // if the cat is off one edge, reappear at the opposite end
  // check letter keys & adjust visual effects
  if (keyIsDown['a']) cat.colorEffect ++;
  if (keyIsDown['w']) cat.ghostEffect ++;
  if (keyIsDown['s']) cat.ghostEffect --;
  if (keyIsDown['d']) cat.colorEffect --;
  // finally, draw the stage and then draw the cat 
  stage.draw();
  cat.draw();
  println(shieldDelay);
  textSize(20);
fill(0,153,0);
text("Health: " + health, 390, 490);
fill(0,225,225);
text("Shield Time Left: " + shieldTimeout, 10, 490);
}

// the code below is essential for certain Scratching functions. Do not change keyPressed
// or keyReleased - unless you're absolute sure you know what you're doing!
void toggleGameMode(){
  if (gamestate=="title") { gamestate = "playing"; stage .setBackdrop(2);}
  if (gamestate=="game over") gamestate = "title";
  
}

void keyPressed() {
  if (keyIsDown['t']==true) cat.penDown = !cat.penDown;
  if (keyIsDown['1']==true) cat.penColor (255, 0, 0);
  if (stage.askingQuestion) stage.questionKeycheck();
  if (keyIsDown['s'] ==true) enableShields();
  if (key<256) {
    keyIsDown[key] = true;
    if (keyIsDown['u']) fireBulletTheCat();
    if  (key==' ') toggleGameMode();
  }
  if (key==CODED) {
    switch (keyCode) {
    case UP: 
      arrowIsDown[upArrow]=true; 
      break;
    case DOWN: 
      arrowIsDown[downArrow]=true; 
      break;
    case LEFT: 
      arrowIsDown[leftArrow]=true;  
      break;
    case RIGHT: 
      arrowIsDown[rightArrow]=true; 
      break;
    }
  }
}
void enableShields() {
  println("Switch Costume");
  shieldTimeout = 300;
  shieldDelay = 600;
  
  //cat.setCostume(1);
}

void updateShield(){
if (shieldTimeout>0) {
  cat.setCostume(1);
  shieldTimeout--;
  
}
if (shieldDelay>0){
  shieldDelay--;
}
if (shieldTimeout == 0) cat.setCostume(0);
}
// the code below is essential for certain Scratching functions. Do not change keyPressed
// or keyReleased - unless you're absolute sure you know what you're doing!
void keyReleased() {
  if (key<256) {
    keyIsDown[key] = false;
  }
  if (key==CODED) {
    switch (keyCode) {
    case UP: 
      arrowIsDown[upArrow]=false; 
      break;
    case DOWN: 
      arrowIsDown[downArrow]=false; 
      break;
    case LEFT: 
      arrowIsDown[leftArrow]=false;  
      break;
    case RIGHT: 
      arrowIsDown[rightArrow]=false; 
      break;
    }
  }
}

void firePlayerLaser() {
  if (laserTimeout>0) {
  } else if (playerLasers.size()<1) { 
    playerLasers.add(new Sprite(this, stage));
    playerLasers.get(playerLasers.size()-1).addCostume("images/mega buster.png");
    playerLasers.get(playerLasers.size()-1).size=300;
    playerLasers.get(playerLasers.size()-1).pos.x = bulletTheCat.pos.x;
    playerLasers.get(playerLasers.size()-1).pos.y = bulletTheCat.pos.y;
    playerLasers.get(playerLasers.size()-1).direction = 90;
    laserTimeout = 35;
  }
}

