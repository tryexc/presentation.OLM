#pcl_file = "random_picture_parts.pcl";  

response_matching = simple_matching;
no_logfile = false;
default_font_size = 24;  

active_buttons = 5;
button_codes = 1, 2,3,4,5; 



$vNum = 7;			#	Y		
$hNum	= 8;		#    X
$PicHeight = 150;

$spacing = '$PicHeight + $PicHeight*0.1';# number of pixels between the centers of the boxes
$PicWidth = $PicHeight;
# ------------- end header ---------------------
begin;  

# picture to show when nothing else is
picture {} default;
      
# the digit picture parts in an array
bitmap { filename = ""; width = $PicWidth; height = $PicHeight; preload = false; } presPic;

# Grid-box gray big
box { height = $PicHeight; width = $PicWidth; color = 150,150,150; } frameBox;

# Grid-box gray small
$smalldim = '$PicHeight - 15';
box { height = $smalldim; width = $smalldim; color = 150,150,150; } frameBoxS;

# Grid-box red big
box { height = $PicHeight; width = $PicWidth; color = 255,0,0; } frameBoxRed;

# the main trial
trial {                      

	trial_duration = forever; 
	trial_type = specific_response;
	#trial_type = first_response;
	terminator_button = 1,2,3,4,5;
   
   # show the box grid
   stimulus_event {
      picture {    
         # THE GRID
         LOOP $i $hNum;
            LOOP $j $vNum; 
               box frameBox; # placeholder, set by PCL
               x = '$spacing * ($i - ($hNum-1)/2)';
               y = '$spacing * ($j - ($vNum-1)/2)';
            ENDLOOP;
         ENDLOOP; 

			# THE PIC	
         bitmap presPic; # placeholder, set by PCL
			x = 0; y = 0;
			
			# THE SELECTION FRAME
         box frameBoxRed; # placeholder, set by PCL
			x = 0; y = 0; 
			box frameBoxS; # placeholder, set by PCL
			x = 0; y = 0;
			
			
				
         } picStim; 
      time = 0;
     # duration = next_picture;
	#target_button = 1,2,3,4,5;
	response_active = true;
   } stimPicEvent;  


} trial1;

# The grid only
trial {                      
 
   trial_type = fixed;
   trial_duration = 2000;

      picture {    
         # THE GRID
         LOOP $i $hNum;
            LOOP $j $vNum; 
               box frameBox; # placeholder, set by PCL
               x = '$spacing * ($i - ($hNum-1)/2)';
               y = '$spacing * ($j - ($vNum-1)/2)';
            ENDLOOP;
         ENDLOOP; 
         }; 
      time = 0;
     
  
} trial2;

# "ghost" for writing event-logs
trial { 
stimulus_event{
nothing{};
}eWriter;
}ewTrial;

########################################################################
begin_pcl;

int picHeight = 150;
double spacing = picHeight + picHeight*0.1;	# number of pixels between the center of digits

int interPT= 2000;
int interPJ = 100;

int SPALTEN = 8;
int ZEILEN = 7;

string id = logfile.subject();



id = id +"-PairList-PosMatrix.txt";
string fullpath = logfile_directory + "/" + id;

array<string> picPairs[ZEILEN*SPALTEN/2][2];
array<string> picMatrix[ZEILEN][SPALTEN];

if  !file_exists(fullpath) then																																# File not found
	term.print_line("No subject-File found!");

else	
	term.print("Randomization-File for this subject exists!\n Load PictureMatrix information");								# Rand. File already exists
	input_file ifile1 = new input_file;
	ifile1.open(fullpath);
	array<string> allLines[0];
	
	term.print("Read File.\n");		
	loop until ifile1.end_of_file()																												# Read file
	begin
		allLines.add( ifile1.get_line());
		#term.print_line(allLines[i]);
		
	end;


	term.print("Get Pais.\n");		
	int i = 1;
	loop until allLines[i] == "##"																											# Separator pairs and posMatrix
	begin
		
			i=i+1;																																					# Get number of PicPairs
	
	end;
	
	#picPairs[i-1][2] ;
	picPairs.resize(i-1);

	
	i = 1;
	loop until allLines[i] == "##"																											
	begin
		array<string> dummy[2];
			allLines[i].split(";",dummy);
			picPairs[i][1] = dummy[1];
			picPairs[i][2] = dummy[2];
			#term.print_line(dummy[1] + "-----" + dummy[2]);
			i=i+1;
	
	end;

	term.print("Get PosMatrix.\n");		
	int matYdim = allLines.count() - i;
	array<string> dummy[0];
	allLines[allLines.count() - 1].split(";",dummy);
	int matXdim = dummy.count()-1;
	
	term.print_line("X(Cols)= " + string(matXdim) +    " -- Y(Rows)= " + string(matYdim));
	
	picMatrix[matYdim][matXdim];
	int l = 1;
	loop int j = i+1 until j > allLines.count()																											
	begin
		array<string> dummy2[matXdim];
			allLines[j].split(";",dummy2);
			picMatrix[l] = dummy2;
			l = l+1;
			j=j+1;
	end;
 	
end;
##################
sub array<int,1> getItemPos(array<string,2> picMat, string item,int rows, int cols)
begin
	array<int> out[2];
	loop int r = 1 until r > rows																										
	begin
		loop int c = 1 until c > cols																												
		begin
			if picMat[r][c] == item then
				out[2] = r;				#  Y
				out[1] = c;			   #	X
				return out;
			end;
			c = c+1;
		end;
		r=r+1;
	end;
		
	return  out;
end;
##################

#start F1: Generate random jitter-Time
sub int getJitteredTime(int t, int r)
begin
	return random(t-r,t+r);
end;
#end F1

#
sub array<int,1> getPointerPos(int pxPosX, int pxPosY, int rows, int cols)
begin
	array<int> out[2];
	loop int r = 1 until r > rows																										
	begin
		loop int c = 1 until c > cols																												
		begin
			
			double boxX = (spacing * (c - (SPALTEN+1)/2))-spacing/2;
			double boxY = -spacing * (r- (ZEILEN+1)/2);
			
			#term.print_line("[" + string(boxX) + " , " + string(boxY) + "]; [" + string(pxPosX) + " , " + string(pxPosY) + "]");
			
			#XX
			if (boxX - picHeight/2 + 1) < pxPosX && (boxX + picHeight/2 + 1) > pxPosX then
				out[1] = c;
			else
				out[1] = -1;
			end;
			
			#YY
			if (boxY - picHeight/2 + 1) < pxPosY && (boxY + picHeight/2 + 1) > pxPosY then
				out[2] = r;
			else
				out[2] = -1;
			end;
			
			if out[1] != -1 && out[2] != -1 then
				return out;
			end;
			
			#term.print_line("[" + string(out[1]) + " , " + string(out[2]) + "]");
			
			
		c = c+1;
		end;
		r=r+1;
	end;	
	return  out;
end;


############################### Start Recall #######################################
################################################################################
picPairs.shuffle();

int XX = 4;
int YY = 3;

loop int i = 1 until i > picPairs.count()
	begin
				
				XX = 4; YY = 3;
		
				#Pic
				#1st

				#int itm = random(1,2);
				int itm = 1;
				array<int> out[] = getItemPos(picMatrix,picPairs[i][itm],ZEILEN,SPALTEN);
				
				#bool freePos = false;
				#loop
				#until !freePos
				#begin
					
				#	itm = random(1,2);
				#	out = getItemPos(picMatrix,picPairs[i][itm],ZEILEN,SPALTEN);
				#	if out[1] != XX  && out[2] != YY  then
				#		freePos = true;
				#	end;
						
				#end;
				
				presPic.set_filename(picPairs[i][itm]); 														# set bitmap filename
				presPic.set_draw_mode(1);
				presPic.load();
			
				picStim.set_part( 57,presPic);
				
				picStim.set_part_x(57,(spacing * (out[1] - (SPALTEN+1)/2))-spacing/2);
				#picStim.set_part_x(41,160* (8 - (SPALTEN1)/2));
				picStim.set_part_y(57,-spacing* (out[2] - (ZEILEN+1)/2));
				
				#Selbox
				picStim.set_part_x(58,(spacing * (XX - (SPALTEN+1)/2))-spacing/2);
				#picStim.set_part_x(41,160* (8 - (SPALTEN1)/2));
				picStim.set_part_y(58,-spacing * (YY- (ZEILEN+1)/2));
				
				picStim.set_part_x(59,(spacing * (XX - (SPALTEN+1)/2))-spacing/2);
				#picStim.set_part_x(41,160* (8 - (SPALTEN1)/2));
				picStim.set_part_y(59,-spacing * (YY- (ZEILEN+1)/2));
				
				string picName = picPairs[i][itm];
				string targetPicName = "";
				array<int> out2[2];
				if itm == 1 then
					targetPicName = picPairs[i][2];
					out2 = getItemPos(picMatrix,picPairs[i][2],ZEILEN,SPALTEN);
				else
					targetPicName = picPairs[i][1];
					out2 = getItemPos(picMatrix,picPairs[i][1],ZEILEN,SPALTEN);
				end;	
			
				array<string> picNameParts[1];
				picName.split("\\",picNameParts);
				picName = picNameParts[picNameParts.count()];
				
				targetPicName.split("\\",picNameParts);
				targetPicName = picNameParts[picNameParts.count()];

				stimPicEvent.set_event_code("Pair_" +string(i)+";"+picName+";["+string(out[1])+string(out[2]) + "];Target-Item: " + targetPicName + ";["+string(out2[1])+string(out2[2])+ "]");
			
				#trial1.set_duration(2000);
				trial1.present();
				
				stimulus_data last = stimulus_manager.last_stimulus_data();
					
				loop
				until last.button() > 4
				begin
					
					if last.button() == 4 && XX < SPALTEN then
						
						XX = XX + 1;
						
					elseif last.button() == 3 && XX > 1 then
						
						XX = XX - 1;
						
					elseif last.button() == 1 && YY< ZEILEN then
						
						YY = YY + 1;
						
					elseif last.button() == 2 && YY > 1 then
						
						YY = YY - 1;
					else	
					
				   end;
								
				#Selbox
				picStim.set_part_x(58,(spacing * (XX - (SPALTEN+1)/2))-spacing/2);
				#picStim.set_part_x(41,160* (8 - (SPALTEN1)/2));
				picStim.set_part_y(58,-spacing * (YY -(ZEILEN+1)/2));
				
				picStim.set_part_x(59,(spacing * (XX - (SPALTEN+1)/2))-spacing/2);
				#picStim.set_part_x(41,160* (8 - (SPALTEN1)/2));
				picStim.set_part_y(59,-spacing * (YY- (ZEILEN+1)/2));
				
				trial1.present();
				last = stimulus_manager.last_stimulus_data();
			end;
			
			eWriter.set_event_code( "Response: [" + string(XX) + string(YY) + "]" );
	      ewTrial.present();
							
trial2.set_duration(getJitteredTime(interPT,interPJ));
trial2.present();	
term.print_line(i);
i = i +1;
end;