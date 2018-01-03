//import processing.opengl.PGraphicsOpenGL;



//DISPLAY
//number of boxes
int w;         
int h;    
float screen_scale_ratio = 2.0/3.0; //desired size of app as fraction of screen
float width_as_fraction = 0.625; //fraction of app screen devoted to VISUALISATION
int neighbourhood_size = 7; //odd number needed
int appw;
int apph;
//int sh;
//int sw;
int temp_w, temp_scx;
int sc, scx, scy, scnx, scny;	//for scaling the model and the neighbourhood

float rho_0;   //initial weight on "1's
float lambda; //probability of survival for reds
float nu; //for whites
boolean inertia;     //1 if in the event of an even split of n/bouring states the current nodes stays the same state (with prob (1-lambda))

int height_diff;
//variable declaration
/* Ye Old Method - heretofore abbreviated YOM
Basically, since in the default NE setting the SELF is always considered, we reassigned the variable responsible for holding
the sum of the votes of the neighbourhood to the final value of the network, anticipating having to add it up 
in the next round of evolution anyway. So the neighbours arrays had one less in them, so to calculate the average
divided by N + 1. Now ALL is variable! so the variable ("sum") gets reassigned to zero at the end of each evolution loop. 
Or somewhere more appropriate in the code. :))) 
int N = 2; //size of set "Neighbours"
int[] east = new int[N];
int[] north = new int[N];
*/
int N = 3; //the default
int ndistx, ndisty; //intermediate dummy ones
int[] neighbours_x;	//hold coords of neighbourhood of influence - obviously in relative terms
int[] neighbours_y;

int B_about_x, B_about_y, B_about_width, B_about_height;

boolean bool = true;	//a true boolean
int redtot;
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
RectButton B_nu;
RectButton B_inertia;
RectButton B_random;
RectButton B_initial_weight_on_red;
//RectButton B_generic;

//sliders
Slider S_evolution_frequency;	
Slider S_set_network_width, S_set_network_height;
Slider S_initial_weight_on_red;
Slider S_lambda;
Slider S_nu;
Slider Slidey;	//generic slider that gets re-assigned every time a slider is needed; appears in DRAW()


//====MOUSEHOVER BOOLEANS ======\\
boolean RB1over;
boolean RB2over;
boolean RBinitover;
boolean B_display_frequencyover;
boolean B_framerateover;
boolean B_framerate_changedover;

//======= RUN BOOLEANS =======\\
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
boolean tie_random;



//==== EVOLUTION SCREEN VARIABLES ====\\
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
	
	/* YOM
	east[0] = 0;
	north[0] = -1;
	east[1] = 1;
	north[1] = 0;
	*/

	neighbours_x = new int[100]; //max prebuilt network width
	neighbours_y = new int[100]; // " height
	
	//THE NORTH-EAST SETTING AS DEFAULT
	neighbours_x[0] = 0;
	neighbours_y[0] = 0;
	
	neighbours_x[1] = 0;
	neighbours_y[1] = -1;
	
	neighbours_x[2] = 1;
	neighbours_y[2] = 0;
	
	
	rho_0 = 0.5;   //initial weight on "1's
	lambda = 0.95; //probability of survival
	nu = 0.95; //probability of survival
	
	
	
	//============= DEFAULT VARIABLES ============\\
	w = 40;
	h = 40;
	setting_width = true;
	setting_height = false; //not sure if redundant, due to sequence of IFs within mousePressed() loop
	
	
	/* VERSION 2 - WHEN BOXES CAN BE RECTANGULAR AND SCREEN IS SAME SIZE ========*/
	//size of app in pixels
	//sh = round ( screen.height * screen_scale_ratio );
	//sw = round ( screen.width * screen_scale_ratio );
	//set scaling size of 'box' as, effectively, sh/h = number of pixels per box
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
	/*============================ END OF VERSION 2 ============================*/
	
	
	//========================== SETTING UP THE APPLICATION SCREEN ===========================\\
	/* VERSION 1 - WHEN ALL BOXES ARE SQUARE, AND THE DISPLAY SCREEN VARIES IN SIZE*//*
	//size of app in pixels
	sh = round ( screen.height * screen_scale_ratio );
	sw = round ( screen.width * screen_scale_ratio );
	//set scaling size of 'box' as, effectively, sh/h = number of pixels per box
	sc = min (floor (sh/h), floor(sw * width_as_fraction/w) );
	//define corresponding app width and height (height is effectively the same but width is redifined to certain ratio)
	appw = round( (1.0/0.625) * sc * w);
	apph = sc * h;

	//scaling model network (scx and scy) and neighbourhood
	scx = sc; 
	scy = sc;
	scnx = round( sc * w / neighbourhood_size);
	scny = round( sc * h / neighbourhood_size);
	*//*============================ END OF VERSION 1 ============================*/


	
	
	
	
	
	//frequency of display - without it can't set your own EVOLUTION frequency.. 
	myFrameRate = 50;
	frameRate(myFrameRate);       
	update_frequency = 10;
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
	
	//TO CHANGE NEIGHBOURHOOD - click button again to SUBMIT
	B_change_neighbourhood = new RectButton(B_xl, B_yl + B_height + namey1, B_width, B_height);
	b_n_x = B_xl;
	b_n_y = B_yl + B_height + namey1;
	b_n_w = B_width;
	b_n_h = B_height;
	//B_change_neighbourhood.settext("DONE", "Change Neighbourhood", neighbourhood_mode);

	//INERTIA
	B_inertia = new RectButton(B_xl, B_yl + 2* (B_height + namey1), B_width, B_height);
	B_random = new RectButton(B_xl, B_yl + 2* (B_height + namey1), B_width, B_height);
	//B_evolution_on_click.settext("Evolution on Click (use RUN button)","Automatic Evolution", evolution_on_click);

	//LAMBDA
	B_lambda = new RectButton(B_xl, B_yl + 3 *( B_height + namey1), B_width, B_height);
	//B_framerate.settext("Set Frame Rate", "Frame rate " + update_frequency, B_framerateover);

	//LAMBDA
	B_nu = new RectButton(B_xl, B_yl + 4 *( B_height + namey1), B_width, B_height);
	//B_framerate.settext("Set Frame Rate", "Frame rate " + update_frequency, B_framerateover);

	//NOT A BUTTON - VISUALISATION TEXT
	textFont(font, 20);
	fill(255, 0, 0);
	text("Visuals", B_xl, B_yl + round(5 *( B_height + namey1)), B_width, B_height);
	textFont(font, 10);
	

	//FREQUENCY OF EVOLUTION(FRAMERATE)
	B_framerate = new RectButton(B_xl, B_yl + round(6 *( B_height + namey1)), B_width, B_height);
	//some sort of needless initialisation could go here
	
	//EVOLUTION ON CLICK - will work when mouse clicked over the RUN button 
	B_evolution_on_click = new RectButton(B_xl, B_yl + round(7 *(B_height + namey1)), B_width, B_height);
	//B_evolution_on_click.settext("Evolution on Click (use RUN button)","Automatic Evolution", evolution_on_click);

	//SAMPLING OF DISPLAY - done 
	B_display_frequency = new RectButton(B_xl, B_yl + round(8 *(B_height + namey1)), B_width, B_height);
	//B_display_frequency.settext("Displays single iteration", "Displays bi-iteration", single_iteration);
	
	//TO CHANGE NETWORK SIZE - click button again to SUBMIT - done 
	B_set_network_size = new RectButton(B_xl, B_yl + round(9 *( B_height + namey1)), B_width, B_height);
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
	text_about = "Toom's PCA models the evolution of the state of a system consisting of (width x height) local " + 
    "states, each of which can assume two values. Update rule for any local state depends only on a parameter lambda " +
	" if the state is red, and on nu if it's white; and on the average vote of neighbourhood N at the time of update. " +
    " Local state is changed to the latter with a probability (1 - lambda/nu), and to the opposite with the probability " +
    " lambda/nu. If the neighbourhood does not have a clear preference for the average state, i.e. there is a tie between " + 
	" red and white states in the neighbourhood, then the default is for that square to become either red or white with " + 
	" equal probability. This setting can change - if Inertia is ON, the state stays the same with probability (1 - lambda/nu)" +
	" and if it's OFF, the state changes with probability ( 1 - lambda/nu). The default N, which would at first " +
	"Not appear on the zoomed in 'Change Neighbourhood' screen, is Self, North and East. No special rule is set for " +
	"empty N. When changing N inclusion of Self is not automatically assumed, so would need to select the centre square. Clicking on the animation screen while the system " +
	"is evolving restarts the process from the set initial condition, while using the 'SET'/'RESET' button stops it as well. " +
	"Parameters etc. are updated on clicks of respective 'DONE' buttons. Click the 'About' button to get rid of this screen.";
	
	
	
	//SLIDERS
	S_evolution_frequency = new Slider(1, 100, 100, "Set Frequency of Evolution", update_frequency, B_framerate);
	S_set_network_width = new Slider(1, 100, 100, "Set Network Width", w, B_set_network_size);	
	S_set_network_height = new Slider(1, 100, 100, "Set Network Height", h, B_set_network_size);
	S_initial_weight_on_red = new Slider(0, 1, 101, "Set Initial Weight on Red", rho_0, B_initial_weight_on_red);	
	S_lambda = new Slider(0, 1, 101, "Set lambda", lambda, B_lambda);
	S_nu = new Slider(0, 1, 101, "Set nu", nu, B_nu);
	

	
	
	
	
	
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
	tie_random = true;
	
	inertia = true; 
	
//	Neighbours = new ArrayList();
	

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
	B_inertia.settext("Inertia ON", "Inertia OFF", inertia);
	B_initial_weight_on_red.settext("Set Initial Weight on Red","Initial Weight \n on Red is " + rho_0, B_initial_weight_on_red.over());
	B_lambda.settext("Set Lambda", "Lambda is " + lambda, B_lambda.over());
	B_nu.settext("Set Nu", "Nu is " + nu, B_nu.over());


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
		nNet.display(scnx,scny);
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
		text("DONE", b_n_x + round( 0.125*b_n_w), b_n_y + round( 0.125*b_n_h), round( 0.75*b_n_w), round(0.85*b_n_h));
		stroke(0);
	//	rectMode(CENTER);
	//	textFont(font,20);
	}
	
	//WHEN MOUSE HOVERS OVER THE 'ABOUT' TEXT, A BOX APPEARS IN THE NETWORK AREA with info about the APP
	if (about_mode){
		stroke(0);
		fill(255);
		rect(shift + appw*5/80, apph/8, appw/2, apph*3/4);
		fill(0);
		textFont(font, 14);
		text(text_about, (shift + appw*5/80), apph/8, appw/2, apph*3/4);
		textFont(font, 10);
	}

if (tie_random) {
B_random.settext("Change from default", "Tie: random \n (default) ", B_random.over());
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
    int [] [] sum;
    
    Network(int xin, int yin) 
	{
      x = xin;
      y = yin;
      network = new int [x] [y];
      sum = new int [x] [y];    
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
	int set_neighbours() {
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
	  redtot = 0;
      
      for (int i = 0; i < x; i++) {  
        for (int j = 0; j < y; j++) {  //for each node
           
          if (random(1.0) >= rho_0) {
            network[i][j] = 0; 
		  }
          else {
            network[i][j] = 1; 
          }   
			sum[i][j] = 0;	//ARRAY THING
  		  	//sum[i][j] = network[i][j]; //YOM's KERNEL! essentially; - counting yourself as sum
 		  	redtot+=network[i][j];
        	} 
		}
	  
	   //initial weight on ones
       redav = (double)redtot/(double)(w*h);
       //print(" Initial weight on ones is " + av);
    }
        
    void evolve()
    {
      redtot = 0;


      //1. COMPUTE NETWORK VALUES AT NEXT TIME STEP
      for (int i = 0; i < x; i++) {  
        for (int j = 0; j < y; j++) {  //for each node s in network S

          float d;  //variable for total of neighbouring values (votes)
   
          //1.1 ADD VOTES OF N/HOOD 
          for (int n = 0; n < N; n++) {  //for each n in N
            //get coordinates of n relative to s=(i,j)
			/* THIS WOULD REQUIRE LESS LOOP SINCE N IS LESS BY ONE
			ndistx = east[n];
			ndisty = north[n];
			*/
            int ndistx = neighbours_x[ n ];
            int ndisty = neighbours_y[ n ];
            
            sum[i][j]+=network[xcor(i + ndistx)][ycor(j + ndisty)];
          }
             
          //1.2 CALCULATE AVERAGE VOTE OF NEIGHBOURS
          float a = sum[i][j];
		  float b = N;
          d = a / b;  

          //1.3 POPULATE THE UPDATE ARRAY   
			float cutoff = 1 - nu;
			if ( network[ i ] [ j ] == 1) { //if network is red
				cutoff = 1 - lambda;
			}
			
            //1.3a if there exists a majority 
            if (d != 0.5) {                    
              float alpha = random(1.0);
   
			  //cure with probability lambda
			  if (alpha < cutoff) {  
				sum[i][j] = round(d);
			  } else { 
				sum[i][j] = (round(d) + 1)%2; 
			  }  
                
             } else if (tie_random) { //if there is not majority
				 if (random(1.0) < 0.5) {
					 sum[ i ][ j ] = 0;
				 } else {
					 sum[ i ][ j ] = 1;
				 } 
			} else { //IF TIE IS FALSE
				 // THIS IS WHAT WAS THERE BEFORE IN THE EVENT OF A TIE -----------
				// 1.3b in the event of a tie
					 if (inertia)  {	//if node wants to stay the same              
						 if (random(1.0) < cutoff)  { 
							 sum[i][j]=network[i][j]; 
						 } else { 
							 sum[i][j]=(network[i][j]+1)%2;  
						 }
					 } else {           //if node wants to change state
						 if (random(1.0) < cutoff) { 
							 sum[i][j]=(network[i][j]+1)%2;
						 } else {
							 sum[i][j]=network[i][j];       
						 }
					 }
			} //end of 'tie' loop  

        	} //end of loop over nodes over i
      	} //end of loop over nodes over j
      
      
      //2. REASSIGN NETWORK VALUES
      for (int i = 0; i < x; i++) {  
        for (int j = 0; j < y; j++) {
          network[i][j] = sum[i][j];
		  sum[i][j] = 0; //FOR ARRAY - DELETE FOR YOM
		  redtot+= network[i][j];    
      	} 
	  }
	
	  //new weight on reds
	  redav = (double)redtot/(double)(w*h);      
    }  
        
    void display(int scx, int scy)
    {
      for (int i = 0; i < x; i++) {  
        for (int j = 0; j < y; j++) {
          
          if (network[ i ][ j ] == 0)  {
            fill(250,230,231); //white
            rect(scx*i+shift,j*scy + height_diff,scx,scy); //Height Diff added here
          } else {
            fill(204,0,0); //red
            rect(scx*i+shift,j*scy + height_diff,scx,scy); //Height Diff added here
          }                       
 		} 
	   }
    }

	double weight_on_red() {
		return redav;
	}
 


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
				rho_0 = Slidey.return_value();
				initialised = true; //equivalent to S.display above
			}
			Slidey = S_initial_weight_on_red;
		} else if (B_lambda.over()) {
				slider_mode =! slider_mode;
				if (!slider_mode) {
					lambda = Slidey.return_value();
				//	initialised = false; //equivalent to S.display above
				}
				Slidey = S_lambda;
		}  else if (B_nu.over()) {
			slider_mode =! slider_mode;
			if (!slider_mode) {
				nu = Slidey.return_value();
				//	initialised = false; //equivalent to S.display above
			}
			Slidey = S_nu;
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
			} else if(B_inertia.over()) {
							if (inertia == tie_random) {
					tie_random =! tie_random;
					inertia = true;
				} else {
					inertia = false;
				}
print( "inertia is " + inertia + " tie is " + tie_random );

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