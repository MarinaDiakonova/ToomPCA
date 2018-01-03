//import processing.opengl.PGraphicsOpenGL;


//DISPLAY
int w; //number of boxes  
int h;    
float screen_scale_ratio = 2.0/3.0; //desired size of app as fraction of screen
float width_as_fraction = 0.625; //fraction of app screen devoted to VISUALISATION
int neighbourhood_size = 7; //odd number needed
int network_size_max = 100;
int appw;
int apph;
int temp_w, temp_scx;
int sc, scx, scy, scnx, scny;	//for scaling the model and the neighbourhood

float weight_red, weight_blue;   //initial weight on "1's
float lambda; //probability of survival
float delta; //probability of changing colour to one of the multi-coloured majority
//boolean inertia;     //

int height_diff;

//variable declaration
int N = 3; //the default
int ndistx, ndisty; //intermediate dummy ones
int[] neighbours_x;	//hold coords of neighbourhood of influence - obviously in relative terms
int[] neighbours_y;

int B_about_x, B_about_y, B_about_width, B_about_height;

boolean bool = true;	//a true boolean
int red, blue, yellow;
int majority; //this is deterministic, so this is essentially a temp variable. 
double redav;
int shift;
Network S;
Network nNet;

PFont font;
PFont font_slider;


/*%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% BUTTONS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%*/
//round buttons
int number_RB = 3;
RoundButton RB1;
RoundButton RB2;
RoundButton RBinit;
float diameter;

//rectangular buttons
RectButton B_display_frequency;
RectButton B_framerate;
RectButton B_framerate_changed;
RectButton B_evolution_on_click;
RectButton B_change_neighbourhood;
RectButton B_set_network_size;
RectButton B_lambda;
RectButton B_inertia;
RectButton B_initial_weight_on_red;
RectButton B_initial_weight_on_blue;

//sliders
Slider S_evolution_frequency;	
Slider S_set_network_width, S_set_network_height;
Slider S_initial_weight_on_red;
Slider S_initial_weight_on_blue;
Slider S_lambda;
Slider Slidey;	//generic slider that gets re-assigned every time a slider is needed; appears in DRAW()


/*%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% MOUSEHOVER BOOLEANS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%*/
boolean RB1over;
boolean RB2over;
boolean RBinitover;
boolean B_display_frequencyover;
boolean B_framerateover;
boolean B_framerate_changedover;

/*%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% RUN BOOLEANS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%*/
boolean ready_to_run;
boolean initialised;
boolean single_iteration;
boolean change_framerate;
boolean framerate_changed;
boolean evolution_on_click;
boolean mouse_clicked;
boolean neighbourhood_mode;
boolean slider_mode;
boolean setting_width, setting_height;
boolean about_mode;

/*%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% EVOLUTION SCREEN VARIABLES %%%%%%%%%%%%%%%%%%%%%%%%%%%%%*/
int myFrameRate;
int update_frequency;
int update_ratio; 
int frameratecount;


//processingv2:
//int sh = round ( screen.height * screen_scale_ratio );
//int sw = round ( screen.width * screen_scale_ratio );

//processingv3:
int sh = round ( 870 * screen_scale_ratio );
int sw = round ( 1260 * screen_scale_ratio );

int largex, largey;

String text_about;

int b_n_x, b_n_y, b_n_w, b_n_h;
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%









//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% SETUP %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
void setup()
{
neighbours_x = new int[network_size_max]; //max prebuilt network width
neighbours_y = new int[network_size_max]; // " height

//THE NORTH-EAST SETTING AS DEFAULT
neighbours_x[0] = 0;
neighbours_y[0] = 0;

neighbours_x[1] = 0;
neighbours_y[1] = -1;

neighbours_x[2] = 1;
neighbours_y[2] = 0;


weight_red = 1.0/3.0;   //initial weight on red (zeros)
weight_blue = 1.0/3.0;   //initial weight on red (ones)
lambda = 0.05; //probability of survival
delta = 0.05;



//============= DEFAULT VARIABLES ============\\
w = 40;
h = 40;
setting_width = true;
setting_height = false; //not sure if redundant, due to sequence of IFs within mousePressed() loop


scx = floor(sw * width_as_fraction/w);
scy = floor (sh/h);
//define corresponding app width and height (height is effectively the same but width is redifined to certain ratio)
//THESE ARE VARIABLES FOR SCREEN - USE IN A CONTEXT SEPARATE TO NETWORK SIZE W AND H (OR APPROPRIATELY SCALED W AND H)
appw = sw;
apph = sh;

//scaling neighbourhood
scnx = floor(sw * width_as_fraction/(float)neighbourhood_size );
scny = floor(sh /(float)neighbourhood_size );
largex = ceil(scnx*neighbourhood_size);
largey = ceil(scny*neighbourhood_size);

height_diff = floor( (apph - scy*h)/2.0); //EXTRA HEIGHT ADDED ONE



//frequency of display - without it can't set your own EVOLUTION frequency.. 
myFrameRate = 50;
frameRate(myFrameRate);       
update_frequency = 50;
update_ratio = round((float)myFrameRate/(float)update_frequency);
frameratecount = 0;


background(0);
textAlign(CENTER,CENTER);
font = loadFont("ChaparralPro-Regular-14.vlw");	//for button and title
font_slider = loadFont("KozGoPro-Medium-14.vlw"); //for slider
textFont(font, 20);
//textMode(SCREEN);




  //Processingv2
  ////set size of application window in pixels
  //size(appw, apph, P2D);
  ////define shift in xcoord of pixel in animation screen
  //shift = round(0.25 * appw);
  
  //Processingv3
  //set size of application window in pixels
  size(850, 600, P2D);
  //define shift in xcoord of pixel in animation screen
  shift = round(0.25 * appw);
  //print(apph);
  pixelDensity(displayDensity());


//========================= INITIALISING RIGHT BUTTONS ========================\\
//x coordinates
int RBxmin = round( (7.0/8.0) * (float)appw);
float RB_diameter = round( (float)(appw - RBxmin)/2.0 );
int RB_centre = RBxmin + (int)RB_diameter;
//y coordinates
int RB_y = round( (float)apph/(float)( (number_RB) + 1) );


//----------------------BUTTONS-------------------------
//initialise/reset
RBinit = new RoundButton(RB_centre, RB_y, RB_diameter);
RBinit.settext("Reset", "Set", !ready_to_run);

//PLAY/PAUSE
RB1 = new RoundButton(RB_centre, RB_y*2, RB_diameter);
RB1.settext("Pause", "Run", !ready_to_run);

//EXIT
RB2 = new RoundButton(RB_centre, RB_y*3, RB_diameter);
RB2.settext("EXIT", "EXIT", !bool);

//------------------------------------------------------



//========================= INITIALISING LEFT BUTTONS ===========================\\
//x coordinates
int Bxmax = round( 0.25 * (float)appw);
int B_width = round ( Bxmax /2.0);
int B_xl = round( B_width / 2.0);
//y coordinates
int B_height = round( (float)apph * 0.125 *0.5);
int B_yl = round( B_height * 2.0);


//APPLICATION NAMEBOX
int namex1 = B_xl;
int namewidth = B_width;
int nameheight = round( 0.75 * B_height * 2.0);
int namey1 = round (0.125 * B_height * 2.0);
fill(255, 0, 0);
text("TOOM'S PCA", namex1, namey1, namewidth, nameheight);
//reset text font
textFont(font, 10);


//----------------------BUTTONS-------------------------
/*
 //SAMPLING OF DISPLAY - done 
 B_display_frequency = new RectButton(B_xl, B_yl, B_width, B_height);
 //B_display_frequency.settext("Displays single iteration", "Displays bi-iteration", single_iteration);
 
 //EVOLUTION ON CLICK - will work when mouse clicked over the RUN button - done
 B_evolution_on_click = new RectButton(B_xl, (B_yl + B_height + namey1), B_width, B_height);
 //B_evolution_on_click.settext("Evolution on Click (use RUN button)","Automatic Evolution", evolution_on_click);
 
 //FREQUENCY OF EVOLUTION(FRAMERATE) - done
 B_framerate = new RectButton(B_xl, B_yl + 2 *( B_height + namey1), B_width, B_height);
 //B_framerate.settext("Set Frame Rate", "Frame rate " + update_frequency, B_framerateover);
 
 //TO CHANGE NEIGHBOURHOOD - click button again to SUBMIT - done
 B_change_neighbourhood = new RectButton(B_xl, B_yl + 3 *( B_height + namey1), B_width, B_height);
 //B_change_neighbourhood.settext("DONE", "Change Neighbourhood", neighbourhood_mode); 
 
 //TO CHANGE NETWORK SIZE - click button again to SUBMIT - done 
 B_set_network_size = new RectButton(B_xl, B_yl + 4 *( B_height + namey1), B_width, B_height);
 //some sort of needless initialisation could go here
 */

//INITIAL WEIGHT ON RED
B_initial_weight_on_red = new RectButton(B_xl, B_yl, B_width, B_height);
//B_display_frequency.settext("Displays single iteration", "Displays bi-iteration", single_iteration);

//INITIAL WEIGHT ON BLUE
B_initial_weight_on_blue = new RectButton(B_xl, B_yl+ B_height + namey1, B_width, B_height);
//B_display_frequency.settext("Displays single iteration", "Displays bi-iteration", single_iteration);

//TO CHANGE NEIGHBOURHOOD - click button again to SUBMIT
b_n_x = B_xl;
b_n_y = B_yl + 2*( B_height + namey1);
b_n_w = B_width;
b_n_h = B_height;
B_change_neighbourhood = new RectButton(b_n_x, b_n_y, b_n_w, b_n_h);
//B_change_neighbourhood.settext("DONE", "Change Neighbourhood", neighbourhood_mode);

//INERTIA
//B_inertia = new RectButton(B_xl, B_yl + 2* (B_height + namey1), B_width, B_height);
//B_evolution_on_click.settext("Evolution on Click (use RUN button)","Automatic Evolution", evolution_on_click);

//LAMBDA
B_lambda = new RectButton(B_xl, B_yl + 3 *( B_height + namey1), B_width, B_height);
//B_framerate.settext("Set Frame Rate", "Frame rate " + update_frequency, B_framerateover);

//NOT A BUTTON - VISUALISATION TEXT
textFont(font, 20);
fill(255, 0, 0);
text("Visuals", B_xl, B_yl + round(4.5 *( B_height + namey1)), B_width, B_height);
textFont(font, 10);


//FREQUENCY OF EVOLUTION(FRAMERATE)
B_framerate = new RectButton(B_xl, B_yl + round(5.5 *( B_height + namey1)), B_width, B_height);
//some sort of needless initialisation could go here

//EVOLUTION ON CLICK - will work when mouse clicked over the RUN button 
B_evolution_on_click = new RectButton(B_xl, B_yl + round(6.5 *(B_height + namey1)), B_width, B_height);
//B_evolution_on_click.settext("Evolution on Click (use RUN button)","Automatic Evolution", evolution_on_click);

//SAMPLING OF DISPLAY - done 
B_display_frequency = new RectButton(B_xl, B_yl + round(7.5 *(B_height + namey1)), B_width, B_height);
//B_display_frequency.settext("Displays single iteration", "Displays bi-iteration", single_iteration);

//TO CHANGE NETWORK SIZE - click button again to SUBMIT - done 
B_set_network_size = new RectButton(B_xl, B_yl + round(8.5 *( B_height + namey1)), B_width, B_height);
//some sort of needless initialisation could go here

//NOT A BUTTON - "ABOUT" BOX
B_about_x = B_xl;
B_about_y = B_yl + 10 *( B_height + namey1);
B_about_width = B_width;
B_about_height = B_height;

textFont(font, 20);
fill(255, 0, 0);
text("About", B_about_x, B_about_y, B_about_width, B_about_height);
textFont(font, 10);

//set the text that's to appear in the middle network area when mouse is pressed.
text_about = "This application models the evolution of the state of a system consisting of (width x height) " + 
"sites. Each is described by a 'local' state that can assume three values. Update rule for any site depends " + 
"only on parameters lambda, delta, and the values of sites in neighbourhood N at the time of update. " +
"For each site, the total number of reds, blues and yellows in N is first calculated. Then a 'preferred' state " +
"is picked, based on whether N is dominated by one colour. If there are several rivaling colours, each is picked " +
" with equal probability. The site is updated to that colour. Then, the site changes colour with probability lambda; " +
" so with probability lambda/2 it becomes, say, red if it's yellow, and with probability lambda/2 it becomes blue. Updates are simultaneous. "+
"The default N is Self, North and East. No special rule is set for empty N. When changing N inclusion" +
" of Self is not automatically assumed, so would need to select the centre square. Clicking on the animation screen while the system " +
"is evolving restarts the process from the set initial condition, while using the 'SET'/'RESET' button stops it as well. The default " +
"weights are equidistributed between the three colours. " +
"Parameters etc. are updated on clicks of respective 'DONE' buttons. Click the 'About' button to get rid of this screen.";



//SLIDERS
S_evolution_frequency = new Slider(1, 100, 100, "Set Frequency of Evolution", update_frequency, B_framerate);
S_set_network_width = new Slider(1, network_size_max, network_size_max, "Set Network Width", w, B_set_network_size);	
S_set_network_height = new Slider(1, network_size_max, network_size_max, "Set Network Height", h, B_set_network_size);
S_initial_weight_on_red = new Slider(0, 1, 101, "Set Initial Weight on Red", weight_red, B_initial_weight_on_red);	
S_initial_weight_on_blue = new Slider(0, (1 - weight_red), (ceil( (1 - weight_red)*100) + 1), "Set Initial Weight on Blue", weight_blue, B_initial_weight_on_blue);
S_lambda = new Slider(0, 1, 101, "Set lambda", lambda, B_lambda);







// MOUSEOVER BOOLEANS initialised
RB1over = false;
RB2over = false;
RBinitover = false;
B_display_frequencyover = false;

//RUN BOOLEANS initialised
ready_to_run = false;
initialised = true;
change_framerate = false;
single_iteration = true;
framerate_changed = false;
evolution_on_click = false;
mouse_clicked = false;
neighbourhood_mode = false;
slider_mode = false;
about_mode = false;

rectMode(CORNER);

nNet = new Network(neighbourhood_size, neighbourhood_size);
nNet.white();

S = new Network(w,h);
print("THIS IS NOT A TEST! "); //check using print
}









//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%\\
//================================================   MAIN   ====================================================\\\
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%\\
void draw()
{
frameratecount++; //keeps track of how many frames passed (so would update only once every so many frames)

rect(shift, 0, largex, largey); 
/*the alternative to displaying a black rectange in the middle was REDRAWING the whole thing - so TITLE, 
 round buttons on right (as square ones on left get redrawn anyhow), setting and resetting stuff that 
 was used for them.. etc. IF rect isn't drawn, then, since network overall size is determined by the 'ground'
 function, and if the old network was bigger, you'd see traces of the old network in the background. Which is 
 fine, and you'd see it's not evolving, but looks awful. So picked the biggest 'thing' that appears in the 
 Network/centre space - which happens to be the 'NEIGHBOURHOOD' network, and stole it's size.*/

if (initialised) {
S.seed();
initialised = false;	//THIS WOULD BE USEFUL COS IT SETS INITIALISED AS FALSE
}
S.display(scx,scy);


if (ready_to_run && (frameratecount >= update_ratio)) {
if (!single_iteration) {
S.evolve();
}
S.evolve();
frameratecount = 0;	

if (evolution_on_click) {	//this could be nested outside the ready to run loop
ready_to_run = false;
}	
}


/*Buttons are redrawn/changed depending on whether you click them and/or where the mouse is. Hence no 
 point in initialising them to something in the setup - the displays should be updated continously
 */
B_display_frequency.settext("Displays every iteration", "Displays every other iteration", single_iteration);
B_evolution_on_click.settext("Evolution on Click (use RUN button)","Automatic Evolution", evolution_on_click);
RBinit.settext("Reset", "Set", ready_to_run);
RB1.settext("Pause", "Run", ready_to_run);
B_change_neighbourhood.settext("DONE", "Change Neighbourhood", neighbourhood_mode); 
B_framerate.settext("Set Frame Rate", "Frame rate " + update_frequency, B_framerate.over());
B_set_network_size.settext("Set Network Size", "Network size is \n" + w + " x " + h, B_set_network_size.over());
//B_inertia.settext("Inertia ON", "Inertia OFF", inertia);
double w_r = (double)ceil(100*weight_red)/100.0;
double w_b = (double)ceil(100*weight_blue)/100.0;
B_initial_weight_on_red.settext("Set Initial Weight on Red","Initial Weight \n on Red is " + w_r, B_initial_weight_on_red.over());
B_initial_weight_on_blue.settext("Set Initial Weight on Blue","Initial Weight \n on Blue is " + w_b, B_initial_weight_on_blue.over());
B_lambda.settext("Set Lambda", "Lambda is " + lambda, B_lambda.over());


/*
 This section has to come AFTER buttons are displayed, since to get OUT of slider mode one of those buttons
 will be replaced by a DONE button. In this way the DONE button is drawn AFTER the initial buttons are drawn.
 Alternatively, use 
 else
 {
 B_framerate.settext("Set Frame Rate", "Frame rate " + update_frequency, B_framerate.over());
 + other buttons which bring about the slider mode
 }
 */
if(slider_mode){
Slidey.display();
}

if(neighbourhood_mode) {
height_diff = 0; //EXTRA HEIGHT ADDED ONE
nNet.display_N(scnx,scny);
//displays square in middle
fill(0);
line(shift + (3 * scnx),3*scny, shift + (4*scnx), 4*scny);
line(shift + (4 * scnx),3*scny, shift + (3*scnx), 4*scny);


//MAKES THE "DONE" BUTTON SAME as the other DONE buttons for slider (usually they appear as part of Slidey.display())
//rectMode(CORNER);
stroke(255);
fill(0);
//THESE COORDS ARE SPECIFIC FOR THE "B_neighbours... "
rect(b_n_x, b_n_y, b_n_w, b_n_h);
fill(255, 0, 0);
text("DONE", b_n_x + round( 0.125* b_n_w),  b_n_y + round( 0.125*b_n_h), round( 0.75*b_n_w), round(0.85*b_n_h));
stroke(0);
//	rectMode(CENTER);
//	textFont(font,20);
}

//WHEN MOUSE HOVERS OVER THE 'ABOUT' TEXT, A BOX APPEARS IN THE NETWORK AREA with info about the APP
if (about_mode){
stroke(0);
fill(255);
rect(shift + appw*5/64 - 1, apph/8, appw*15/32, apph*3/4);
fill(0);
textFont(font, 14);
text(text_about, (shift + appw*5/64 + 5), apph/8, (appw*15/32 - 5), apph*3/4);
textFont(font, 10);
}
}
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%\\
//================================================  END MAIN  ===================================================\\
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%\\














//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%\\
//================================================  CLASSES  ====================================================\\
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%\\
// Network class consists of two 2D arrays, one with values ("network"), one for storing information to allow for simulatenous update ("sum").
class Network 
	{
		int x;
		int y;
		int [] [] network;
		int [] [] temp;
		
		Network(int xin, int yin) 
		{
			x = xin;
			y = yin;
			network = new int [x] [y];
			temp = new int [x] [y];    
		}
		
		void white()	//FOR NEIGHBOURHOOD NETWORK - THIS THING EFFECTIVELY ASSIGNS zero values so NOT display purpose
		{
			for (int i = 0; i < x; i++) {  
				for (int j = 0; j < y; j++) {  //for each node
					network[i][j] = 0; 
				}
			}
			
		}
		
		void select_square(int mx, int my)
		{
			int newi = floor((float)(mx-shift)/(float)scnx);
			int newj = floor((float)my/(float)scny);
			network[newi][newj] = (network[newi][newj] + 1)%2; //that way can alternate between values indefinitely
		}
		
		//this SHOULD be used only with NEIGHBOURS network (of size = 7*7 = 49); RETURNS SIZE OF NEIGHBOURHOOD (N)
		int set_neighbours() 
		{
			//int size = neighbourhood_size * neighbourhood_size;
			int count_n = 0;
			for (int i = 0; i < neighbourhood_size; i++) {
				for (int j = 0; j < neighbourhood_size; j++) {
					if (network[i][j] == 1) {
						neighbours_x[count_n] = i - 3;
						neighbours_y[count_n] = j - 3;
						count_n++;
					}		
				}
			}  
			return count_n; //so LOOP in evolve will go UP to, but not equalling, count_n.     
		}
		
		
		void seed()   
		{	
			float temp_rand;
			for (int i = 0; i < x; i++) {  
				for (int j = 0; j < y; j++) {  //for each node
					
					temp_rand = random(1.0);
					if (temp_rand >= weight_red) { //then choice is between blue and yellow
						if (temp_rand < (weight_red + weight_blue) ) { //so square is blue
							network[i][j] = 0; //0 for blue
						} else {
							network[i][j] = 1; //1 for yellow
						}
					} else { 
						network[i][j] = 2; //2 for red
					}
				}
			}
		}
        
		
		void evolve()
		{
			int val;
			float temp_rand;
			//1. COMPUTE NETWORK VALUES AT NEXT TIME STEP
			for (int i = 0; i < x; i++) {  
				for (int j = 0; j < y; j++) {  //for each node s in network S			
					red = 0;
					blue = 0;
					yellow = 0; //not strictly necessary but for N = 0.. 
					majority = 10; //the default value. If single dominant colour exists, this variable gets assigned that colour
					
					//1.1 FOR THE NEIGHBOURHOOD, FIND TOTALS OF EACH OF THE THREE VOTES 
					for (int n = 0; n < N; n++) {  //for each n in N
						int ndistx = neighbours_x[ n ];
						int ndisty = neighbours_y[ n ];
						
						val = network[xcor(i + ndistx)][ycor(j + ndisty)]; //intermediary value
						
						if( val == 0 ) {
							blue++;
						} else if (val == 2) {
							red++;
						}
					}
					yellow = N - blue - red;
					
					//1.2 FIND A PREFERNCE FOR THE COLOUR OF NEIGHBOURHOOD, IF IT EXISTS (the 'majority' variable), and if not, find the preference for the tie
					if (red > blue) {
						if (red > yellow) {
							majority = 2;
						} else if ( red == yellow ) {
							if (random(1.0) >= 0.5) {
								majority = 1;
							} else {
								majority = 2;
							}
						} else {
							majority = 1;
						}
					} 
					else if (red == blue ) {
						if (red > yellow) {
							if (random(1.0) >= 0.5) {
								majority = 0;
							} else {
								majority = 2;
							}
						} else if (red == yellow) {
							temp_rand = random(1.0);
							if (temp_rand < (1.0/3.0)) {
								majority = 0;
							} else if (temp_rand < (2.0/3.0) ) {
								majority = 1;
							} else {
								majority = 2;
							}
						} else {
							majority = 1;
						}
					} 
					else { //if red < blue
						if (blue < yellow) {
							majority = 1;
						} else if (blue == yellow) {
							if (random(1.0) >= 0.5) {
								majority = 0;
							} else {
								majority = 1;
							}
						} else {
							majority = 0;
						}
					}			
					
					//1.3 POPULATE TEMPORARY ARRAY BASED ON THE ERROR RATE SUPPLIED
					temp_rand = random(1.0);
					if ( temp_rand < (lambda/2.0) ) {
						temp[ i ][ j ] = (majority + 1)%3;
					} else if (temp_rand < lambda) {
						temp[ i ][ j ] = (majority + 2)%3;
					} else {
						temp[ i ][ j ] = majority;
					}
					
				} //end of loop over nodes over i
			} //end of loop over nodes over j
			
			
			
			//2. REASSIGN NETWORK VALUES
			for (int i = 0; i < x; i++) {  
				for (int j = 0; j < y; j++) {
					network[i][j] = temp[i][j];
					temp[i][j] = 0; //FOR ARRAY - DELETE FOR YOM   
				} 
			}
			
		}  
        
		
		void display(int scx, int scy)
		{
			for (int i = 0; i < x; i++) {  
				for (int j = 0; j < y; j++) {
					
					//default fill is red
					fill(255, 0, 0);
					rect(scx*i+shift,j*scy + height_diff,scx,scy); //Height Diff added here
					if (network[i][j] == 0)  {
						fill(0, 0, 255);
						rect(scx*i+shift,j*scy + height_diff,scx,scy); //Height Diff added here
					} else if (network[i][j] == 1)  {
						fill(246, 250, 53); //yellow
						rect(scx*i+shift,j*scy + height_diff,scx,scy); //Height Diff added here
					}   
				} 
			}
		}
		
		
		void display_N(int scx, int scy) //this displays the neighbourhood network (which only has two values)
		{
			for (int i = 0; i < x; i++) {  
				for (int j = 0; j < y; j++) {
					
					//default fill is white
					fill(255);
					rect(scx*i+shift,j*scy + height_diff,scx,scy); //Height Diff added here
					
					if (network[i][j] == 1)  {
						fill(255, 0, 0);
						rect(scx*i+shift,j*scy + height_diff,scx,scy); //Height Diff added here
					}
					
				}
			}
			
		}
		
		
		//double weight_on_red() {
		//	return redav;
		//}
		
		
		
		/* EXTRA FUNCTIONS
		 DISPLAY FUNCTION FOR BLACK/WHITE VISUALS. TAKES VALUES OF NETWORK AS INPUT (HYPOTHETICALY FASTER?) - NEED TO UNCOMMENT COLOURMODE IN SETUP
		 void display() {
		 for (int i = 0; i < x; i++) {  
		 for (int j = 0; j < y; j++)   {
		 stroke(network[i][j]);
		 point(i,j);            
		 }   
		 }
		 }
		 
		 DISPLAY FUNCTION WITH INFO FOR PIXELS
		 void display()
		 {
		 for (int i = 0; i < x; i++) {  
         // int sci = i * sc;
		 for (int j = 0; j < y; j++) {
		 
		 if (network[i][j]==0)  {
		 //stroke(127,0,0);   //choose colour UNCOMMENT FOR PIXEL
		 ///quickTest( i * sc, j * sc );
		 fill(250,230,231);
		 rect(sc*i,j*sc,sc,sc);
		 //point(i,j);        //colour i,jth node    UNCOMMENT FOR PIXEL
		 } 
		 else {
		 //stroke(230,10,20); //255,200,200 for light red UNCOMMENT FOR PIXEL
		 //quickTest( i * sc, j * sc );
		 //fill(255,51,0);
		 fill(204,0,0);
		 rect(sc*i,j*sc,sc,sc);
		 //point(i,j); UNCOMMENT FOR PIXEL
		 }                       
		 } 
		 }
		 }    
		 */
		
	}  //end of Network class

class RoundButton {
	int x;
	int y;
	float d;
	
	RoundButton( int xin, int yin, float diameter) {
		x = xin;
		y = yin;
		d = diameter;
	}
	
	boolean over() {
		float distX = x - mouseX;
		float distY = y - mouseY;
		
		if (sqrt(sq(distX) + sq(distY)) < d/2 ) {
			return true;
		} else {
			return false;
		}
	}
	
	void settext(String s1, String s2, boolean t ) {
		if (t) {
			fill(0, 255, 0);
			ellipse( x, y, d, d );
			fill(0);
			text(s1, x, y );	
		} else {
			fill(255, 0, 0);
			ellipse( x, y, d, d );
			fill(0);
			text(s2, x, y );
		}
	}
	
	void colour(boolean colour) {
		if(colour) {
			fill (255,0,0);
			ellipse( x, y, d, d );
		} else {
			fill (0,250,0);
			ellipse( x, y, d, d );
		}
		
	}
	
	void display() {
		fill (255);
		ellipse( x, y, d, d );
	}
	
	
}

class RectButton {
	int x;
	int y;
	int width;
	int height;
	
	RectButton( int xin, int yin, int widthin, int heightin) {
		x = xin;
		y = yin;
		width = widthin;
		height = heightin;
	}
	
	boolean over() {
		//	float distX = x - mouseX; don't need i don't think
		//	float distY = y - mouseY;
		
		if (mouseX >= x && mouseX <= x+width && 
			mouseY >= y && mouseY <= y+height) {
		    return true;
		} else {
		    return false;
		}
	}
	
	void settext(String s1, String s2, boolean t ) {
		//fill(0, 102, 153);
		fill(255);
		rect(x, y, width, height);
		//fill(255, 0, 0);
		fill(0);
		if (t) {
			text(s1, x + round( 0.125*width), y + round( 0.125*height), round( 0.75*width), round(0.85*height));	
		} else {
			text(s2, x + round( 0.125*width), y + round( 0.125*height), round( 0.75*width), round(0.85*height));
		}
	}
	
	void colour(boolean colour) {
		if(colour) {
			fill (200,0,0);
			rect( x, y, width, height );
		} else {
			fill (0,200,0);
			rect( x, y, width, height );
		}
		
	}
	
	void display() {
		fill (255);
		rect( x, y, width, height );
	}
	
	int getx(){
		return x;
	}
	
	int gety(){
		return y;
	}
	
	int getwidth(){
		return width;
	}
	
	int getheight(){
		return height;
	}
	
	
}

class Slider {
	float a;
	float b;
	float range;
	String s;
	float value;
	int xpos; // = round(appw*3/8);
	
	int bx, by, bwidth, bheight;
	
	Slider( float ain, float bin, float rangein, String sin, float parent_variable, RectButton RB) {
		a = ain;
		b = bin;
		range = rangein;
		s = sin;
		value = parent_variable;
		xpos = round( (appw*3*5/(4*8)) * (value - a)/(b - a) );
		bx = RB.getx();
		by = RB.gety();
		bwidth = RB.getwidth();
		bheight = RB.getheight();
	}
	
	void display() {
		
		String string = "" + value + ""; //???
		
		//replace button with something that looks attention-seeking and says DONE
		rectMode(CORNER);
		stroke(255);
		fill(0);
		rect(bx, by, bwidth, bheight);
		fill(255, 0, 0);
		text("DONE", bx + round( 0.125*bwidth), by + round( 0.125*bheight), round( 0.75*bwidth), round(0.85*bheight));
		rectMode(CENTER);
		textFont(font,20);
		
		//create text box
		stroke(255);
		fill(0);
		rect(round(shift + (5*appw/8)/2), round(apph/6), round((5*appw/8)/2), round(apph/6));
		fill(255, 0, 0);
		text(s, round(shift + (5*appw/8)/2), round(apph/6), round((5*appw/8)/2), round(apph/3) );
		
		//create box for numbers
		stroke(255);
		fill(0);
		rect(shift + (5*appw/8)/2, apph/2, (5*appw/8)/3, apph/3);
		fill(255);
		text(string, round(shift + (5*appw/8)/2), round(apph/2), round((5*appw/8)/2), round(apph/3));
		
		
		//create slidebar = from 1/8 to 7/8 of Net. width
		stroke(255);
		fill(0);
		rect(shift + (5*appw/8)/2,apph*11/12, (5*appw/8)*3/4, 5);
		
		
		//create slidebarhandle
		stroke(255);
		fill(0);
		rect(shift + xpos + (5*appw/8)*1/8, apph*11/12, 20, 30);
		//quad(shift+ (scx*w/16), scy*h*5/6, shift+ (scx*w*2/16), scy*h*21/24,shift+ (scx*w*3/16),scy*h*5/6, shift+ (scx*w/8), scy*h*23/24);
		//quad(shift+ (scx*w/16), 31, shift + 86, 20, shift + 69, 63, shift+ (scx*w*3/16), 76);	
		
		//resetting variables back
		rectMode(CORNER);
		stroke(0);	
		textFont(font, 10);	
		
	}
	
	boolean over_slidebar(int mx, int my) {
		return ( ((shift + xpos + (5*appw/8)/8 - 10) <= mx) && ((shift + xpos + (5*appw/8)/8 + 10) >= mx) && ((apph*11/12 + 15) >= my) && ((apph*11/12 - 15) <= my) );
	}
	
	//set x position of slidebar to x position of mouse
	void update_slidebar(int mx) {
		xpos = mx - shift - (5*appw/8)/8;
		
		float slidebarwidth = (5.0*(float)appw/8.0)*3.0/((float)4);
		float widthofbox = (slidebarwidth + 2.0)/range;
		float valueseparation = ( (float)(b - a) )/( (float)(range - 1));
		value = a + valueseparation*floor((float)xpos/widthofbox);
		value = round((100*value))/100.0;
		
	}
	
	float return_value(){
		return value;
	}
	
}
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%\\
//=============================================== END CLASSES ===================================================\\
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%\\














//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%\\
//================================================ FUNCTIONS ====================================================\\
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%\\
void mousePressed() {

if (RB1.over()) {	//if mouse is pressed over the RUN/PAUSE button
ready_to_run =! ready_to_run;	
if(evolution_on_click) {	//if, when we clicked on RUN, we had evolution on click enabled.. 
mouse_clicked = true;
}
} else if (RBinit.over()) { //if mouse is pressed over the INITIALISE button
initialised = true;
ready_to_run = false;	//clicking on actual INITIALISE button will stop the simulation
} else if(RB2.over()) {
exit();
} else if (B_display_frequency.over()) {
single_iteration =! single_iteration;		
} else if(B_evolution_on_click.over()) {
evolution_on_click =! evolution_on_click;
ready_to_run = false;
} else if (B_change_neighbourhood.over()) {
if(neighbourhood_mode){	//VITAL this loop before n_m reassignment!!! though nothing drastic happens because nNet is drawn after the initialisation loop
initialised = true;
N = nNet.set_neighbours();
/*
 for (int i = 0; i < N; i++) {
 print(" nx is " + neighbours_x[i] + " and ny is " + neighbours_y[i]);
 }
 */
height_diff = round( (apph - scy*h)/2.0); //EXTRA HEIGHT ADDED ONE	
}
neighbourhood_mode =! neighbourhood_mode; //this allows the button to be used again to exit the mode
} else if (neighbourhood_mode && (mouseX >= shift) && (mouseX <= (shift + largex)) && (mouseY >= 0) && (mouseY <= largey)) {
nNet.select_square(mouseX, mouseY);
} else if (B_framerate.over()) {	//THESE BELOW COULD BE IN REVERSE ORDER BUT THEN IF (!SLIDER_MODE) has to change
slider_mode =! slider_mode;
if (!slider_mode)
{
update_frequency = (int)Slidey.return_value();
update_ratio = round((float)myFrameRate/(float)update_frequency);
S.display(scx, scy);
}
Slidey = S_evolution_frequency;
} else if (B_initial_weight_on_red.over()) {
slider_mode =! slider_mode;
if (!slider_mode) {
weight_red = Slidey.return_value();
if ( (weight_red + weight_blue) > 1) { //then set weight on blue to be the difference
weight_blue = 1 - weight_red;
}
initialised = true; //equivalent to S.display above
}
Slidey = S_initial_weight_on_red;
} else if (B_initial_weight_on_blue.over()) {
slider_mode =! slider_mode;
if (!slider_mode) {
weight_blue = Slidey.return_value();
initialised = true; //equivalent to S.display above
}
S_initial_weight_on_blue = new Slider(0, (1 - weight_red), (ceil( (1 - weight_red)*100) + 1), "Set Initial Weight on Blue", weight_blue, B_initial_weight_on_blue);
Slidey = S_initial_weight_on_blue;
}

else if (B_lambda.over()) {
slider_mode =! slider_mode;
if (!slider_mode) {
lambda = Slidey.return_value();
//	initialised = false; //equivalent to S.display above
}
Slidey = S_lambda;
} else if (B_set_network_size.over()) {
if (!slider_mode && setting_width) { //i.e. if you press this button when NOT in SLIDER mode,
//SETTING WIDTH _ SHOULD MEAN THAT WE SET WIDTH FIRST
slider_mode = true;
Slidey = S_set_network_width; //assign Slidey
} else if (slider_mode && setting_width) {	//so now setting height
setting_width = false;  //so that next time this is pressed it will NOT go to this IF loop
setting_height = true;	//need this additional boolean to avoid mis-assignement when pressing this button from WRONG slider mode (for a different button)
temp_w = (int)Slidey.return_value();	//set PREVIOUS - i.e. width BUT HOLD SO CHANGES ARE VISIBLE ONLY AFTER HEIGHT IS SET
temp_scx = floor(sw * width_as_fraction/temp_w); //THE ONLY REASON FOR DOING THIS HERE IS THAT IT DOES JAVA DOES NOT HAVE POINTERS. AND I DON'T WANT TO CREATE A SEPARATE FUNCTION
Slidey = S_set_network_height; //reassign Slidey
//setting_width = true; //need to reset it for future changes
//setting_height = false;
} else if (slider_mode && setting_height) {
w = temp_w;
scx = temp_scx;
h = (int)Slidey.return_value();	//set PREVIOUS - i.e. height
scy = floor (sh/h);
setting_width = true;	//reset the variables
setting_height = false;
slider_mode = false;  //get out of SLIDER mode
S = new Network(w,h);
height_diff = floor( (apph - scy*h)/2.0); //EXTRA HEIGHT ADDED ONE
initialised = true;
}
} else if( (mouseX >= B_about_x && mouseX <= (B_about_x + B_about_width) ) && 
(mouseY >= B_about_y && mouseY <= (B_about_y + B_about_height) ) ) {
about_mode =! about_mode;
} else if(!slider_mode && !about_mode) //so basically can't click on screen to initialise it in SLIDER mode	
{
initialised = true;	//but will NOT stop the simulation
//ready_to_run = false; //keep if want random mouse clicking to STOP simulation
}
}

void mouseDragged() {
if (slider_mode && Slidey.over_slidebar(mouseX, mouseY) && mouse_within_range(mouseX) ) {
Slidey.update_slidebar(mouseX);
}		
}




/*THIS IS I SUPPOSE NECESSARY - since if try to see whether SLIDERBAR is within range, rather than mouse, then
 get something that i assume is the effect of NON-continuous update - slidebar gets locked on the sides*/
boolean mouse_within_range(int mx) {
return ( (mx <= (shift + (5*appw/8)*7/8)) && (mx >= (shift + (5*appw/8)/8)) );
}


//accessing coordinates when boundary conditions periodic
int xcor(int x){
while(x < 0) x+=w;
while(x > w - 1) x-=w;
return x;
}

int ycor(int y){
while(y < 0) y+=h;
while(y > h - 1) y-=h;
return y;
}