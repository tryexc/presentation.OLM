scenario = "object location memory";
#pcl_file = "random_picture_parts.pcl";  

response_matching = simple_matching;
no_logfile = false;
default_font_size = 24;  

#active_buttons = 2;
#button_codes = 1, 2; 
#target_button_codes = 11, 12;


$vNum = 7;			#	   Y		
$hNum	= 8;		#    X
$PicHeight =150;

$spacing = '$PicHeight + $PicHeight*0.1';# number of pixels between the centers of the boxes
$PicWidth = $PicHeight;


# ------------- end header ---------------------
begin;  

# picture to show when nothing else is
picture {} default;
      
# the digit picture parts in an array
bitmap { filename = ""; width = $PicWidth; height = $PicHeight; preload = false; } presPic;


# Grid-box gray
box { height = $PicHeight; width = $PicWidth; color = 150,150,150; } frameBox;


      
# the main trial
trial {                      
   # don't end until a response
   #trial_duration = forever;
   #trial_type = first_response;  
   trial_type = fixed;
   trial_duration = 2000;
   
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

    #  picture
               bitmap presPic; # placeholder, set by PCL
					x = 0; y = 0; 
               } picStim; 
      time = 0;
     
   } stimPicEvent;  
} trial1;


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


trial {                      
 
   trial_type = fixed;
   trial_duration = 2000;

stimulus_event {
      picture { 

          text {    
         # THE CROSS
			caption = "+";
			font_size  = 48;
          }; 
			x = 0; y = 0;
		
		}Fix;
      time = 0;
     # duration = next_picture;
   } FixEvent;  
  
} trial3;



########################################################################
begin_pcl;

int picHeight = 150;
double spacing = picHeight + picHeight*0.1;	# number of pixels between the center of digits
int SPALTEN = 8;
int ZEILEN = 7;

# Intra-Pair-Time
int intraPT = 500; 			# Time between Pics in one pair
int intraPJ = 100; 				# +- Jitter
# Inter-Pair-Time
int interPT = 1750; 			# Time between two pairs
int interPJ = 200; 				# +- Jitter

int fixPresT = 1750;			# Duration of Fix-Cross presentation
int fixJittT = 200;				# Fix-Cross Jitter 
# Picture Path

####### EXTRA FUNCTIONS ##############
#start F1: Generate random jitter-Time
sub int getJitteredTime(int t, int r)
begin
	return random(t-r,t+r);
end;
#end F1

############ Randomization ################################################
#########################################################################
string picPath = "Y:/01_Studien/Experimentelle Paradigmen/Object-Location-Memory/OLM_Presentation/Ver_20220208_56_tastatur/images";
							  

string id = logfile.subject();
array<string> picPairsForMat[28][3];
#Read Items Function
####################################
sub array<string,2> getPicPairs(string picP)
begin
	int oNum = 14;
	int tNum = 14;
	int uNum = 28;
	array<string> allFiles[1];
	array<string> picsCat_U[uNum];	# -unbelebt
	int u = 1;
	array<string> picsCat_T[tNum]; 	# -Tier
	int t = 1;
	array<string> picsCat_O[oNum];	# -Obst
	int o = 1;
	# get ALL file 
	int picNum = get_directory_files(picP,  allFiles ); 			
		
	loop int i = 1 until i > picNum
		begin
			if (allFiles[i].find(".bmp") != 0)	then 							# sel. only pics
			#term.print_line(allFiles[i]);
			#term.print_line(string(u));
			array<string> strParts[1];
			allFiles[i].split("\\",strParts);
			
				if (strParts[strParts.count()].find("u") != 0)	then
					picsCat_U[u] = allFiles[i];
					#term.print_line(picsCat_U[u] );
					u = u+1;
				elseif (strParts[strParts.count()].find("t") != 0) then
					picsCat_T[t] = allFiles[i];
					#term.print_line(picsCat_T[t] );
					t = t+1;
				elseif (strParts[strParts.count()].find("o") != 0) then
					picsCat_O[o] = allFiles[i];
					#term.print_line(picsCat_O[o] );
					o = o+1;
				end;
			end;
				i = i + 1;
		end;
		#randomize Lists
	picsCat_U.shuffle();
	picsCat_T.shuffle();
	picsCat_O.shuffle();

	t = 1;
	o = 1;

	array<string> picPairs[picsCat_U.count()*2][2];

	
	int p = 1;
	loop  int i = 1 until i > picsCat_U.count()
		begin
			
			if(i<=14)then
				picPairsForMat[i][1] =  picsCat_U[i];
				picPairsForMat[i][2] =  picsCat_T[i];
				
				if(i<14)then
					picPairsForMat[i][3] =  picsCat_T[i+1];
				else
					picPairsForMat[i][3] =  picsCat_T[1];
				end;
				
				picPairs[p][1] = picPairsForMat[i][1];
				picPairs[p][2] = picPairsForMat[i][2];
				
				picPairs[p+1][1] = picPairsForMat[i][3];
				picPairs[p+1][2] = picPairsForMat[i][1];
				
				p = p +2;
			else
				picPairsForMat[i][1] =  picsCat_U[i];
				picPairsForMat[i][2] =  picsCat_O[i-14];
				
				if(i-14<14)then
					picPairsForMat[i][3] =  picsCat_O[i-14+1];
				else
					picPairsForMat[i][3] =  picsCat_O[1];
				end;
					
				picPairs[p][1] = picPairsForMat[i][1];
				picPairs[p][2] = picPairsForMat[i][2];
				
				picPairs[p+1][1] = picPairsForMat[i][3];
				picPairs[p+1][2] = picPairsForMat[i][1];
				
				p = p +2;
			
			end;
			

			i = i+1;

		end;
		term.print_line(picPairs.count());
		picPairs.shuffle();
				
		return picPairs;
end;

sub bool checkPosList(array<string> posList[])
begin
	
	loop  int i =1  until i > posList.count() - 2
		begin
			
		#	if(i==1 || i == 11) then
				
				array<string> dummy[2];
				#1
				posList[i].split(",",dummy);
				int r1= int(dummy[1]);
				int c1 =  int(dummy[2]);
				
				#2
				posList[i+1].split(",",dummy);
				int r2= int(dummy[1]);
				int c2 =  int(dummy[2]);
				
				#3
				posList[i+2].split(",",dummy);
				int r3= int(dummy[1]);
				int c3 =  int(dummy[2]);
			
				if( r1 == r2 || c1==c2 || r2 == r3 || c2 == c3) then 							 # same Col or Row
					return false;
				elseif (abs(r1-r2) == 1 && abs(c1-c2) == 1)  then							# is Neighbor
					return false;
				elseif (abs(r2-r3) == 1 && abs(c2-c3) == 1)	 then
					return false;
				end;
		
						
			i = i + 2;			
		end;
	
	return true;

end;

#Gen. Items Matrix
####################################
sub array<string,2> getPicMatrix(array<string> picPairs[][], int cols, int rows)
begin
	#int col = cols;
	#int row = rows;
	array<string> usedItems[cols*rows/2];
	array<string> picMatrix[rows][cols];
	int pairCount = picPairs.count();
	#term.print_line(pairCount);

	#Make Pos. List:
	array<string> posList[rows*cols];
	int l = 1;
	loop  int r = 1 until r > rows
	begin
		loop  int c =1  until c > cols
		begin
			posList[l] = string(r) + "," + string(c);
			l=l+1;
			
		c = c+1;	
		end;
			
		r = r+1;	
	end;
	posList.shuffle();
	
	
	loop until checkPosList(posList)
	begin
		posList.shuffle();
		
	end;
	

	int i = 1;
	loop int p = 1 until p > picPairs.count()
	begin	


			# 1
			array<string> dummy[2];
			posList[i].split(",",dummy);
			
			int r1 = int(dummy[1]);
			int c1 =  int(dummy[2]);
			
			#2
			posList[i+1].split(",",dummy);
			
			int r2= int(dummy[1]);
			int c2 =  int(dummy[2]);
			
			picMatrix[r1][c1]	= picPairs[p][1];	
			picMatrix[r2][c2]	= picPairs[p][3];
			
			i = i+2;
			#term.print_line(r1+c1);
			#term.print_line(r2+c2);		
			
			#term.print_line(picPairs[p][1]);
			#term.print_line(picPairs[p][3]);
		p = p+1;
	
	
	end;
	
	return picMatrix;
	
	
end;

###################### START ########################################

id = id +"-PairList-PosMatrix.txt";
string fullpath = logfile_directory + "/" + id;

array<string> picPairs[ZEILEN*SPALTEN][2];
array<string> picMatrix[ZEILEN][SPALTEN];

if  !file_exists(fullpath) then																																	# New Rand File
	term.print("Genearate Randomization-File subject: " + logfile.subject() +"\n");

#### Start Randomization #########
	double time1 = clock.time_double();		
	picPairs = getPicPairs(picPath);
	picMatrix = getPicMatrix(picPairsForMat, SPALTEN, ZEILEN);
	double time2 = clock.time_double();
	double deltatime = time2-time1;		
#### End Randomization #########	
	term.print_line("Matrix gen time:  " + string(deltatime));
	
	output_file ofile1 = new output_file;
	
	ofile1.open( id, false ); # don't overwrite																									#write PicPairs-List into File
	loop  int i = 1 until i > picPairs.count()
	begin
		ofile1.print( picPairs[i][1] + ";" +  picPairs[i][2] + "\n");
		i = i+1;
	end;

	ofile1.print("##\n");
	loop  int r = 1 until r > ZEILEN
	begin
		
		loop  int c = 1 until c > SPALTEN
		begin
			ofile1.print(picMatrix[r][c] + ";" );				
			c = c +1;
		end;
		ofile1.print("\n" );	
		
		r = r+1;
	end;

	ofile1.close();
else	
	term.print("Randomization-File for this subject already exists!\n");	# Rand File already exists
	input_file ifile1 = new input_file;
	ifile1.open(fullpath);
	array<string> allLines[0];
	
	term.print("Read File.\n");		
	loop until ifile1.end_of_file()																			# Read file
	begin
		allLines.add( ifile1.get_line());
		#term.print_line(allLines[i]);
		
	end;


	term.print("Get Pais.\n");		
	int i = 1;
	loop until allLines[i] == "##"																		# separate pairs and posMatrix
	begin
		
			i=i+1;
	
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
#################################################################################################
####################### End Randomization #########################################################
#start F2: Get itemPos in Matrix

sub array<int,1> getItemPos(array<string,2> picMat, string item,int rows, int cols)
begin
	array<int> out[2];
	loop int r = 1 until r > rows																										
	begin
		loop int c = 1 until c > cols																												
		begin
			if picMat[r][c] == item then
				out[2] = r;			   	# Y
				out[1] = c;			   #	X
				return out;
			end;
			
			c = c+1;
		end;
		r=r+1;
	end;
		
	return  out;
end;
#end F2

####################### Start Encoding #############################################################
#################################################################################################

# go through picPairs


	loop int i = 1 until i > picPairs.count()
	begin
				#term.print_line(picPairs[i][1]);
				
				#Pic
				#1st
				presPic.set_filename(picPairs[i][1]); 														# set bitmap filename
				presPic.set_draw_mode(1);
				presPic.load();
			
				picStim.set_part( 57,presPic );
				array<int> out[] = getItemPos(picMatrix,picPairs[i][1],ZEILEN,SPALTEN);

				picStim.set_part_x(57,(spacing * (out[1] - (SPALTEN+1)/2))-spacing/2);
				#picStim.set_part_x(41,150* (8 - (SPALTEN1)/2));
				picStim.set_part_y(57,-spacing * (out[2] - (ZEILEN+1)/2));
			
				string picName = picPairs[i][1];
			
				array<string> picNameParts[1];
				picName.split("\\",picNameParts);
				picName = picNameParts[picNameParts.count()];

				stimPicEvent.set_event_code("Pair_" +string(i)+";"+picName+";"+string(out[1])+string(out[2]));
			
				trial1.set_duration(2000);
				trial1.present();
				
				#INTRA-Break
					
				trial2.set_duration(getJitteredTime(intraPT,intraPJ));
				trial2.present();
			
				#2nd
				presPic.set_filename(picPairs[i][2]); 														 # set bitmap filename
				presPic.set_draw_mode(1);
				presPic.load();
			
				picStim.set_part( 57,presPic );
				out = getItemPos(picMatrix,picPairs[i][2],ZEILEN,SPALTEN);
			
				picStim.set_part_x(57,(spacing * (out[1] - (SPALTEN+1)/2))-spacing/2);
				#picStim.set_part_x(41,150* (8 - (SPALTEN1)/2));
				picStim.set_part_y(57,-spacing * (out[2] - (ZEILEN+1)/2));
		
				picName =  picPairs[i][2];
				picName.split("\\",picNameParts);
				picName = picNameParts[picNameParts.count()];
		
				stimPicEvent.set_event_code("Pair_" + string(i)+";"+picName+";"+string(out[1])+string(out[2]));
				trial1.set_duration(2000);
				trial1.present();
			
				#INTER-Break
				
				trial2.set_duration(getJitteredTime(interPT,interPJ));
				trial2.present();
			
				# break ###################### after 10 pairs
				#if i == 10 || i == 20 || i==30 then
				#	loop int n = 1 until n > 5
				#	begin
				#		
				#		# get a Grid-position (ramdomized)
				#		out = getItemPos(picMatrix,picPairs[random(1,picPairs.count())][2],ZEILEN,SPALTEN);

				#		Fix.set_part_x(1,(spacing * (out[1] - (SPALTEN+1)/2))-spacing/2);
				#		Fix.set_part_y(1,-spacing * (out[2] - (ZEILEN+1)/2));
					
				#		trial3.set_duration(getJitteredTime(fixPresT,fixJittT));
										
				#		trial3.present();
						
				#		n = n+1
				#		end;
					##
				#end;
							
			
	i = i + 1;
end;





